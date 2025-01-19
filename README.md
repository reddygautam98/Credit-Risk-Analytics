# 💳 Credit Risk Analysis Project  

# Credit Risk Analysis Project 

## 🌟 Introduction  
This project focuses on a **comprehensive credit risk analysis**, combining **Python**, **SQL**, **Excel**, and **Interactive Visualizations** to uncover insights that enhance risk management. By analyzing financial and demographic metrics, we built a pipeline that is scalable, efficient, and insightful.  

## 📚 Background  
Credit risk assessment is pivotal in financial decision-making, impacting loan approvals and portfolio health. Our analysis dives into:  
- 📊 **Key Metrics**: Income, debt, credit scores, loan amounts, and more  
- 🧩 **Correlations**: Unveiling relationships between variables to optimize decision-making  
- 🚩 **Risk Indicators**: Identifying high-risk segments to mitigate default rates  

## 🛠️ Tools & Technologies  
This project leveraged a hybrid approach, utilizing modern and traditional tools for robust analytics:  
- **🖥️ Python**: Advanced analytics with `pandas`, `NumPy`, and visualization libraries
- **💾 SQL**: Complex queries for data analysis and insights generation
- **📊 Excel**: For data preparation, pivot tables, and formula-driven analysis
- **📈 Recharts**: Interactive visualizations for better storytelling
- **🔄 ETL Pipelines**: Automated workflows for data extraction, transformation, and loading
- **📉 Statistical Models**: Regression analysis for in-depth insights

## 🚀 The Analysis  

### 1. Basic Portfolio Analysis
```sql
-- Portfolio Overview
SELECT 
    COUNT(*) as total_applications,
    ROUND(AVG(Age), 2) as avg_age,
    ROUND(AVG(Income), 2) as avg_income,
    ROUND(AVG(Loan_Amount), 2) as avg_loan_amount,
    ROUND(AVG(Credit_Score), 2) as avg_credit_score
FROM credit_risk_analysis;

-- Risk Distribution
SELECT 
    Risk_Category,
    COUNT(*) as count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM credit_risk_analysis), 2) as percentage
FROM credit_risk_analysis
GROUP BY Risk_Category
ORDER BY count DESC;
```

### 2. Loan Purpose Analysis
```sql
WITH loan_stats AS (
    SELECT 
        Loan_Purpose,
        COUNT(*) as total_applications,
        ROUND(AVG(Loan_Amount), 2) as avg_loan_amount,
        ROUND(AVG(Income), 2) as avg_income,
        ROUND(AVG(Credit_Score), 2) as avg_credit_score
    FROM credit_risk_analysis
    GROUP BY Loan_Purpose
)
SELECT 
    ls.*,
    ROUND(total_applications * 100.0 / (SELECT COUNT(*) FROM credit_risk_analysis), 2) as portfolio_share
FROM loan_stats ls
ORDER BY total_applications DESC;
```

### 3. Credit Score Segmentation
```sql
WITH credit_segments AS (
    SELECT *,
        CASE 
            WHEN Credit_Score < 580 THEN 'Poor'
            WHEN Credit_Score < 670 THEN 'Fair'
            WHEN Credit_Score < 740 THEN 'Good'
            WHEN Credit_Score < 800 THEN 'Very Good'
            ELSE 'Excellent'
        END as credit_segment
    FROM credit_risk_analysis
)
SELECT 
    credit_segment,
    COUNT(*) as total_applications,
    ROUND(AVG(Loan_Amount), 2) as avg_loan_amount,
    ROUND(AVG(Income), 2) as avg_income,
    ROUND(AVG(Debt_to_Income_Ratio), 2) as avg_dti,
    SUM(CASE WHEN Risk_Category = 'High' THEN 1 ELSE 0 END) as high_risk_count
FROM credit_segments
GROUP BY credit_segment
ORDER BY credit_segment;
```

### 4. Income Analysis
```sql
WITH ranked_income AS (
    SELECT *,
        NTILE(5) OVER (ORDER BY Income) as income_quintile
    FROM credit_risk_analysis
)
SELECT 
    income_quintile,
    MIN(Income) as min_income,
    MAX(Income) as max_income,
    ROUND(AVG(Loan_Amount), 2) as avg_loan_amount,
    ROUND(AVG(Credit_Score), 2) as avg_credit_score,
    COUNT(CASE WHEN Risk_Category = 'High' THEN 1 END) as high_risk_count
FROM ranked_income
GROUP BY income_quintile
ORDER BY income_quintile;
```

### 5. Risk Factor Correlation Analysis
```sql
SELECT 
    ROUND(CORR(Credit_Score, Loan_Amount), 4) as credit_score_loan_correlation,
    ROUND(CORR(Income, Loan_Amount), 4) as income_loan_correlation,
    ROUND(CORR(Debt_to_Income_Ratio, Loan_Amount), 4) as dti_loan_correlation,
    ROUND(CORR(Age, Loan_Amount), 4) as age_loan_correlation,
    ROUND(CORR(Delinquencies, Loan_Amount), 4) as delinquencies_loan_correlation
FROM credit_risk_analysis;
```

