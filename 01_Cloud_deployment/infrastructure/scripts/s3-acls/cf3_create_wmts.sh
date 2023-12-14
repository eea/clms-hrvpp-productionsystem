#!/bin/bash

function create_bucket() {
  bucket_name=$1
  echo "s3cmd -c ../../../cf3_cred/cf3_s3cmd --bucket-location=":default-placement" mb s3://$bucket_name"
  s3cmd -c ../../../cf3_cred/cf3_s3cmd --bucket-location=":default-placement" mb "s3://$bucket_name"
  sleep 1
}

for bucket in fapar lai ndvi ppi qflag2; do
  for year in 2016 2017 2018 2019 2020 2021 2022 2023; do
    # create bucket
    bucket_name="hr-vpp-wmts-${bucket}-${year}"
    create_bucket "$bucket_name"
  done
done

create_bucket hr-vpp-wmts-st-utm-010m
create_bucket hr-vpp-wmts-vpp-utm-010m
create_bucket hr-vpp-wmts-st-laea-010m
create_bucket hr-vpp-wmts-vpp-laea-010m
create_bucket hr-vpp-wmts-st-laea-100m
create_bucket hr-vpp-wmts-vpp-laea-100m
