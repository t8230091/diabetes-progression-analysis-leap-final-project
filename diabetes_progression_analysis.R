################################################################################
# FINAL PROJECT SCENARIO 1: UNDERSTANDING DIABETES PROGRESSION
# Analysis Script
################################################################################

# ---------------------------------------------------------------------------- #
# 0. SETUP
# ---------------------------------------------------------------------------- #
needed_packages <- c("ggplot2", "dplyr", "broom")
for (pkg in needed_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
}
library(ggplot2)
library(dplyr)
library(broom)
options(digits = 4)

# ---------------------------------------------------------------------------- #
# 1. UNDERSTAND AND PREPARE THE DATA
# ---------------------------------------------------------------------------- #
data_file <- "diabetes.tab.txt"
diabetes <- read.table(data_file, header = TRUE, sep = "\t")
names(diabetes) <- tolower(names(diabetes))
diabetes <- diabetes %>% rename(progression = y)

# Convert categorical 'sex' variable from numeric to factor
diabetes$sex <- factor(diabetes$sex)

# Check data quality
cat("Missing values:", sum(is.na(diabetes)), "\n")
cat("Duplicated rows:", sum(duplicated(diabetes)), "\n")

# ---------------------------------------------------------------------------- #
# 2. EXPLORE THE DATA
# ---------------------------------------------------------------------------- #
# Descriptive statistics summary
descriptive_table <- diabetes %>%
  summarise(across(where(is.numeric), list(
      mean = ~mean(.x, na.rm = TRUE),
      median = ~median(.x, na.rm = TRUE),
      sd = ~sd(.x, na.rm = TRUE),
      min = ~min(.x, na.rm = TRUE),
      max = ~max(.x, na.rm = TRUE)
  )))
print(descriptive_table)

# Visualizations
ggplot(diabetes, aes(x = progression)) +
  geom_histogram(bins = 25, fill = "steelblue", colour = "white") +
  labs(title = "Distribution of Diabetes Progression", x = "Progression Measure", y = "Count") +
  theme_minimal()

ggplot(diabetes, aes(x = bmi)) +
  geom_histogram(bins = 25, fill = "darkgreen", colour = "white") +
  labs(title = "Distribution of BMI", x = "BMI", y = "Count") +
  theme_minimal()

# ---------------------------------------------------------------------------- #
# 3. INVESTIGATE RELATIONSHIPS
# ---------------------------------------------------------------------------- #
numeric_data <- diabetes %>% select(where(is.numeric))
cor_matrix <- cor(numeric_data, use = "complete.obs", method = "pearson")

# Extract strongest correlations with progression
progression_correlations <- sort(cor_matrix[, "progression"], decreasing = TRUE)
print(progression_correlations)

# Scatterplots for top variables
ggplot(diabetes, aes(x = bmi, y = progression)) +
  geom_point(alpha = 0.65, color = "darkred") +
  geom_smooth(method = "lm", se = TRUE, color = "black") +
  labs(title = "Progression vs. BMI", x = "BMI", y = "Progression Measure") +
  theme_minimal()

ggplot(diabetes, aes(x = s5, y = progression)) +
  geom_point(alpha = 0.65, color = "darkblue") +
  geom_smooth(method = "lm", se = TRUE, color = "black") +
  labs(title = "Progression vs. Serum Measurement S5", x = "Serum S5", y = "Progression Measure") +
  theme_minimal()

# ---------------------------------------------------------------------------- #
# 4. BUILD AND INTERPRET REGRESSION MODELS
# ---------------------------------------------------------------------------- #
# Simple Linear Regression
simple_model <- lm(progression ~ bmi, data = diabetes)
summary(simple_model)

# Multiple Regression
multiple_model <- lm(progression ~ bmi + bp + s5, data = diabetes)
summary(multiple_model)

# Model Comparison
model_comparison <- bind_rows(
  glance(simple_model) %>% mutate(model = "Simple: BMI"),
  glance(multiple_model) %>% mutate(model = "Multiple: BMI + BP + S5")
) %>% select(model, r.squared, adj.r.squared, sigma)
print(model_comparison)

# ---------------------------------------------------------------------------- #
# 5. EVALUATE THE ANALYSIS
# ---------------------------------------------------------------------------- #
# Diagnostic Plot
diagnostic_data <- augment(multiple_model)
ggplot(diagnostic_data, aes(x = .fitted, y = .resid)) +
  geom_point(alpha = 0.65) +
  geom_hline(yintercept = 0, linetype = 2, color = "red") +
  geom_smooth(se = FALSE, color = "blue") +
  labs(title = "Residuals vs Fitted Values (Multiple Model)", x = "Fitted Values", y = "Residuals") +
  theme_minimal()

# VIF function for Multicollinearity
manual_vif <- function(model) {
  X <- model.matrix(model)[, -1, drop = FALSE]
  vif_values <- sapply(seq_len(ncol(X)), function(i) {
    target <- X[, i]
    others <- X[, -i, drop = FALSE]
    if (ncol(others) == 0) return(1)
    r2 <- summary(lm(target ~ others))$r.squared
    1 / (1 - r2)
  })
  setNames(vif_values, colnames(X))
}
manual_vif(multiple_model)