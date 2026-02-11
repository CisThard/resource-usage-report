#!/bin/bash
while true
do
  CPU=$(shuf -i 1-4 -n 1)
  MEM=$(shuf -i 100-500 -n 1)

  stress --cpu $CPU --vm 1 --vm-bytes ${MEM}M --timeout 30
  sleep 10
done
