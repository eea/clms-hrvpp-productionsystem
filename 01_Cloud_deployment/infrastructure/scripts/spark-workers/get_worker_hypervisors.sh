#!/bin/bash
for i in {1..400}
do
  echo vi-worker-prd-${i}
  openstack server show vi-worker-prd-${i} | grep hostId
done