### 6. Delinquency Impact Analysis
```sql
SELECT 
    CASE 
        WHEN Delinquencies = 0 THEN 'No Delinquencies'
        WHEN Delinquencies BETWEEN 1 AND 3 THEN '1-3'
        WHEN Delinquencies BETWEEN 4 AND 6 THEN '4-6'
        ELSE '7+'
    END as delinquency_group,
    COUNT(*) as count,
    ROUND(AVG(Credit_Score), 2) as avg_credit_score,
    ROUND(AVG(Loan_Amount), 2) as avg_loan_amount,
    COUNT(CASE WHEN Risk_Category = 'High' THEN 1 END) as high_risk_count
FROM credit_risk_analysis
GROUP BY delinquency_group
ORDER BY delinquency_group;
```

## 📊 Key Findings

1. **Risk Distribution**
   - Analyzed the spread of risk categories across the portfolio
   - Identified key factors contributing to high-risk classifications

2. **Credit Score Impact**
   - Segmented applications by credit score ranges
   - Analyzed correlation between credit scores and loan approval rates

3. **Income Patterns**
   - Created income quintiles for detailed analysis
   - Studied the relationship between income levels and risk categories

4. **Delinquency Analysis**
   - Evaluated the impact of past delinquencies on risk assessment
   - Created delinquency groups for better risk stratification

## 🎯 Recommendations

1. **Risk Management**
   - Implement stricter credit score thresholds for high-risk categories
   - Develop specialized products for different risk segments

2. **Portfolio Optimization**
   - Balance the portfolio across risk categories
   - Adjust loan amounts based on income quintiles

3. **Monitoring System**
   - Regular tracking of delinquency patterns
   - Implementation of early warning systems

## 📈 Future Enhancements

1. **Machine Learning Integration**
   - Implement predictive models for risk assessment
   - Develop automated scoring systems

2. **Real-time Analytics**
   - Create dashboard for live monitoring
   - Implement automated alert systems

3. **Enhanced Reporting**
   - Develop automated report generation
   - Create interactive visualization dashboards

---

## 🎓 What I Learned  
- **💡 Income Isn’t Everything**: Risk segmentation revealed weak correlations between income and default likelihood.  
- **⚙️ Tool Integration**: Combining **Excel** and **Python** created a seamless, scalable workflow.  
- **📊 Data Storytelling**: Interactive dashboards drove impactful visual narratives.  
- **⏩ Automation**: ETL pipelines streamlined repetitive tasks, enhancing productivity.  
## 📸 Visualizations
📊 Visualization Components
The dashboard includes four main visualizations:
- Excel DashBoard

![Screenshot 2025-01-17 002555](https://github.com/user-attachments/assets/5d2cbc05-8625-4abc-a306-a672b0892fa4)

- Risk Distribution (Pie Chart)

![Screenshot 2025-01-17 130115](https://github.com/user-attachments/assets/013e18c4-f14c-4348-89e3-8db3baf935e3)

- Loan Purpose Distribution (Bar Chart)

![Screenshot 2025-01-17 130128](https://github.com/user-attachments/assets/8a21ed8e-d1c7-47b4-8649-808f0d1d0fc2)

- Age Distribution (Bar Chart)

![Screenshot 2025-01-17 130207](https://github.com/user-attachments/assets/43261d28-5542-461b-940a-1333e86c1d5c)

- Credit Score Distribution (Bar Chart)

![Screenshot 2025-01-17 130142](https://github.com/user-attachments/assets/88411f94-3b80-4ce4-b296-7b39f7161804)

📋 Generated Reports
The analysis generates several CSV files:

basic_stats.csv: Basic statistical measures
risk_distribution.csv: Distribution of risk categories
loan_purpose.csv: Distribution of loan purposes
employment_length.csv: Employment length distribution
age_distribution.csv: Age bracket distribution
credit_score_distribution.csv: Credit score distribution
income_quartile_analysis.csv: Risk analysis by income quartiles
correlations.csv: Correlation matrix
summary_report.csv: Combined summary

## 🧾 Key Insights  
- **Mean Income**: 💵 $112,511  
- **Average Loan**: 💰 $252,950  
- **Credit Score**: ⭐ x̄ = 576  
- **Debt-to-Income Ratio (DTI)**: 0.60 (mean)  
- **Risk Distribution**:  
  - 🔴 **High Risk**: 54.5%  
  - 🟠 **Medium Risk**: 27.3%  
  - 🟢 **Low Risk**: 18.2%  

---

## 📌 Conclusion  
This project highlights the synergy between **traditional tools like Excel** and **modern Python-based analytics**. By automating workflows, creating interactive visualizations, and diving deep into metrics, we’ve built a model that supports **data-driven decision-making** for credit risk management.  

---

## 🗂️ Repository Contents  
- 📑 **Excel Templates**: Ready-to-use for initial data prep.  
- 📜 **Python Scripts**: For cleaning, analysis, and visualization.  
- 📘 **Jupyter Notebooks**: Walkthroughs with code and outputs.  
- 📈 **Interactive Dashboards**: Built using Recharts for storytelling.  
- 📄 **Documentation**: Comprehensive guides to replicate workflows.  

---


