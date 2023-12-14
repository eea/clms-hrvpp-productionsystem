#!/bin/bash

worker_type=$1
workspace=$(terraform workspace show)
expected_workers=$(grep "spark_worker_nodes" "vars/${workspace}.tfvars" | awk '{ print $NF }')
curl -s --proxy "socks5h://0:8889" https://"${worker_type}-master-1.hrvpp2.vgt.vito.be:8480" | grep "${worker_type}-worker" | sort > "/tmp/active-workers-${worker_type}"

for i in $( seq 1 "$expected_workers"); do
  grep -q "${worker_type}-worker-${i}\.hrvpp2" "/tmp/active-workers-${worker_type}" || echo "MISSING: ${worker_type}-worker-$i"
done
