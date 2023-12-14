# Object Storage

## S3 endpoints

The CloudFerro object storage service comes with two Simple Storage Service (S3) endpoints:

|Endpoint|Description|
|--------|-----------|
|https://s3.waw3-1.cloudferro.com|Public endpoint, hosting self-managed buckets|
|http://data.cloudferro.com|Internal endpoint, hosting input data and overlay bucket|

The public endpoint is accessible from both inside and outside the CloudFerro tenant.
The internal endpoint is only accessible from a host:
* deployed on CloudFerro OpenStack, and
* a host connected to the eodata network

## Storage buckets

The following object storage buckets are defined.
Buckets are dimensioned to hold no more than 100 000 objects. While this is no longer strictly necessary in WAW3 cloud, this still helps to ensure performance.

### For storing the final HR-VPP products

Buckets for the final products follow a naming convention that is agreed with CloudFerro, to allow the buckets to be re-used in the proxy bucket, 
a single logical bucket that provides access to all HR-VPP products and that is accessible via the internal S3 endpoint.

|Bucket name|Purpose|Dimension per bucket|
------|------|------|
|hr-vpp-products-vi-v01-\<YYYY\>-\<MM\>|Vegetation Indices (VI) products per month|60-85k objects, 4-7TB|
|hr-vpp-products-st-v01-\<YYYY\>|Seasonal Trajectories (ST) products, in UTM, per year|79k objects, 5.1TB|
|hr-vpp-products-st-v01-laea-\<YYYY\>|ST products in ETRS89-LAEA grid, per year|65k objects, 3.7TB|
|hr-vpp-products-vpp-v01-\<YYYY\>|VPP products, in UTM, per year|30.5k objects, 1.9TB|
|hr-vpp-products-vpp-v01-laea-\<YYYY\>|VPP products in ETRS89-LAEA grid, per year|25k objects, 1.4TB|
|hr-vpp-old-versions|Temporary storage of old versions of products|Varying|

### For product generation

|Bucket name|Purpose|Dimension per bucket|
------|------|------|
|hr-vpp-auxdata-v01-\<YYYY\>-\<MM\>|Auxiliary data needed for processing|up to 70k objects, 2.1TB|
|hr-vpp-missing-L1C|Missing L1c products|<500 objects, 300GB|
  
### For product access / web services

|Bucket name|Purpose|Dimension per bucket|
------|------|------|
|hr-vpp-wmts-ndvi-\<YYYY\>|VI NDVI tile cache WMTS service|55k objects, 330MB|
|hr-vpp-wmts-ppi-\<YYYY\>|VI PPI tile cache WMTS service|55k objects, 380MB|
|hr-vpp-wmts-lai-\<YYYY\>|VI LAI tile cache WMTS service|55k objects, 410MB|
|hr-vpp-wmts-fapar-\<YYYY\>|VI FAPAR tile cache for WMTS service|55k objects, 360MB|
|hr-vpp-wmts-qflag2-\<YYYY\>|VI QFLAG2 tile cache for WMTS service|55k objects, 300MB|
|hr-vpp-wmts-st-utm-010m|ST (UTM) tile cache for WMTS service, all years|per year: 13.5k objects, 200MB|
|hr-vpp-wmts-vpp-utm-010m|VPP (UTM) tile cache for WMTS service, all years|per year: 5.3k objects, 70MB|
|hr-vpp-wmts-st-laea-010m|ST (LAEA 10m) tile cache for WMTS service|per year: 13.5k objects, 200MB|
|hr-vpp-wmts-vpp-laea-010m|VPP (LAEA 10m) tile cache for WMTS service|per year: 5.3k objects, 70MB|
|hr-vpp-wmts-st-laea-100m|ST (LAEA 100m) tile cache for WMTS service|future use|
|hr-vpp-wmts-vpp-laea-100m|VPP (LAEA 100m) tile cache for WMTS service|future use|
|hr-vpp-httpd|Shared file cache for web nodes|insignificant|
  
