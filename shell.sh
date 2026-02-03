#!/bin/bash

INTERVAL="1"
COUNT="5"

vmstat $INTERVAL $COUNT > vmstat.txt
#./awk.awk > output.txt # only extract cpu usage

cpu_us=$(awk '{print $13}' vmstat.txt)
cpu_sy=$(awk '{print $14}' vmstat.txt)

sum_us=0
sum_sy=0

first_us=true
second_us=true

for v in $cpu_us
do
	cnt_us=$((cnt_us + 1))

	if $first_us; then # 첫 번쨰 us 값 제외
		first_us=false
		continue
	fi
	if $second_us; then # 두 번째 vmstat 
		second_us=false
		continue
	fi
	echo $v
	sum_us=$((sum_us + v))
done

cnt_us=$((cnt_us - 2))
avg_us=$(awk "BEGIN {printf \"%.2f\", $sum_us/$cnt_us}")

echo "sum of cnt_us = $cnt_us"
echo "sum of cpu_us = $sum_us"
echo "avg of cpu_us = $avg_us"

first_sy=true
second_sy=true

for v in $cpu_sy
do
	cnt_sy=$((cnt_sy + 1))
	
	if $first_sy; then
		first_sy=false
		continue
	fi
	if $second_sy; then
		second_sy=false
		continue
	fi
	echo $v
	sum_sy=$((sum_sy + v))
done

cnt_sy=$((cnt_sy - 2))
avg_sy=$(awk "BEGIN {printf \"%.2f\", $sum_sy/$cnt_sy}")

echo "sum of cnt_sy = $cnt_sy"
echo "sum of cpu_sy = $sum_sy"
echo "sum of avg_sy = $avg_sy"

avg_total=$(awk "BEGIN {printf \"%.2f\", ($sum_us + $sum_sy)/($cnt_us + $cnt_sy)}")

echo "avg of cpu usage = $avg_total%"
