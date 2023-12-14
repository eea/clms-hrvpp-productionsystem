#!/bin/bash
DEVICE=$1
LOGFILE='/root/extra_disk_remove.log'
SYSTEMD_FILE='/etc/systemd/system/spark-worker.service'

echo "`/usr/bin/date`: ${DEVICE}: Removed blockdevice" >> "${LOGFILE}"

echo "`/usr/bin/date`: ${DEVICE}: Unmounting blockdevice" >> "${LOGFILE}"
MOUNTPOINT="/mnt/tmp_${DEVICE: -1}"
umount -l "${MOUNTPOINT}"

MOUNTPOINT=$(echo "/mnt/tmp_${DEVICE: -1}"|sed 's+\/+\\\/+g')
echo "`/usr/bin/date`: ${DEVICE}: Cleanup fstab entry" >> "${LOGFILE}"
sed "/${MOUNTPOINT}/d" -i /etc/fstab

echo "`/usr/bin/date`: ${DEVICE}: Cleanup systemd service entry" >> "${LOGFILE}"
sed "/RequiresMountsFor=${MOUNTPOINT}/d" -i "${SYSTEMD_FILE}"

/usr/bin/systemctl daemon-reload
/usr/bin/systemctl restart spark-worker
