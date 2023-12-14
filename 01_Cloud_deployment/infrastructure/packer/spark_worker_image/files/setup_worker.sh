#!/bin/bash

PURPOSE=$1
echo "Setup ${PURPOSE} worker"

if id eouser; then
  USERNAME=eouser
elif id almalinux; then
  USERNAME=almalinux
fi

echo "Using $USERNAME"

echo "Setup extra scripts"
mv /home/$USERNAME/extra_disk /usr/local/bin/extra_disk
mv /home/$USERNAME/extra_disk_remove /usr/local/bin/extra_disk_remove
mv /home/$USERNAME/spark_params /usr/local/bin/spark_params

echo "Setup spark-worker-startpre service"
sed '15 i TimeoutStartSec=600' /etc/systemd/system/spark-worker.service -i
sed '16 i ExecStartPre=sudo /usr/local/bin/spark_params' /etc/systemd/system/spark-worker.service -i

# TS workers get an extra disk where the spark-worker service has to wait on.
if [ "${PURPOSE}" == 'ts' ]; then
  echo "Setup mout dependency for ts worker"
  #systemctl disable spark-worker
  sed '4 i RequiresMountsFor=/mnt/tmp_b' /etc/systemd/system/spark-worker.service -i
fi

# GDD-1410
echo "Manually set the clock source to prevent clockskew"
sed -r 's/GRUB_CMDLINE_LINUX_DEFAULT="(.*)"$/GRUB_CMDLINE_LINUX_DEFAULT="\1 clocksource=acpi_pm"/g' /etc/default/grub -i
grub2-mkconfig -o /boot/grub2/grub.cfg

echo "Setup disk attachment mgmt"
echo "ACTION==\"add\", SUBSYSTEM==\"block\", KERNEL==\"sd[b-f]\", RUN+=\"/usr/local/bin/extra_disk '%E{DEVNAME}'\"" >> /etc/udev/rules.d/90-disk-fs.rules
echo "ACTION==\"remove\", SUBSYSTEM==\"block\", KERNEL==\"sd[b-f]\", RUN+=\"/usr/local/bin/extra_disk_remove '%E{DEVNAME}'\"" >> /etc/udev/rules.d/90-disk-fs.rules
echo "ACTION==\"add\", SUBSYSTEM==\"block\", KERNEL==\"vd[b-f]\", RUN+=\"/usr/local/bin/extra_disk '%E{DEVNAME}'\"" >> /etc/udev/rules.d/90-disk-fs.rules
echo "ACTION==\"remove\", SUBSYSTEM==\"block\", KERNEL==\"vd[b-f]\", RUN+=\"/usr/local/bin/extra_disk_remove '%E{DEVNAME}'\"" >> /etc/udev/rules.d/90-disk-fs.rules

echo "Cleanup sudo config"
rm -vf /etc/sudoers.d/10_$USERNAME

systemctl enable spark-worker
