#!/bin/bash

# auto rename disk base on vendor and serial of the disk
# usage: . ./rdisk.sh /dev/sda

sudo apt-get install smartmontools -y &>> /dev/null
sudo apt-get install ntfsprogs -y &>> /dev/null
sudo apt-get install ntfs-3g -y &>> /dev/null

HOSTNAME=`hostname`
DISK_PATH=$1
DISK_WORK_PATH=$DISK_PATH
case "${DISK_WORK_PATH: -1}" in
    ''|*[!0-9]*) echo "Labling Disk $DISK_PATH" ;;
    *) echo "Labling Partition $DISK_PATH";
       DISK_WORK_PATH="${DISK_PATH%?}" ;;
esac

VENDOR=`lsblk -nd -o VENDOR $DISK_WORK_PATH | grep -o '^...'`
SERIAL=`sudo smartctl -i $DISK_WORK_PATH | grep 'Serial Number' | grep -o '....$'`
DISKNAME=$VENDOR"_"$SERIAL
MOUNTHOST="/media/$HOSTNAME/"
MOUNTPOINT="$MOUNTHOST$DISKNAME"
echo "Identify disk name: $DISKNAME"
echo "Umount disk $DISK_PATH"
sudo umount -f -l $DISK_PATH > /dev/null
# fix ntfs permission
sudo ntfsfix $DISK_PATH &> /dev/null
sudo e2label $DISK_PATH "$DISKNAME" > /dev/null
echo "Remount disk $DISK_PATH with new mount point $MOUNTPOINT"
sudo mkdir /media/$HOSTNAME &> /dev/null
sudo mkdir /media/$HOSTNAME/$DISKNAME &> /dev/null
sudo mount $DISK_PATH $MOUNTPOINT > /dev/null
sudo chown -R $USER:$USER $MOUNTHOST > /dev/null
sudo chmod 777 -R $MOUNTHOST > /dev/null
echo "Done!"
