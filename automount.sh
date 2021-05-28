#!/usr/bin/env bash

lsblk | grep "└─sd" | grep -v "part /" | awk '{print $1}' | cut -c 7- | sed "s/^/\/dev\//" | xargs -n1 ~/chia-tools/rdisk.sh