# Logging

## Spark worker logs

These logs are stored on three object storage buckets: hr-vpp-spark-logs-vi, hr-vpp-spark-logs-ts, hr-vpp-spark-logs-seed.
A specific [NiFi workflow](../../02_Workflows_in_NIFI/) manages these logs.

## Spark history service logs

The Spark history logs are stored in the hr-vpp-spark object storage bucket.

## NiFi workflow logs

The workflow logs are stored in object stoage buckets named hr-vpp-workflowlogs-\<year\>-\<month\>.
