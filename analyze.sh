#!/bin/bash

set -e

BASE_DIR='/home/se20n/resource-usage-report'

$BASE_DIR/collect.sh

#./awk.awk > output.txt # only extract cpu usage

cpu_us=$(awk '{print $13}' "$BASE_DIR/raw/vmstat.txt")
cpu_sy=$(awk '{print $14}' "$BASE_DIR/raw/vmstat.txt")

mem_free=$(awk '{print $4}' "$BASE_DIR/raw/vmstat.txt")
mem_buff=$(awk '{print $5}' "$BASE_DIR/raw/vmstat.txt")
mem_cache=$(awk '{print $6}' "$BASE_DIR/raw/vmstat.txt")

TS=$(date +%Y%m%d_%H_%M_%S)


sum_us=0
sum_sy=0
sum_free=0
sum_buff=0
sum_cache=0

first_us=true
second_us=true

first_sy=true
second_sy=true

first_free=true
second_free=true

first_buff=true
second_buff=true

first_cache=true
second_cache=true
# need to check cnt value (2 or 3)
for v in $cpu_us
do

	if $first_us; then # 첫 번쨰 us 값 제외
		first_us=false
		continue
	fi
	if $second_us; then # 두 번째 vmstat 
		second_us=false
		continue
	fi

	cnt_us=$((cnt_us + 1))
	# echo $v
	sum_us=$((sum_us + v))
done

cnt_us=$((cnt_us - 2))
avg_us=$(awk "BEGIN {printf \"%.2f\", $sum_us/$cnt_us}")

# echo "sum of cnt_us = $cnt_us"
# echo "sum of cpu_us = $sum_us"
# echo "avg of cpu_us = $avg_us"

for v in $cpu_sy
do
	
	if $first_sy; then
		first_sy=false
		continue
	fi
	if $second_sy; then
		second_sy=false
		continue
	fi

	cnt_sy=$((cnt_sy + 1))
	# echo $v
	sum_sy=$((sum_sy + v))
done

cnt_sy=$((cnt_sy - 2))
avg_sy=$(awk "BEGIN {printf \"%.2f\", $sum_sy/$cnt_sy}")

# echo "sum of cnt_sy = $cnt_sy"
# echo "sum of cpu_sy = $sum_sy"
# echo "sum of avg_sy = $avg_sy"

cpu_avg_total=$(awk "BEGIN {printf \"%.2f\", ($sum_us + $sum_sy)/($cnt_us + $cnt_sy)}")

echo "avg of cpu usage = $cpu_avg_total%"

### Memory Usage

total_mem=$(free -k | awk '/Mem:/ {print $2}')


for v in $mem_free
do

        if $first_free; then
                first_free=false
                continue
        fi
        if $second_free; then
                second_free=false
                continue
        fi

        cnt_free=$((cnt_free + 1))
        # echo $v
        sum_free=$((sum_free + v))
done

avg_free=$(awk "BEGIN {printf \"%.2f\", $sum_free/$cnt_free}")

# echo "sum of cnt_free = $cnt_free"
# echo "sum of cpu_free = $sum_free"
# echo "sum of avg_free = $avg_free"

for v in $mem_buff
do

        if $first_buff; then
                first_buff=false
                continue
        fi
        if $second_buff; then
                second_buff=false
                continue
        fi

        cnt_buff=$((cnt_buff + 1))
        # echo $v
        sum_buff=$((sum_buff + v))
done

avg_buff=$(awk "BEGIN {printf \"%.2f\", $sum_buff/$cnt_buff}")

# echo "sum of cnt_buff = $cnt_buff"
# echo "sum of cpu_buff = $sum_buff"
# echo "sum of avg_buff = $avg_buff"

for v in $mem_cache
do

        if $first_cache; then
                first_cache=false
                continue
        fi
        if $second_cache; then
                second_cache=false
                continue
        fi

        cnt_cache=$((cnt_cache + 1))
        # echo $v
        sum_cache=$((sum_cache + v))
done

avg_cache=$(awk "BEGIN {printf \"%.2f\", $sum_cache/$cnt_cache}")

# echo "sum of cnt_cache = $cnt_cache"
# echo "sum of cpu_cache = $sum_cache"
# echo "sum of avg_cache = $avg_cache"

mem_avg_total=$(awk "BEGIN {printf \"%.2f\", (($total_mem - $avg_free - $avg_buff - $avg_cache) / $total_mem) * 100 }")
echo "avg of mem usage = $mem_avg_total%" 

#echo $mem_free
#echo $mem_buff
#echo $mem_cache
# echo $total_mem

mv $BASE_DIR/reports/analyze.txt /home/se20n/resource-usage-report/reports/${TS}.txt

chmod 755 $BASE_DIR/raw/vmstat.txt
rm -f "$BASE_DIR/raw/vmstat.txt"


