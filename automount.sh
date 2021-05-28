#!/usr/bin/env bash

# lsblk | grep "└─sd" | grep -v "part /" | awk '{print $1}' | cut -c 7- | sed "s/^/\/dev\//" | xargs -n1 ~/chia-tools/rdisk.sh

lsblk > tmp_automount_log.txt
grep "└─sd" tmp_automount_log.txt > tmp_automount_log_1.txt
grep -v "part /" tmp_automount_log_1.txt > tmp_automount_log_2.txt
awk '{print $1}' tmp_automount_log_2.txt > tmp_automount_log_3.txt
sed -i "s/^\└\─/\/dev\//" tmp_automount_log_3.txt
while read p; do
  ~/chia-tools/rdisk.sh $p
done <tmp_automount_log_3.txt
rm -f tmp_automount_log*.txt
