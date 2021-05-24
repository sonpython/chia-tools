#!/usr/bin/env bash

# auto clean and update new chia plots directory
# usage sh add_script.sh /media/farm4

# remove all plot directory in config.yaml
sed -i '/\ \ \-\ \/media\/.*$/d' ~/.chia/mainnet/config/config.yaml

# create tmp anchor - tmpdirectory
sed -i 's/\ \ plot_directories\:/\ \ plot_directories\:\n\ \ \- tmpdirectory/g' ~/.chia/mainnet/config/config.yaml

# add directory
COUNTER=0
for d in $1/*; do
    # chia plots add -d "$d";
    sed -i "s|\ \ plot_directories\:|\ \ plot_directories\:\n\ \ \- $d|g" ~/.chia/mainnet/config/config.yaml
    COUNTER=$((COUNTER + 1))
    echo "$COUNTER | Added $d"
done

# remove anchor - tmpdirectory
sed -i '/\ \ \-\ tmpdirectory$/d' ~/.chia/mainnet/config/config.yaml
echo "added $COUNTER directorie(s)"