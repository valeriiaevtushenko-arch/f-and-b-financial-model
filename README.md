# f-and-b-financial-model
3-statement financial model, scenario analysis, and SQL restructuring case study for a multi-segment F&amp;B business
# Multi-Segment F&B Business — Financial Model & Restructuring Analysis

A 3-statement financial model, scenario analysis, and SQL-based restructuring
case study for a synthetic multi-segment food & beverage business (7 segments:
Italian Restaurant, Japanese Restaurant, Burger Joint, Pizzeria, Beverage
Brand, Delivery Service, Central Kitchen).

**Note:** All data is synthetic, created for portfolio demonstration purposes.

Structured using the **Ask → Prepare → Process → Analyze → Share → Act**
framework from the Google Data Analytics Certificate.

---

## Ask

Three business questions drove this analysis:
1. Is the business generating enough cash from operations?
2. Can the business repay its debt?
3. What happens if government grants are reduced or removed?

## Prepare

Data sources (all synthetic, generated for this portfolio):
- `financial_data_monthly` — monthly Income Statement + Cash Flow line
  items, 2023–2024
- `historical_annual` — annual Net Income, 2019–2024
- `segment_analysis_2024` — 2024 Revenue/COGS/Opex/Net Income by business
  segment

## Process

Raw BigQuery data had several quality issues, cleaned via SQL
(`sql/01_data_cleaning.sql`):
- Trailing space in the `Operating_Expenses` column name
- Typo in the `EBIDTA` column (renamed to `EBITDA`)
- An auto-generated column name where BigQuery failed to parse a header

## Analyze

- **3-statement model & valuation** (`excel-model/`): built Income Statement,
  Balance Sheet, and Cash Flow with a revolver/term-loan debt schedule,
  scenario drivers (Base/Upside/Downside), and WACC-based NPV valuation.
- **Modeling gap found and fixed**: the revolver's 15% interest rate was
  defined as an input assumption but never flowed into the income statement,
  understating total interest expense. Corrected this by wiring revolver
  interest into the P&L via a circular reference, protected by a manual
  circularity switch (safe on/off toggle to prevent runaway calculation
  errors) — a technique used to safely model interdependent debt/cash/interest
  in 3-statement models.
- **Metric correction** (`sql/02_ebitda_correction.sql`): identified that a
  column named `net_income` at the segment level was actually EBITDA
  (Revenue − COGS − Opex only — excludes D&A, interest, and grants, which
  are company-wide items with no clean segment-level allocation basis).
  Renamed consistently across the SQL, Excel model, and presentation.
- **Crisis exit scenario comparison** (`sql/03_crisis_exit_scenarios.sql`):
  built a CTE-based SQL query comparing 4 restructuring options — closing
  underperforming segments, cutting operating expenses, selling non-core
  assets, and a combined approach — explicitly separating **recurring
  operating impact** from **one-time cash effects**, since asset sales
  affect liquidity but not EBITDA. Includes disclosed, illustrative
  assumptions for severance costs and tax/transaction costs on asset sales.

## Share

- `presentation/` — case study slides summarizing the model, historical
  trends, cash flow/sensitivity analysis, and key conclusions
- `screenshots/` — full step-by-step BigQuery workflow (data loading,
  cleaning, verification, metric correction, and scenario analysis),
  numbered 01–10
- Bar chart visualization of the 4 restructuring scenarios built directly
  in BigQuery (`screenshots/10_crisis_exit_scenarios_chart.png`)

## Act

Key findings and recommendation:
- The business is not self-sustaining: NPV remains negative across every
  tested combination of discount rate (5%–25%) and government grant funding
  (0–2,400).
- The revolving credit line reaches its $20,000K limit in **August 2024**,
  after which the company breaches its minimum cash covenant for the
  remainder of the year.
- All 7 segments are unprofitable at the EBITDA level; Italian Restaurant
  and Japanese Restaurant are the largest loss drivers.
- Restructuring (closing the 2 worst segments + selling non-core assets)
  nearly closes the EBITDA gap, but is not sufficient on its own to restore
  positive NPV once interest expense is correctly modeled — the shortfall
  is structural, not cyclical.

## Project Structure

- `excel-model/` — full 3-statement model, scenario drivers, debt schedule,
  WACC/NPV valuation
- `presentation/` — case study slides
- `sql/` — BigQuery data cleaning, metric correction, and scenario analysis
- `screenshots/` — step-by-step SQL workflow evidence

## Tools Used

Google BigQuery (SQL) · Excel (3-statement modeling, WACC/NPV, scenario
analysis, circular reference handling) · Canva (presentation)

## Author

Valeriia Evtushenko — open to opportunities in Financial Analysis / FP&A
[LinkedIn](https://www.linkedin.com/in/valeriia-evtushenko-51110a304)
