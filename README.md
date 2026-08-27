# Multi-Segment F&B Business — Financial Model & Restructuring Analysis

A 3-statement financial model, scenario analysis, SQL-based restructuring
case study, Python driver-based forecast, and interactive Tableau
dashboards for a synthetic multi-segment food & beverage business
(7 segments: Italian Restaurant, Japanese Restaurant, Burger Joint,
Pizzeria, Beverage Brand, Delivery Service, Central Kitchen).

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

**3-statement model & valuation** (`excel-model/`): built Income Statement,
Balance Sheet, and Cash Flow with a revolver/term-loan debt schedule,
scenario drivers (Base/Upside/Downside), and WACC-based NPV valuation.

**Modeling gap found and fixed**: the revolver's 15% interest rate was
defined as an input assumption but never flowed into the income statement,
understating total interest expense. Corrected this by wiring revolver
interest into the P&L via a circular reference, protected by a manual
circularity switch (safe on/off toggle to prevent runaway calculation
errors). This revealed a materially larger cash shortfall than initially
modeled — Interest rose from 219 to 2,795, and the revolver hits its
$20,000K limit in **August 2024** (four months earlier than the
uncorrected model showed), with the minimum cash covenant breached for
the remainder of the year.

**Metric correction** (`sql/02_ebitda_correction.sql`): identified that a
column named `net_income` at the segment level was actually EBITDA
(Revenue − COGS − Opex only — excludes D&A, interest, and grants, which
are company-wide items with no clean segment-level allocation basis).
Renamed consistently across the SQL, Excel model, and presentation.

**Crisis exit scenario comparison** (`sql/03_crisis_exit_scenarios.sql`):
built a CTE-based SQL query comparing 4 restructuring options — closing
underperforming segments, cutting operating expenses, selling non-core
assets, and a combined approach — explicitly separating **recurring
operating impact** from **one-time cash effects**, since asset sales
affect liquidity but not EBITDA. Includes disclosed, illustrative
assumptions for severance costs and tax/transaction costs on asset sales.

**Forward-looking scenario projection** (`python-forecast/forecast.py`):
extended the analysis with a Python (pandas + matplotlib) driver-based
projection to 2025–2027, starting from 2024 Net Income adjusted for the
SQL restructuring scenario's recurring improvement. This is a **driver-based
projection, not a statistical time-series forecast** — the 6-year
historical dataset is too short for reliable trend-fitting, so growth
assumptions are carried over directly from the Excel model's Base/Upside/
Downside drivers, plus an illustrative "Turnaround" scenario (fixed annual
dollar improvement, similar to the Excel Goal Seek exercise) to show what
a path back to profitability could look like.

- *Note on methodology*: the projection combines the historical Net Income
  base (after D&A/interest, before grants) with the SQL scenario's
  EBITDA-level recurring improvement — a simplification disclosed in the
  code comments, since a full re-run of D&A/interest/grants under the
  restructured scenario was out of scope for this version.
- *Counterintuitive finding*: in this projection, "Upside" (higher revenue
  growth) produces a **worse** Net Income outcome than "Downside" — because
  percentage growth is applied to an already-negative base, so faster
  growth means a faster-growing loss. This highlights why percentage-based
  growth assumptions are not meaningful for a loss-making business; the
  Turnaround scenario (fixed-dollar annual improvement) is a more
  appropriate framing and is the only path that reaches positive Net
  Income (+868K by 2027).

**Interactive dashboards** (`tableau-dashboard/`): rebuilt the historical
trend, revenue/expense comparison, and restructuring scenario comparison
as interactive Tableau Public visuals, with hover tooltips and a
breakeven reference line.

## Share

- `presentation/` — case study slides (built in Canva) summarizing the
  model, historical trends, cash flow/sensitivity analysis, and key
  conclusions
- `sql/screenshots/` — full step-by-step BigQuery workflow (data loading,
  cleaning, verification, metric correction, and scenario analysis),
  numbered 01–10
- `python-forecast/screenshots/` — Python forecast workflow (data loading,
  code, and final chart), numbered py01–py04
- `tableau-dashboard/screenshots/` — Tableau workflow, numbered tb01–tb03
- **Live interactive dashboards:**
  - [Historical Net Income Trend & Revenue vs Expenses](https://public.tableau.com/views/f-and-b-tableau-dashboard/HistoricalNetIncomeTrend?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link) —
    switch between sheet tabs to see both views
  - [Restructuring Scenario Comparison](https://public.tableau.com/views/crisis-exit-scenarios-comparison/Sheet1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

## Act

Key findings and recommendation:
- The business is not self-sustaining: NPV remains negative (-21,294K)
  across every tested combination of discount rate (5%–25%) and government
  grant funding (0–2,400).
- The revolving credit line reaches its $20,000K limit in **August 2024**,
  after which the company breaches its minimum cash covenant for the
  remainder of the year.
- All 7 segments are unprofitable at the EBITDA level; Italian Restaurant
  and Japanese Restaurant are the largest loss drivers.
- Restructuring (closing the 2 worst segments + selling non-core assets)
  nearly closes the EBITDA gap (+11,251K combined), but is not sufficient
  on its own to restore positive Net Income by 2027 under organic growth
  assumptions — only a sustained annual improvement of ~$3,500K/year
  (Turnaround scenario) reaches breakeven, underscoring that the shortfall
  is structural, not cyclical.

## Project Structure

excel-model/ 3-statement model, scenario drivers, debt schedule, WACC/NPV
presentation/ Case study slides (Canva)
sql/ BigQuery data cleaning, metric correction, scenario analysis
sql/screenshots/ SQL workflow evidence (01–10)
python-forecast/ 2025–2027 driver-based forecast (pandas + matplotlib)
python-forecast/screenshots/ Python workflow evidence (py01–py04)
tableau-dashboard/data/ CSV exports used for Tableau
tableau-dashboard/screenshots/ Tableau workflow evidence (tb01–tb03)


## Tools Used

Google BigQuery (SQL) · Excel (3-statement modeling, WACC/NPV, scenario
analysis, circular reference handling) · Python (pandas, matplotlib) ·
Tableau Public (interactive dashboards) · Canva (presentation design)

## Author

Valeriia Evtushenko — open to opportunities in Financial Analysis / FP&A
[LinkedIn](https://www.linkedin.com/in/valeriia-evtushenko-51110a304)
