# Vegetation Indices production job

## Purpose

This job produces the Vegetation Indices (NDVI, LAI, FAPAR, PPI) and quality flag (QFLAG2) from the input Sentinel-2 L1C files.


## Characteristics

| | |
|-------------|-------------|
|[NiFi workflow](../02_Workflows_in_NIFI/)|Vegetation Indices production|
|[Spark cluster](../01_Cloud_deployment/infrastructure/spark_clusters.md)|Vegetation Indices|
|Job          |S3_prerunner.py starts Docker hrvpp-biopar-wekeo<br>that runs workflow_runner_hrvpp.py|
|Spark executor resources|1 vCPU<br>6.5GB RAM<br>|
|Nominal duration|50 min|

## Configuration

Configuration for S3_pre-runner.py:

|Configuration parameter|Description|
|----------------|---------|-------------------|------------------------|
|filename|Location and name of L1C input file to be processed|

Configuration for workflow_runner_hrvpp.py

|Configuration parameter|Description|
|----------------|---------|
|product_id|Identifier of input product|
|product_location|Location of input product|
|-v|Verbosity|
|-c|Path and name of the configuration .ini file| 
|out_dir|Output folder|
|--delete_tmp|Clean up temporary workspace upon completion|
