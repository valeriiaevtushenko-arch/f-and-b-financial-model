/*
DATA CLEANING
Raw data loaded into BigQuery had several quality issues: a trailing
space in the Operating_Expenses column name, a typo in the EBIDTA
column (should be EBITDA), and an auto-generated column name where
BigQuery failed to parse a header correctly. Fixed via CREATE TABLE
AS SELECT with explicit column renaming.
*/
CREATE TABLE `valeriia.f_b_analysis.financial_data_clean` AS
SELECT 
Period,
Revenue,
COGS,
Operating_Expenses,
EBIDTA AS EBITDA,
Depreciation,
Interest,
Grants,
Net_Income,
Ending_Cash,
revolver_balance
FROM `valeriia.f_b_analysis.financial_data_monthly`