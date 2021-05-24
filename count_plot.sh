#!/usr/bin/env bash

# count disk and plot in mount point
# . ./count_plot.sh /media/farm4
# output
# /media/farm4/WDA_R9DP | 90
# /media/farm4/WDU_DJ6C | 48
# /media/farm4/WDA_WDPP | 63
# Total disk: 53
# Total plot: 3636

COUNTER_DISK=0
COUNTER=0
for d in $1/*; do
  PLOT_COUNT=$(ls -lah $d/*.plot | wc -l)
  COUNTER_DISK=$((COUNTER_DISK + 1))
  COUNTER=$((COUNTER + PLOT_COUNT))
  echo "$d | $PLOT_COUNT"
done
echo "Total disk: $COUNTER_DISK"
echo "Total plot: $COUNTER"
