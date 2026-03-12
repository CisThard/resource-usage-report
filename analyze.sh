#!/bin/bash

set -e

BASE_DIR='/home/se2on/resource-usage-report'
#FILE_PATH=$BASE_DIR/out/metrics.csv
# $BASE_DIR/collect.sh
# RAW=$BASE_DIR/raw/vmstat.txt

AVG_CPU=0
AVG_MEMORY=0
USAGE_DISK=0

ROOT_PATH='/mnt/c'

INTERVAL=${INTERVAL:-1}
CYCLE=${CYCLE:-5}

check_cpu() {
        local usage=0
        usage=$(mpstat ${INTERVAL} ${CYCLE} | awk '/Average:/ {print 100 - $NF}')

        AVG_CPU=${usage}
        echo "CPU: $AVG_CPU"
}

check_disk() {
        local root_path=''
        local usage=0
	local count=0

        usage=$(df -h | awk -v t="$ROOT_PATH" '$6==t {print $5+0}')
        USAGE_DISK=${usage}
        echo "DISK: $USAGE_DISK"

        # root_path=$(df -h | awk '{print $6}')
        # for i in $root_path
        # do
        #         ((count++))
        #         if [[ $i == "$ROOT_MOUNT_PATH" ]]; then
        #                 usage=$(df -h | awk '{print $5}' | awk "NR==$count")
	# 		USAGE_DISK="${usage}"
        #         fi
        # done
}

check_memory() {
        local result=0
        local usage=0

        usage=$(free -b | awk 'NR==2 { formatted = sprintf("%.2f", ($2 - $7)/$2 * 100); print formatted }')
        
        AVG_MEMORY="${usage}"

        echo "MEMORY: $AVG_MEMORY"
}

generate_report() {
        local timestamp=$(date "+%Y-%m-%d_%H:%M:%S")
        local target_file=$(date "+%Y-%m-%d_%H:%M:%S")
        check_cpu
        check_memory
	check_disk

        echo $AVG_CPU
        echo $AVG_MEMORY
        echo $USAGE_DISK

	full_report="$timestamp, ${AVG_CPU}, ${AVG_MEMORY}, ${USAGE_DISK}"

	# if echo -e "$full_report" | grep -q "CRITICAL"; then
	# 	echo -e "${RED}Warning: Check Your System${NC}"
	# fi

	local target_path="$BASE_DIR/reports/$(date +%Y%m%d)"
	[ -d "$target_path" ] || mkdir -p "$target_path"

	echo -e "$full_report" >> "$target_path/$target_file.csv"
}
generate_report


#generate_report
