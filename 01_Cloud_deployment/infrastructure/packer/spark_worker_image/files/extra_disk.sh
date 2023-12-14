#!/bin/bash
DEVICE=$1
LOGFILE='/root/extra_disk.log'
SYSTEMD_FILE='/etc/systemd/system/spark-worker.service'
MOUNTPOINT="/mnt/tmp_${DEVICE: -1}"
CREATE_FS=1

echo "`/usr/bin/date`: ${DEVICE}: Detected new blockdevice" >> "${LOGFILE}"

mkdir "${MOUNTPOINT}"

# If a FS already exists then just exit with 0
if [ -n "$(/usr/sbin/blkid -o value -s UUID "${DEVICE}")" ]; then
  echo "`/usr/bin/date`: ${DEVICE}: Already contains an FS, skipping" >> "${LOGFILE}"
else
  echo "`/usr/bin/date`: ${DEVICE}: Creating FS" >> "${LOGFILE}"
  /usr/sbin/mkfs.ext4 -F "${DEVICE}" >> "${LOGFILE}"
  /usr/bin/udevadm trigger -c add "${DEVICE}"
fi

echo "`/usr/bin/date`: ${DEVICE}: Mounting" >> "${LOGFILE}"
mount "${DEVICE}" "${MOUNTPOINT}"

DEVICE_UUID=$(/usr/sbin/blkid "${DEVICE}" | cut -d' ' -f2 | sed 's/"//g')
echo "`/usr/bin/date`: ${DEVICE}: Fstab entry" >> "${LOGFILE}"
echo "${DEVICE_UUID} ${MOUNTPOINT} ext4 defaults 0 0" >> /etc/fstab

mount "${DEVICE}" "${MOUNTPOINT}"

if ! $( grep -q "${MOUNTPOINT}" "${SYSTEMD_FILE}" ); then
  echo "`/usr/bin/date`: ${DEVICE}: Systemd service entry" >> "${LOGFILE}"
  sed -i "4i RequiresMountsFor=${MOUNTPOINT}" "${SYSTEMD_FILE}"
fi

# ts workers are waiting on the tmp disk before starting the spark-worker.
if ! /usr/bin/systemctl is-active spark-worker > /dev/null; then
  /usr/bin/systemctl enable spark-worker
fi
