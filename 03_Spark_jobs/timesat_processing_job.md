# Timesat processing job 

## Purpose

Timesat is used for the production of Seasonal Trajectories and VPP parameters, per tile.

## Characteristics

| | |
|-------------|-------------|
|[NiFi workflow](../02_Workflows_in_NIFI/)|Annual ST and VPP with Timesat|
|[Spark cluster](../01_Cloud_deployment/infrastructure/spark_clusters.md)|ST\/VPP production|
|Job          |S3_prerunner_timesat.py starts Docker hrvpp-biopar-wekeo<br>that runs workflow_timesat.py and the Timesat software in 4 chunks,<br> afterwards the chunks are merge with S3_prerunner_timesat_merge.py<br> that runs workflow_timesat_merge.py|
|Spark executor resources|3 vCPU<br>13GB RAM|
|Nominal duration| 20hours per chunk + 1hour merging|

## Configuration

Configuration for S3_prerunner_timesat.py:

|Configuration parameter|Description|
|----------------|---------|-------------------|------------------------|
|tile|Sentinel-2 MGRS tile to be processed|

Note that the start year and input product version are configured in the prerunner script.

Configuration for workflow_runner_hrvpp.py

|Configuration parameter|Description|
|----------------|---------|
|tile|Sentinel-2 MGRS tile to be processed|
|paths|List of input file paths|
|local|To run Timesat on Spark locally for development, or on cluster for production|
