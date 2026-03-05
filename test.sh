#!/bin/bash

BASE_DIR='/home/se20n/resource-usage-report'

FILE_PATH=$BASE_DIR/out/metrics.csv

calc_avg() {
	count=0
	sum=0
	for v in "$@"
	do
		if [[ $v =~ ^[0-9]+([.][0-9]+)?$ ]]; then
			count=$((count+1))
			sum=$(echo "$sum + $v" | bc)
        	fi
	done
	if (( count > 0 )); then
		echo "avg=$(echo "scale=2; $sum / $count" | bc)"
	fi
}


#function parse() {
#	$(awk '$1 ~ /^[0-9]+$/' /home/se20n/resource-usage-report/raw/vmstat.txt | awk '{print $13}' | tail -n +2)
#}


parse() {
	local col="$1"
	awk -v col="$col" '
	  $1 ~ /^[0-9]+$/ {
	    n ++
	    if (n == 1) next
	    print $col
	  }
	' /home/se20n/resource-usage-report/raw/vmstat.txt
}

# cpu_us=$(awk '$1 ~ /^[0-9]+$/' /home/se20n/resource-usage-report/raw/vmstat.txt | awk '{print $13}' | tail -n +2)

# echo $cpu_us

if [ -f "$FILE_PATH" ]; then
	echo "file exist"
else
	echo "file doesn't exist"
fi

cpu_us=$(parse 13)
cpu_sy=$(parse 14)

calc_avg $cpu_us 

cpu_avg=$(calc_avg $cpu_us)

# mem_avg=$(calc_avg $)

echo ${cpu_us}

# calc_avg $cpu_us $cpu_sy
