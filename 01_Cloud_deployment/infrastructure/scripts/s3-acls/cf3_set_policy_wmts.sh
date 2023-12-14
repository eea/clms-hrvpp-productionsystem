#!/bin/bash

function set_policy() {
  bucket_name=$1
  echo "s3cmd -c ../../../cf3_cred/cf3_s3cmd setpolicy cf3_bucket_policy_wmts.json s3://$bucket_name"
  s3cmd -c ../../../cf3_cred/cf3_s3cmd setpolicy cf3_bucket_policy_wmts.json "s3://$bucket_name"
  sleep 1
}

for bucket in fapar lai ndvi ppi qflag2; do
  for year in 2016 2017 2018 2019 2020 2021 2022 2023; do
    # create bucket
    bucket_name="hr-vpp-wmts-${bucket}-${year}"
    set_policy "$bucket_name"
  done
done

set_policy hr-vpp-wmts-st-utm-010m
set_policy hr-vpp-wmts-vpp-utm-010m
set_policy hr-vpp-wmts-st-laea-010m
set_policy hr-vpp-wmts-vpp-laea-010m
set_policy hr-vpp-wmts-st-laea-100m
set_policy hr-vpp-wmts-vpp-laea-100m
