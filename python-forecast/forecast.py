import pandas as pd 
data = pd.read_csv('historical_annual_2024.csv')
print(data)

# Starting point: 2024 Net Income AFTER restructuring, kept on the SAME
# metric basis (net_income) as the historical data above — not EBITDA,
# so the forecast is a direct continuation of the historical series.
# = historical 2024 net_income + Scenario D's RECURRING improvement only
# (one-time cash effects like asset sale proceeds are excluded, since
# they don't repeat every year and shouldn't be compounded forward)

historical_2024_net_income = -15883
scenario_d_recurring_improvement = 6251
starting_net_income = historical_2024_net_income + scenario_d_recurring_improvement

# Growth assumptions carried over from the Excel model's scenario drivers

scenario = {
    'Base': 0.015,  # 1.5% — same as the model's Base Case 2024 Revenue Growth
    'Upside': 0.035, # 3.5% — Upside Case
    'Downside': -0.01 # -1.0% — Downside Case
}

years = [2025, 2026, 2027] # the 3 years we're projecting forward

# This will store our results as we build them
results = []

for scenario_name, growth_rate in scenario.items(): # loop through each of the 3 scenarios one at a time
    net_income = starting_net_income # reset to the 2024 starting point for each scenario
    for year in years: # loop through each future year
        net_income = net_income * (1 + growth_rate) # apply one year of growth
        results.append({'year': year, 'scenario': scenario_name, 'net_income': round(net_income,0)})
forecast_df = pd.DataFrame(results) # turn our results list into a proper table, same as historical data
print(forecast_df)

annual_improvement = 3500

net_income = starting_net_income
for year in years:
    net_income = net_income + annual_improvement
    results.append({'year': year, 'scenario': 'Turnaround (Illustrative)', 'net_income': round(net_income,0)})

    # rebuild the table now that we've added the 4th scenario
forecast_df = pd.DataFrame(results)
print(forecast_df)

forecast_df.to_csv('forecast_results.csv', index=False)

import matplotlib.pyplot as plt # matplotlib — библиотека для построения графиков

plt.figure(figsize=(10,6)) # создаём пустой холст для графика, размер в дюймах

# draw one line per scenario, so we get 4 separate lines on the same chart
for scenario_name in forecast_df['scenario'].unique(): # .unique() gets each distinct scenario name once
    scenario_data = forecast_df[forecast_df['scenario'] == scenario_name] # filter rows for just this scenario
    plt.plot(scenario_data['year'], scenario_data['net_income'], marker='o', label=scenario_name)

plt.axhline(y=0, color='gray', linestyle='--', linewidth=1) # a flat line at 0, to show the breakeven point
plt.title('Net Income Forecast 2025-2027 by Scenario')
plt.xlabel('Year')
plt.xticks(years) # force the x-axis to show only whole years: 2025, 2026, 2027 — no fractional ticks
plt.ylabel('Net Income (CAD thousands)')
plt.legend() # shows which color/line belongs to which scenario
plt.grid(True, alpha=0.3) # light grid lines in the background, easier to read values

plt.savefig('forecast_chart.png') # saves the chart as an image file in the same folder
print('Chart saved as forecast_chart.png')

