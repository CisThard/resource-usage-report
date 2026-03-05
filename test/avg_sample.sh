#!/bin/bash


cpu_usage_avg=$(paste <(parse 13) <(parse 14) | \
awk '
{
    sum += ($1 + $2)
    count++
}
END {
    if (count > 0)
        printf "%.2f\n", sum / count
}')

mem_usage_avg=$(paste <(parse 4) <(parse 5) <(parse 6) | \
awk -v total="$mem_total" '
{
    sum += 1 - (($1 + $2 + $3) / total)
    count++
}
END {
    if (count > 0)
        printf "%.2f\n", sum / count
}')

echo "cpu_total: $cpu_total"
echo "mem_total: $mem_total"
echo "cpu_avg: $cpu_usage_avg"
echo "mem_avg: $mem_usage_avg"
