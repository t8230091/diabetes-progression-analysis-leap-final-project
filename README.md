# Diabetes Progression Analysis
# Final Project Portfolio: Understanding Diabetes Progression

**Project Scenario:** Option 1 (Diabetes Progression)
**Research Question:** Which baseline patient characteristics are most strongly associated with diabetes progression after one year?

## Overview
This portfolio investigates a health dataset of 442 patients. The analysis workflow involved importing and cleaning the data, performing exploratory data analysis (EDA), generating correlation matrices to identify key physiological markers, and building simple and multiple linear regression models to predict disease progression.

## Key Findings
* **Primary Drivers:** Body Mass Index (BMI), Blood Pressure (BP), and blood serum measurement S5 are the strongest predictors of diabetes progression.
* **Model Performance:** A multiple linear regression model utilizing these three variables explains 48% of the variance in patient outcomes ($R^2 = 0.48$).
* **Limitations:** The data is purely observational. The correlations found are strong risk indicators, but they cannot establish direct medical causality. Unmeasured confounding variables (lifestyle, genetics) likely account for the remaining 52% of the variance. 

## Included Files
1. **diabetes_progression_analysis.R:** The complete, reproducible R script used for data preparation, visualization, and modeling.
2. **Analytical_Report_Scenario1.pdf:** A detailed, 4-6 page equivalent PDF answering the project's six analytical questions.
3. **Presentation.pdf:** A 6-slide executive presentation translating the statistical findings into actionable clinical insights for non-technical stakeholders.

## Reflection
This project highlighted the importance of moving beyond single-variable analysis. While BMI was a strong predictor on its own, learning to implement and interpret multiple linear regression provided a much more realistic, multi-faceted view of patient health. If I had more time, I would explore non-linear transformations for the skewed variables and attempt to apply machine learning classification to separate patients into distinct "high risk" and "low risk" categories.
