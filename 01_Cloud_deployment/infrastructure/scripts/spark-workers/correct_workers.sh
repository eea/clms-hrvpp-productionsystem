#!/bin/bash

type='ts'
nok=0
ok=0
amount=0

for worker in $(openstack server list | grep "${type}-worker-" | sed 's/\s\+//g'); do
  restart_spark='no'
  node_ok='yes'
  hostname=$( echo "${worker}" | cut -d"|" -f3 | sed 's/-prd//g' )
  ip=$( echo "${worker}" | cut -d "|" -f5 | cut -d"=" -f3 )

  echo "${hostname}:${ip}"

  current_params=$(ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR $ip cat /etc/spark/worker.sh | egrep 'SPARK_(PUBLIC_DNS|LOCAL_IP)' | cut -d"=" -f2 | tr '\n' '|')
  current_ip=$( echo "${current_params}" | cut -d"|" -f1 )
  current_hostname=$( echo "${current_params}" | cut -d"|" -f2 )

  echo "${current_hostname}:${current_ip}"

  if [ "${current_hostname}" == "${hostname}.hrvpp.vgt.vito.be" ]; then
    echo "Hostname: OK"
  else
    echo "Hostname: NOK"
    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR $ip -t "sudo hostnamectl set-hostname ${hostname}.hrvpp.vgt.vito.be"
    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR $ip -t "sudo sed -i 's/^SPARK_PUBLIC_DNS=.*/SPARK_PUBLIC_DNS=${hostname}.hrvpp.vgt.vito.be/' /etc/spark/worker.sh"
    restart_spark='yes'
    node_ok='no'
  fi

  if [ "${current_ip}" == "${ip}" ]; then
    echo "IP: OK"
  else
    echo "IP: NOK"
    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR $ip -t "sudo sed -i 's/^SPARK_LOCAL_IP=.*/SPARK_LOCAL_IP=${ip}/' /etc/spark/worker.sh"
    restart_spark='yes'
    node_ok='no'
  fi

  # sometimes the disk is slow to be added to the node, this means that the startpre script doesn't pick it up
  extra_disk=$(ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR $ip lsblk | grep sdb | awk '{ print $NF }')
  if [ "${extra_disk}" == "" ]; then
    echo "DISK: No extra disk(s) detected"
  elif [ "${extra_disk}" == "disk" ]; then
    echo "DISK: NOK"
    ssh -o ConnectTimeout=300 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR $ip -t "sudo systemctl restart spark-worker-startpre"
    node_ok='no'
  else
    echo "DISK: Mounted on: ${extra_disk}"
    echo "DISK: OK"
  fi


  # A restart of the spark-worker service seemed to hang, rebooting the node was quicker in 99% of the encountered cases.
  if [ "${restart_spark}" == 'yes' ]; then
    echo "Restarting spark-worker"
    ssh -o ConnectTimeout=300 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR $ip -t "sudo shutdown -r now"
  fi

  if [ "${node_ok}" == 'no' ]; then
    nok=$(($nok+1))
  else
    ok=$(($ok+1))
  fi

  amount=$(($amount+1))
  echo '========================================'
  echo "Workers done: ${amount}"
  echo '========================================'

done

echo '========================================'
echo "OK:  $ok"
echo "NOK: $nok"
echo '========================================'
