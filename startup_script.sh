#!/bin/bash
PUBLIC_IP=$(curl -s ifconfig.me)

# Update and run chiadog prefix
# sed -i "s|^notification_title_prefix.*$|notification_title_prefix: '$PUBLIC_IP'|g" ~/chiadog/config.yaml
pkill -f chiadog
nohup ~/chiadog/venv/bin/python -u ~/chiadog/main.py --config ~/chiadog/config.yaml > ~/chiadog/output.log &

# start chia harvester
cd ~/chia-blockchain/
. ./activate
chia start harvester -r
sleep 10

# start mtail log
pkill -f mtail
cd ~/chia-blockchain/data_collect/
./run_mtail.sh > /tmp/run_mtail.log


