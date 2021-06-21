#!/usr/bin/env bash

# auto clean and update new chia plots directory
# change log:
# NOTICE: v2: do not need to point to /media/farm1. Just point to /media
# usage sh add_script.sh /media

# remove all plot directory in config.yaml
sed -i '/\ \ \-\ \/media\/.*$/d' ~/.chia/mainnet/config/config.yaml

# create tmp anchor - tmpdirectory
sed -i 's/\ \ plot_directories\:/\ \ plot_directories\:\n\ \ \- tmpdirectory/g' ~/.chia/mainnet/config/config.yaml

# add directory
COUNTER_DISK=0
COUNTER=0
for d in $1/*/*; do
    # chia plots add -d "$d";
    sed -i "s|\ \ plot_directories\:|\ \ plot_directories\:\n\ \ \- $d|g" ~/.chia/mainnet/config/config.yaml
    PLOT_COUNT=$(ls -lah $d/*.plot 2>/dev/null | wc -l)
    COUNTER=$((COUNTER + PLOT_COUNT))
    COUNTER_DISK=$((COUNTER_DISK + 1))
    echo -e "$COUNTER_DISK\t$d\t$PLOT_COUNT"
done

# remove anchor - tmpdirectory
sed -i '/\ \ \-\ tmpdirectory.*?$/d' ~/.chia/mainnet/config/config.yaml
echo "added $COUNTER_DISK directorie(s)"
echo "Total disk: $COUNTER_DISK"
echo "Total plot: $COUNTER"