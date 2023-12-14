#!/bin/bash

# https://creodias.eu/-/bucket-sharing-using-s3-bucket-policy?inheritRedirect=true&redirect=%2Ffaq-all

cat bucket_policy.json | jq -c '.' > bucket_policy_compacted.json
# s3cmd -c s3cmd-config setpolicy bucket_policy_compacted.json s3://hr-vpp-products-vrt

year=2016
for month in 10 11 12
do
  bucket=hr-vpp-products-vi-v01-${year}-${month}
  echo "Bucket ${bucket}"
  # aws s3api --endpoint-url https://s3.waw3-1.cloudferro.com/ create-bucket --bucket ${bucket}
  s3cmd -c s3cmd-config setpolicy bucket_policy_compacted.json s3://${bucket}
done

for year in {2017..2022}
do
  bucket=hr-vpp-products-vpp-v01-${year}
  echo "Bucket ${bucket}"
  # aws s3api --endpoint-url https://s3.waw3-1.cloudferro.com/ create-bucket --bucket ${bucket}
  s3cmd -c s3cmd-config setpolicy bucket_policy_compacted.json s3://${bucket}
  bucket=hr-vpp-products-st-v01-${year}
  echo "Bucket ${bucket}"
  # aws s3api --endpoint-url https://s3.waw3-1.cloudferro.com/ create-bucket --bucket ${bucket}
  s3cmd -c s3cmd-config setpolicy bucket_policy_compacted.json s3://${bucket}
  for month in 01 02 03 04 05 06 07 08 09 10 11 12
  do
    bucket=hr-vpp-products-vi-v01-${year}-${month}
    echo "Bucket ${bucket}"
    # aws s3api --endpoint-url https://s3.waw3-1.cloudferro.com/ create-bucket --bucket ${bucket}
    s3cmd -c s3cmd-config setpolicy bucket_policy_compacted.json s3://${bucket}
  done
done

year=2023
for month in 01 02 03 04 05 06 07 08 09
do
  bucket=hr-vpp-products-vi-v01-${year}-${month}
  echo "Bucket ${bucket}"
  # aws s3api --endpoint-url https://s3.waw3-1.cloudferro.com/ create-bucket --bucket ${bucket}
  s3cmd -c s3cmd-config setpolicy bucket_policy_compacted.json s3://${bucket}
done