### For orchestration and monitoring
  
|Bucket name|Purpose|
|------------------|-----------|
|hr-vpp|Storing of the Terraform state|
|hr-vpp-backup|Backups for ES/Kibana, NiFi|
|hr-vpp-flowfiles|Flowfiles used in NiFi processing workflows|
|hr-vpp-spark|Used to store jobID's for the history server|
|hr-vpp-scripts|Scripts used in Spark processing jobs|
|hr-vpp-spark-logs-vi|Bucket for fluent-bit to put the vi worker logs in|
|hr-vpp-spark-logs-ts|Bucket for fluent-bit to put the ts worker logs in|
|hr-vpp-spark-logs-seed|Bucket for fluent-bit to put the seed worker logs in|
|hr-vpp-workflowlogs-\<YYYY\>-\<MM\>|Logs from NiFi|

## Fine-grained bucket access privileges

All buckets are self-managed, in the sense that they are maintained by the owner of the OpenStack tenant.

By default, all users in the OpenStack project have read-write access to all storage buckets.
To provide a more fine-grained access, additional projects are defined within OpenStack and given specific access privileges (read-write or read-only) at project-level:
* a project with read-only access to the buckets with the final products, intended for users that do not have an OpenStack project in the same WAW3-1 cloud.
* a project for web services, with read-only access to the buckets with the final products and WMTS tiles and read-write access to the web service cache bucket
* a project with read-only access to final products and processing logs, auxiliary data and Spark job scripts and read-write access to the ElasticSearch, Kibana and NiFi backups.

For more details on storage bucket access policies, see the [WEkEO-Elasticity documentation on S3 bucket sharing](https://wekeo.docs.cloudferro.com/en/latest/s3/Bucket-sharing-using-s3-bucket-policy-on-WEkEO-Elasticity.html).

## S3 Overlay or proxy bucket

CloudFerro created an overlay (proxy) bucket which exposes all product buckets (hr-vpp-products-vi-v01-\*, hr-vpp-products-vi-v01-\*, hr-vpp-products-st-v01-\*, hr-vpp-products-vpp-v01-\*, hr-vpp-products-st-v01-laea-\* and hr-vpp-products-vpp-v01-laea-\*) as a single 'HRVPP' bucket.
This bucket is only accessible from within a CloudFerro tenant using the internal S3 endpoint 'http://data.cloudferro.com'.

When a user access the (public) overlay bucket, the access request is mapped (transparently) to the individual (internal) buckets managed in the HR-VPP project.
To fulfill this mapping: 
* the internal buckets with final products need to follow an agreed bucket naming convention
* the objects (final HR-VPP) products need to follow a specific convention on key name prefixes
  
The following conventions are currently used in the overlay bucket:

|Internal bucket naming convention|Key naming convention|
|---------------------------------|---------------------|
|hr-vpp-products-vi-v01-\<yyyy\>-\<mm\>|/CLMS/Pan-European/Biophysical/VI/v01/\<yyyy\>/\<mm\>/\<dd\>/\<product\>|
|hr-vpp-products-st-v01-\<yyyy\>|/CLMS/Pan-European/Biophysical/ST/v01/\<yyyy\>/\<mm\>/\<dd\>/\<product\>|
|hr-vpp-products-vpp-v01-\<yyyy\>|/CLMS/Pan-European/Biophysical/VPP/v01/\<yyyy\>/\<s1\|s2\>/\<product\>|
|hr-vpp-products-st-v01-laea-\<yyyy\>|/CLMS/Pan-European/Biophysical/ST_LAEA/v01/\<yyyy\>/\<mm\>/\<dd\>/\<product\>|
|hr-vpp-products-vpp-v01-laea-\<yyyy\>|/CLMS/Pan-European/Biophysical/VPP_LAEA/v01/\<yyyy\>/\<s1\|s2\>/\<product\>|

