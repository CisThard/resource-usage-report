set -e

BASE_DIR="/home/se20n/resource-usage-report"
INTERVAL="1"
COUNT="10"

vmstat "$INTERVAL" "$COUNT" > "$BASE_DIR/raw/vmstat.txt" 
