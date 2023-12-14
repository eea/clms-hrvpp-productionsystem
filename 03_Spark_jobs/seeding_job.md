# Seeding the WMTS map cache for the pivotal zoom

## Purpose

WMTS cache seeding is carried out until a certain pivotal (main) zoom level in this job.
More coarse zoom levels are [built as a pyramid](./seeding_build_pyramid_job.md) by resampling this zoom level.
Finer zoom levels are rendered directly from the product data files (not seeded).

## Characteristics

| | |
|-------------|-------------|
|[NiFi workflow](../02_Workflows_in_NIFI/)|Seeding|
|[Spark cluster](../01_Cloud_deployment/infrastructure/spark_clusters.md)|Seeding|
|Job          |geotrellis-seeder v2.2.0 JAR Scala application, class org.openeo.geotrellisseeder.TileSeeder|
|Spark executor resources|1 vCPU<br>1.5GB RAM<br>|
|Nominal duration|<10 min|

## Configuration

Configuration for geotrellis-seeder application

|Configuration parameter|Description|
|----------------|---------|
|date|time slot (date) to be seeded|
|productType|type of input products|
|rootPath|S3 bucket and prefix for output PNG files|
|zoomLevel|Zoom level|
|colorMap|Colour palette file|
|oscarsEndpoint|Endpoint of the OSCARS web catalogue|
|oscarsCollection|Identifier of the collection to query in the catalogue|
|oscarsSearchFilters|Additional query filters for lookup of input products in the catalogue, e.g. productGroupId to identify season 1/2 for VPP|
|partitions|Number of Spark partitions|
|selectOverlappingTile|(optional) strategy for tile selection where input tiles overlap|
|resampleMethod|(optional) resampling method|
