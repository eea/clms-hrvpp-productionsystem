# Seeding the WMTS map cache: building zoom pyramid

## Purpose

WMTS cache seeding is carried out until a certain [pivotal (main) zoom level](../seeding_job.md).
More coarse zoom levels are build as a pyramid by resampling this zoom level (by this job), in accordance with the Google PNG tile grid.
Finer zoom levels are rendered directly from the product data files (i.e. not seeded).

## Characteristics

| | |
|-------------|-------------|
|[NiFi workflow](../02_Workflows_in_NIFI/)|Seeding|
|[Spark cluster](../01_Cloud_deployment/infrastructure/spark_clusters.md)|Seeding|
|Job          |generatePyramid.py PySpark script|
|Spark executor resources|1 vCPU<br>1.5GB RAM<br>|
|Nominal duration|<=5 min|

## Configuration

Configuration for generatePyramid script:

|Configuration parameter|Description|
|----------------|---------|
|endpoint_url|S3 API endpoint|
|region|S3 API region|,
|bucket|Name of object storage bucket|
|collection|Common prefix for the PNG objects|
|date|Date for which the pyramid is to be built|
|bottomZoom|Pivotal or finest zoom level, used as input to build pyramid|
|topZoom|Coarsest zoom level to build in the output pyramid|
|blankTile|Optional blank tile|
