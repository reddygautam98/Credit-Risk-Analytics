-- 1. Basic Portfolio Statistics
SELECT 
    COUNT(*) as total_applications,
    ROUND(AVG(Age), 2) as avg_age,
    ROUND(AVG(Income), 2) as avg_income,
    ROUND(AVG(Loan_Amount), 2) as avg_loan_amount,
    ROUND(AVG(Credit_Score), 2) as avg_credit_score,
    ROUND(AVG(Debt_to_Income_Ratio), 2) as avg_dti_ratio
FROM credit_risk_analysis;

-- 2. Risk Distribution
SELECT 
    Risk_Category,
    COUNT(*) as count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM credit_risk_analysis), 2) as percentage
FROM credit_risk_analysis
GROUP BY Risk_Category
ORDER BY count DESC;

-- 3. Loan Purpose Analysis
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

-- 4. Employment Length Analysis with Risk Distribution
SELECT 
    Employment_Length,
    COUNT(*) as total_count,
    ROUND(AVG(Income), 2) as avg_income,
    ROUND(AVG(Loan_Amount), 2) as avg_loan_amount,
    SUM(CASE WHEN Risk_Category = 'High' THEN 1 ELSE 0 END) as high_risk_count,
    SUM(CASE WHEN Risk_Category = 'Medium' THEN 1 ELSE 0 END) as medium_risk_count,
    SUM(CASE WHEN Risk_Category = 'Low' THEN 1 ELSE 0 END) as low_risk_count
FROM credit_risk_analysis
GROUP BY Employment_Length
ORDER BY 
    CASE Employment_Length
        WHEN '<1 year' THEN 1
        WHEN '1-3 years' THEN 2
        WHEN '4-6 years' THEN 3
        WHEN '7-10 years' THEN 4
        WHEN '>10 years' THEN 5
    END;

-- 5. Credit Score Segmentation Analysis
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
    SUM(CASE WHEN Risk_Category = 'High' THEN 1 ELSE 0 END) as high_risk_count,
    SUM(CASE WHEN Risk_Category = 'Medium' THEN 1 ELSE 0 END) as medium_risk_count,
    SUM(CASE WHEN Risk_Category = 'Low' THEN 1 ELSE 0 END) as low_risk_count
FROM credit_segments
GROUP BY credit_segment
ORDER BY 
    CASE credit_segment
        WHEN 'Poor' THEN 1
        WHEN 'Fair' THEN 2
        WHEN 'Good' THEN 3
        WHEN 'Very Good' THEN 4
        WHEN 'Excellent' THEN 5
    END;

-- 6. Income Quintile Analysis
WITH ranked_income AS (
    SELECT *,
        NTILE(5) OVER (ORDER BY Income) as income_quintile
    FROM credit_risk_analysis
)
SELECT 
    income_quintile,
    COUNT(*) as total_applications,
    MIN(Income) as min_income,
    MAX(Income) as max_income,
    ROUND(AVG(Loan_Amount), 2) as avg_loan_amount,
    ROUND(AVG(Credit_Score), 2) as avg_credit_score,
    ROUND(AVG(Debt_to_Income_Ratio), 2) as avg_dti,
    SUM(CASE WHEN Risk_Category = 'High' THEN 1 ELSE 0 END) as high_risk_count,
    SUM(CASE WHEN Risk_Category = 'Medium' THEN 1 ELSE 0 END) as medium_risk_count,
    SUM(CASE WHEN Risk_Category = 'Low' THEN 1 ELSE 0 END) as low_risk_count
FROM ranked_income
GROUP BY income_quintile
ORDER BY income_quintile;

-- 7. Delinquency Analysis
SELECT 
    COUNT(CASE WHEN Delinquencies > 0 THEN 1 END) as applications_with_delinquencies,
    ROUND(AVG(Delinquencies), 2) as avg_delinquencies,
    ROUND(AVG(CASE WHEN Delinquencies > 0 THEN Loan_Amount END), 2) as avg_loan_amount_with_delinquencies,
    ROUND(AVG(CASE WHEN Delinquencies = 0 THEN Loan_Amount END), 2) as avg_loan_amount_without_delinquencies
FROM credit_risk_analysis;

-- 8. Risk Factors Correlation Analysis
SELECT 
    ROUND(CORR(Credit_Score, Loan_Amount), 4) as credit_score_loan_correlation,
    ROUND(CORR(Income, Loan_Amount), 4) as income_loan_correlation,
    ROUND(CORR(Debt_to_Income_Ratio, Loan_Amount), 4) as dti_loan_correlation,
    ROUND(CORR(Age, Loan_Amount), 4) as age_loan_correlation,
    ROUND(CORR(Delinquencies, Loan_Amount), 4) as delinquencies_loan_correlation
FROM credit_risk_analysis;

-- 9. Late Payments Impact Analysis
SELECT 
    CASE 
        WHEN Late_Payments = 0 THEN '0'
        WHEN Late_Payments BETWEEN 1 AND 2 THEN '1-2'
        WHEN Late_Payments BETWEEN 3 AND 5 THEN '3-5'
        ELSE '6+'
    END as late_payment_group,
    COUNT(*) as total_applications,
    ROUND(AVG(Loan_Amount), 2) as avg_loan_amount,
    ROUND(AVG(Credit_Score), 2) as avg_credit_score,
    SUM(CASE WHEN Risk_Category = 'High' THEN 1 ELSE 0 END) as high_risk_count,
    SUM(CASE WHEN Risk_Category = 'Medium' THEN 1 ELSE 0 END) as medium_risk_count,
    SUM(CASE WHEN Risk_Category = 'Low' THEN 1 ELSE 0 END) as low_risk_count
FROM credit_risk_analysis
GROUP BY late_payment_group
ORDER BY 
    CASE late_payment_group
        WHEN '0' THEN 1
        WHEN '1-2' THEN 2
        WHEN '3-5' THEN 3
        WHEN '6+' THEN 4
    END;

-- 10. High Risk Application Profile
WITH risk_profile AS (
    SELECT 
        ROUND(AVG(Age), 2) as avg_age,
        ROUND(AVG(Income), 2) as avg_income,
        ROUND(AVG(Debt), 2) as avg_debt,
        ROUND(AVG(Credit_Score), 2) as avg_credit_score,
        ROUND(AVG(Loan_Amount), 2) as avg_loan_amount,
        ROUND(AVG(Delinquencies), 2) as avg_delinquencies,
        ROUND(AVG(Late_Payments), 2) as avg_late_payments,
        ROUND(AVG(Debt_to_Income_Ratio), 2) as avg_dti_ratio,
        Risk_Category
    FROM credit_risk_analysis
    GROUP BY Risk_Category
)
SELECT 
    *,
    ROUND(avg_debt * 100.0 / avg_income, 2) as debt_to_income_percent
FROM risk_profile
ORDER BY 
    CASE Risk_Category
        WHEN 'High' THEN 1
        WHEN 'Medium' THEN 2
        WHEN 'Low' THEN 3
    END;
