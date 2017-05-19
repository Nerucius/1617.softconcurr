#!/usr/bin/env python

import sys

# input comes from STDIN (standard input)
delays = {}
cancels = {}

for line in sys.stdin:
    # remove leading and trailing whitespace
    line = line.strip()
    # split the line into words
    words = line.split(',')

    # Skip over invalid data
    try:
      year = words[0].strip()
      origin = words[16].strip()
      cancelled = bool(int(words[21].strip()))
      delay = int(words[15].strip())
    except Exception:
      continue

    # if cancelled:
    #     if origin in cancels:
    #         cancels[origin] +=1
    #     else:
    #         cancels[origin] = 1
    #     continue;

    if year in delays:
        # For normal delayed flights, check for existance and update counts
        if origin in delays[year]:
            delays[year][origin]['delay'] += delay
            delays[year][origin]['count'] += 1
        else:
            delays[year][origin] = {'delay': delay, 'count': 1}
    else:
        delays[year] = {}
        delays[year][origin] = {'delay': delay, 'count': 1}


# Output format : year,origin   avg_delay
for year in sorted(delays.keys()):
    for origin, item in delays[year].iteritems():
        print '%s,%s\t%d,%d' % (year, origin, item['delay'], item['count'])



"""
  FIELDS:
  0 Year
  1 Month
  2 DayofMonth
  3 DayOfWeek
  4 DepTime
  5 CRSDepTime
  6 ArrTime
  7 CRSArrTime
  8 UniqueCarrier
  9 FlightNum
  10 TailNum
  11 ActualElapsedTime
  12 CRSElapsedTime
  13 AirTime
  14 ArrDelay
  15 DepDelay
  16 Origin
  17 Dest
  18 Distance
  19 TaxiIn
  20 TaxiOut
  21 Cancelled
  22 CancellationCode
  23 Diverted
  24 CarrierDelay
  25 WeatherDelay
  26 NASDelay
  27 SecurityDelay
  28 LateAircraftDelay
"""
