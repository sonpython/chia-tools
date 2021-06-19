#!/bin/bash

TOTAL_PLOT=0
while IFS= read -r line; do
  IP=$line
  PLOT_COUNT=$(($(ssh -n -o "StrictHostKeyChecking no" root@$IP "ls /mnt/plot/ | wc -l") - 1))
  TOTAL_PLOT=$((PLOT_COUNT + TOTAL_PLOT))
  echo -e "$IP\t$PLOT_COUNT"
done <"$1"
echo "Total Plot: $TOTAL_PLOT"
