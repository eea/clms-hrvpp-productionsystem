#!/bin/bash
configfile=$1

if [[ -z $configfile ]]; then
  echo 'Pass a configfile!'
  exit 1
fi

if ! [[ -f $configfile ]]; then
  echo 'Could not find configfile!'
  exit 1
fi

function apply_policy {
  local bucket=$1
  local policy=$2

  echo "s3cmd -c ${configfile} setpolicy ${policy} s3://${bucket}"
  s3cmd -c "${configfile}" setpolicy "${policy}" "s3://${bucket}"
  sleep 1
}

bucket_name='hr-vpp-auxdata-v01'
year='2016'
for month in 10 11 12; do
  apply_policy "${bucket_name}-${year}-${month}" "cf3_bucket_policy_processing.json"
done

for year in {2017..2021}; do
  for month in 01 02 03 04 05 06 07 08 09 10 11 12; do
    apply_policy "${bucket_name}-${year}-${month}" "cf3_bucket_policy_processing.json"
  done
done

year='2022'
for month in 01 02 03 04 05 06 07 08 09 10; do
  apply_policy "${bucket_name}-${year}-${month}" "cf3_bucket_policy_processing.json"
done

bucket_name='hr-vpp-workflowlogs'
year='2022'
for month in 03 04 05 06 07 08 09 10; do
  apply_policy "${bucket_name}-${year}-${month}" "cf3_bucket_policy_processing.json"
done
