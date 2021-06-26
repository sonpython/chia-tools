#!/bin/bash

# create vps.txt with IP of harvester per line
# 123.111.111.111
# 122.222.222.222

# make sure add ssh key from farmer to harvester
# usage ./rsync_safe.sh vps.txt
# TODO: output log to separated log file for each harvester
# TODO: Catch the current rsycn process by ps aux | grep "<IP> rsync --server" instead of lock file

while IFS= read -r line; do
  IP=$line
  LOCK_FILE="/tmp/$IP.lock"
  if [ ! -f "$LOCK_FILE" ]; then
    trap "rm -f $LOCK_FILE" INT TERM EXIT
    touch $LOCK_FILE
    FREE_SPACE=$(ssh -n -o "StrictHostKeyChecking no" root@$IP "df $3 | tail -n+2" | awk '{print $4}')
    PLOT_SIZE=108900000
    PLOT_NUM=$((FREE_SPACE / PLOT_SIZE))
    PLOT_NUM=${PLOT_NUM%.*}
    BASE_PATH=$2
    PLOT_PATH="$BASE_PATH/queue_plot/$IP"
    PLOT_DEST="$BASE_PATH/dest_plot"
    mkdir -p "$PLOT_DEST"
    PLOT_EXISTED=$(ls -lah "$PLOT_PATH/*.plot" | wc -l)
    echo "$IP | $FREE_SPACE | $PLOT_NUM | $PLOT_EXISTED"
    PLOT_REMAIN="$(($PLOT_NUM-$PLOT_EXISTED))"
    PICK_PLOT=$PLOT_REMAIN
    if (( PICK_PLOT > 1 )) ; then
      PICK_PLOT=1
    fi
    if (( PLOT_REMAIN > 0 )) ; then
      mkdir -p "$PLOT_PATH"
      mv `ls $PLOT_DEST/*.plot | head -$PICK_PLOT` "$PLOT_PATH"
      rsync --remove-source-files -avzP $PLOT_PATH/*.plot root@$IP:$3
      break
    fi
  fi
done <"$1"
