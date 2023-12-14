#!/bin/bash
#
# Script to check if the DNS record is available and to fix if not
#
# Expects to have access to the openstack cli tools
#
# Example:
# bash fix_dns.sh vi-worker 130 150 a

worker=$1
start=$2
end=$3
action=$4

if test -z $action; then
  action='n'
fi

if test $action != 'a'; then
  action='n'
fi

zone_id="7fae5966-df4c-472a-9e44-8a6e75c00a63"

echo "BUILDING CACHE"
openstack recordset list $zone_id --sort-column name > /tmp/hrvpp_recordset

for i in $(seq $start $end); do
  worker_name="${worker}-${i}.hrvpp.vgt.vito.be"
  ip=$( dig +short ${worker_name} )
  #echo "${worker_name} | ${ip}"


  if test -z $ip; then
    echo "RECORD NOK: ${worker_name}"
    record_id=$( grep "${worker_name}" /tmp/hrvpp_recordset | awk '{ print $2 }' )

    if test $action = 'a'; then
      openstack recordset delete ${zone_id} ${record_id}
    else
      echo "NOOP: openstack recordset delete ${zone_id} ${record_id}"
    fi
  else
    echo "RECORD OK: ${worker_name}"

  fi
done
