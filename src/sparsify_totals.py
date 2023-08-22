#!/usr/bin python3
import pandas as pd

#	note for future attention: there's space characters in totals.data 
#	it should be exclusively tab delim. Need to fix the spacing from the bash file

totals = pd.read_csv("./totals.data", sep='\t', header = 0 )
totals.replace(r"^ +| +$", r"", regex=True)
totals.dropna(axis=1, how='any', inplace=True)

range = set(pd.date_range(totals.iloc[0].iat[2], totals.iloc[-1].iat[2]))
greenDays = set(pd.to_datetime(totals.iloc[:,2]))
missed = list(range ^ greenDays )
missed = [ time.strftime('%Y-%m-%d') for time in missed ]

for date in missed:
	totals.loc[len(totals)] = [ 0, 0, date, 0, 0, 0, 0 ]

totals.sort_values(by='Date', inplace=True)

out = open("./totals.data", 'w')
out.write(totals.to_csv(index=False, sep='\t'))

