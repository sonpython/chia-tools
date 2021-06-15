#!/bin/bash
PUBLIC_IP=$(curl -s ifconfig.me)

# Update and run chiadog prefix
sed -i "s|^notification_title_prefix.*$|notification_title_prefix: '$PUBLIC_IP'|g" /root/chiadog/config.yaml
pkill -f chiadog
nohup /root/chiadog/venv/bin/python -u /root/chiadog/main.py --config /root/chiadog/config.yaml > /root/chiadog/output.log &

# start chia harvester
/root/chia-blockchain/venv/bin/chia start harvester -r
sleep 10

# start mtail log
pkill -f mtail
cd /root/chia-blockchain/data_collect/
./run_mtail.sh > /tmp/run_mtail.log


