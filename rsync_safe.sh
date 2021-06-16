#!/bin/bash

# create vps.txt with IP of harvester per line
# 123.111.111.111
# 122.222.222.222

# make sure add ssh key from farmer to harvester
# usage ./rsync_safe.sh vps.txt

while IFS= read -r line; do
  IP=$line
  LOCK_FILE="/tmp/$IP.lock"
  if [ ! -f "$LOCK_FILE" ]; then
    trap "rm -f $LOCK_FILE" EXIT
    touch $LOCK_FILE
    FREE_SPACE=$(ssh -n -o "StrictHostKeyChecking no" root@$IP "df /dev/sdb | tail -n+2" | awk '{print $4}')
    PLOT_SIZE=108900000
    PLOT_NUM=$((FREE_SPACE / PLOT_SIZE))
    PLOT_NUM=${PLOT_NUM%.*}
    PLOT_PATH="/home/queue_plot/$IP"
    PLOT_EXISTED=$(($(ls -lah "/home/queue_plot/$IP" | wc -l) - 3))
    echo "$IP | $FREE_SPACE | $PLOT_NUM | $PLOT_EXISTED"
    PLOT_REMAIN="$(($PLOT_NUM-$PLOT_EXISTED))"
    PICK_PLOT=$PLOT_REMAIN
    if (( PICK_PLOT > 1 )) ; then
      PICK_PLOT=1
    fi
    if (( PLOT_REMAIN > 0 )) ; then
      mkdir "$PLOT_PATH"
      mv `ls /home/dest_plot/*.plot | head -$PICK_PLOT` "$PLOT_PATH"
      rsync --remove-source-files -avzP $PLOT_PATH/*.plot root@$IP:/mnt/plot/
      break
    fi
  fi
done <"$1"
