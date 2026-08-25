/*
CRISIS EXIT SCENARIOS — SEGMENT RESTRUCTURING ANALYSIS
Compares 4 restructuring options against the current baseline.
Data source: segment_analysis_ebitda_2024 (EBITDA level).
*/

WITH totals AS (
  SELECT
  SUM (EBITDA) AS total_ebitda, /*SUM() adds up EBITDA from all 7 rows into one number*/
  SUM (Operating_Expenses) AS total_opex /*SUM() adds up Operating_Expenses from all 7 rows into one number*/
FROM `valeriia.f_b_analysis.segment_analysis_ebitda_2024`
),
worst_segments AS (
SELECT
SUM(EBITDA) AS worst_ebitda /*SUM() here adds up only the 2 rows matched by WHERE below*/
FROM `valeriia.f_b_analysis.segment_analysis_ebitda_2024`
WHERE Segment IN ('Italian_Restaurant', 'Japanese_Restaurant')  /*IN() filters rows to just these 2 named segments*/
)

SELECT
'Current' AS Scenario,  /*a literal text value, not from the table — just a label for this row*/
'baseline-no action' AS Description,  /*same — a plain label describing this scenario*/
ROUND(total_ebitda,0) AS ebitda,  /*ROUND(number, 0) removes decimals, rounds to whole number*/
0 AS recurring_improvement,  /*baseline has no improvement, so it's just the number 0*/
0 AS one_time_cash_net,  /*baseline has no one-time cash effect either*/
NULL AS risk_flag  /*NULL means "no value" — no risk note for the baseline*/
FROM totals

UNION ALL  /*UNION ALL stacks this next SELECT as a new row under the one above*/

SELECT
'A - Close Worst 2 Segments',
'Close Italian + Japanese Restaurant, net of estimated severance (2 * $400K placeholder)',
ROUND(total_ebitda + ABS(worst_ebitda),0), /*ABS() converts the negative loss into a positive number, so adding it back removes the loss*/
ROUND(ABS(worst_ebitda),0),  /*ABS() again, same reasoning, just shown as its own column*/
-800, /*a fixed literal number — our placeholder severance estimate*/
'Severance estimate is a placeholder - confirm with real headcount/tenure data'
FROM totals, worst_segments /*listing 2 CTEs here lets this SELECT use columns from both at once*/

UNION ALL

SELECT
'B - 10% Opex Reduction',
'Cut Operating Expenses by 10% across all segments',
ROUND(total_ebitda + total_opex * 0.10,0), /*multiplies total_opex by 10% to get the dollar saving, then adds it to EBITDA*/
ROUND(total_opex * 0.10,0),  /*same multiplication, shown separately as its own column*/
0,
NULL
FROM totals

UNION ALL

SELECT
'C - Sell Non-Core Assets',
'One-time sale, net of 15% illustrative tax/transaction cost haircut',
ROUND(total_ebitda,0),  /*EBITDA is untouched here — selling an asset isn't an operating change*/
0,
ROUND(5000 * (1 - 0.15),0),  /*(1 - 0.15) = 0.85, so this takes 85% of 5000, i.e. cuts 15% off for tax/fees*/
'Central Kitchen may supply other segments internally - clousure risk not quantified'
FROM totals

UNION ALL

SELECT
'D - Combined (Close + Sell)',
'Close worst 2 segments AND non-core assets, both net of above adjusments',
ROUND(total_ebitda + ABS(worst_ebitda),0), /*same logic as Scenario A's ebitda calculation*/
ROUND(ABS(worst_ebitda),0),
ROUND(-800 + 5000 * (1-0.15),0), /*adds Scenario A's -800 and Scenario C's net proceeds into one combined number*/
'Combines both risk flags above - highest execution complexity'
FROM totals, worst_segments

ORDER BY ebitda DESC;  /*ORDER BY sorts rows; DESC means highest ebitda value shown first*/

