/*
METRIC CORRECTION: net_income -> ebitda
The column "net_income" in segment_analysis_2024 does not include
depreciation, interest, or government grants — these are company-wide
items without a clean segment-level allocation basis.
Renamed to "ebitda" to accurately reflect what it measures.
*/
CREATE TABLE `valeriia.f_b_analysis.segment_analysis_ebitda_2024` AS
SELECT 
Segment,
ROUND(Revenue,0) AS Revenue,
ROUND(COGS,0) AS COGS,
ROUND(Operating_Expenses,0) AS Operating_Expenses,
ROUND(Net_Income,0) AS EBITDA

FROM `valeriia.f_b_analysis.segment_analysis_2024`
ORDER BY EBITDA ASC;