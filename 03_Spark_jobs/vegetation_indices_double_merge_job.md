# Vegetation Indices production job: merge double filenames

## Purpose

Some Sentinel-2 image are being processed by two different ground segments. 
This results in split tiles - L1C products with the same ingestion time but with different data.
The workflow filters out these double files, and calls this job to merge the files before calculating the Vegetation Indices.


## Characteristics

| | |
|-------------|-------------|
|[NiFi workflow](../02_Workflows_in_NIFI/)|Vegetation Indices double filename fix|
|[Spark cluster](../01_Cloud_deployment/infrastructure/spark_clusters.md)|Vegetation Indices|
|Job          |S3_prerunner_merge.py starts Docker hrvpp-biopar-wekeo that runs workflow_runner_hrvpp.py|
|Spark executor resources|1 vCPU<br>6.5GB RAM<br>|
|Nominal duration|100 min|

## Configuration

Configuration for S3_pre-runner_merge.py:

|Configuration parameter|Description|
|----------------|---------|-------------------|------------------------|
|filename|Location and name of L1C input file to be processed|

Configuration for workflow_runner_hrvpp.py

|Configuration parameter|Description|
|----------------|---------|
|product_id|Identifier of input product|
|product_location|Location of input product|
|-d|Enables the double filename fix|
|product_location2|Location of second input product|
|-v|Verbosity|
|-c|Path and name of the configuration .ini file| 
|out_dir|Output folder|
|--delete_tmp|Clean up temporary workspace upon completion|
