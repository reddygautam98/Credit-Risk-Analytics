import pandas as pd
import numpy as np

def analyze_credit_risk(input_file, output_prefix):
    """
    Analyze credit risk data and save results to CSV files
    
    Parameters:
    input_file (str): Path to input CSV file
    output_prefix (str): Prefix for output CSV files
    """
    # Read the data
    df = pd.read_csv(input_file)
    
    # Basic statistics
    basic_stats = pd.DataFrame({
        'Metric': [
            'Total Applications',
            'Average Age',
            'Average Income',
            'Average Credit Score',
            'Average Loan Amount',
            'Average Debt to Income Ratio'
        ],
        'Value': [
            len(df),
            df['Age'].mean(),
            df['Income'].mean(),
            df['Credit_Score'].mean(),
            df['Loan_Amount'].mean(),
            df['Debt_to_Income_Ratio'].mean()
        ]
    })
    basic_stats.to_csv(f'{output_prefix}_basic_stats.csv', index=False)
    
    # Risk distribution
    risk_dist = df['Risk_Category'].value_counts().reset_index()
    risk_dist.columns = ['Risk_Category', 'Count']
    risk_dist.to_csv(f'{output_prefix}_risk_distribution.csv', index=False)
    
    # Loan purpose distribution
    loan_purpose_dist = df['Loan_Purpose'].value_counts().reset_index()
    loan_purpose_dist.columns = ['Loan_Purpose', 'Count']
    loan_purpose_dist.to_csv(f'{output_prefix}_loan_purpose.csv', index=False)
    
    # Employment length distribution
    emp_dist = df['Employment_Length'].value_counts().reset_index()
    emp_dist.columns = ['Employment_Length', 'Count']
    emp_dist.to_csv(f'{output_prefix}_employment_length.csv', index=False)
    
    # Age brackets analysis
    df['Age_Bracket'] = pd.cut(df['Age'], 
                              bins=[0, 25, 35, 45, 55, float('inf')],
                              labels=['18-25', '26-35', '36-45', '46-55', '55+'])
    age_dist = df['Age_Bracket'].value_counts().reset_index()
    age_dist.columns = ['Age_Bracket', 'Count']
    age_dist.to_csv(f'{output_prefix}_age_distribution.csv', index=False)
    
    # Credit score brackets
    df['Credit_Score_Range'] = pd.cut(df['Credit_Score'],
                                     bins=[0, 579, 669, 739, 799, float('inf')],
                                     labels=['Poor (<580)', 'Fair (580-669)', 
                                            'Good (670-739)', 'Very Good (740-799)',
                                            'Excellent (800+)'])
    credit_score_dist = df['Credit_Score_Range'].value_counts().reset_index()
    credit_score_dist.columns = ['Credit_Score_Range', 'Count']
    credit_score_dist.to_csv(f'{output_prefix}_credit_score_distribution.csv', index=False)
    
    # Income quartile analysis
    df['Income_Quartile'] = pd.qcut(df['Income'], q=4, labels=['Q1', 'Q2', 'Q3', 'Q4'])
    income_risk = df.groupby(['Income_Quartile', 'Risk_Category']).size().unstack(fill_value=0)
    income_quartile_bounds = df.groupby('Income_Quartile')['Income'].agg(['min', 'max'])
    
    # Combine quartile information
    income_analysis = pd.DataFrame({
        'Quartile': income_quartile_bounds.index,
        'Min_Income': income_quartile_bounds['min'],
        'Max_Income': income_quartile_bounds['max'],
        'Low_Risk': income_risk['Low'],
        'Medium_Risk': income_risk['Medium'],
        'High_Risk': income_risk['High']
    })
    income_analysis.to_csv(f'{output_prefix}_income_quartile_analysis.csv', index=False)
    
    # Correlation analysis
    numeric_cols = ['Age', 'Income', 'Debt', 'Credit_Score', 'Loan_Amount', 
                   'Delinquencies', 'Late_Payments', 'Debt_to_Income_Ratio']
    correlations = df[numeric_cols].corr()
    correlations.to_csv(f'{output_prefix}_correlations.csv')
    
    # Create summary report
    with open(f'{output_prefix}_summary_report.csv', 'w') as f:
        f.write("Credit Risk Analysis Summary\n\n")
        
        f.write("Basic Statistics\n")
        basic_stats.to_csv(f, index=False)
        f.write("\n")
        
        f.write("Risk Distribution\n")
        risk_dist.to_csv(f, index=False)
        f.write("\n")
        
        f.write("Loan Purpose Distribution\n")
        loan_purpose_dist.to_csv(f, index=False)
        f.write("\n")
        
        f.write("Employment Length Distribution\n")
        emp_dist.to_csv(f, index=False)
        f.write("\n")
        
        f.write("Age Distribution\n")
        age_dist.to_csv(f, index=False)
        f.write("\n")
        
        f.write("Credit Score Distribution\n")
        credit_score_dist.to_csv(f, index=False)
        f.write("\n")
        
        f.write("Income Quartile Analysis\n")
        income_analysis.to_csv(f, index=False)

if __name__ == "__main__":
    # Usage example
    input_file = "Credit_Risk_Analysis_Dataset.csv"
    output_prefix = "credit_risk_analysis"
    analyze_credit_risk(input_file, output_prefix)
