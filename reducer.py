#!/usr/bin/env python

from operator import itemgetter
import sys

current_year = None
current_origin = None
current_cancels = 0

current_delay = 0
current_delay_count = 0

year = None
origin = None
total = 0
# input comes from STDIN
for line in sys.stdin:
	# remove leading and trailing whitespace
	line = line.strip()

	# parse the input we got from mapper.py
	key, data = line.split('\t')
	year, origin = key.split(',')
	delay, del_count = data.split(',')

	delay = float(delay)
	del_count = int(del_count)

	# this IF-switch only works because Hadoop sorts map output
	# by key (here: word) before it is passed to the reducer
	if current_year == year and current_origin == origin:
		#current_count += cancelled
		current_delay += delay
		current_delay_count += del_count
	else:
		if current_year and current_origin:
			# write result to STDOUT
			avg_delay = current_delay / curent_delay_count
			# print '%s\t%s\t%.2f,%s'% (current_year, current_origin, avg_delay, current_count)
			print '%s\t%s\t%.2f'% (current_year, current_origin, avg_delay)

		current_delay = delay
		curent_delay_count = del_count
		current_year = year
		current_origin = origin

# do not forget to output the last word if needed!
if current_year == year and current_origin == origin:
    avg_delay = current_delay / curent_delay_count
    # print '%s\t%s\t%.2f,%s'% (current_year, current_origin, avg_delay, current_count)
    print '%s\t%s\t%.2f'% (current_year, current_origin, avg_delay)
