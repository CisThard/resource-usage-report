set -e

BASE_DIR="/home/se20n/resource-usage-report"
INTERVAL="5"
COUNT="120"

vmstat "$INTERVAL" "$COUNT" > "$BASE_DIR/raw/vmstat.txt"
