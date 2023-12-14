# Table with ElasticSearch properties for products in the access catalogue

Example of FAPAR product entry stored in the product catalogue. This record follows feature object properties defined in the  OGC OpenSearch-EO GeoJSON(-LD) Response Encoding Standard (17-047r1) and can also be retrieved via the OpenSearch API.

|Property|Description|Example value|
|--------|-----------|-------------|
|\_id|Unique identifier|VI_20231113T131401_S2A_T26WPS-010m_V101_FAPAR|
|\_index|ElasticSearch index|oscars_clms_hrvpp_vi_10m_v01_0001|
|bbox|Range of coordinates (west, south, east, north) enclosing the product footprint|-24.961, 63.876, -22.572, 64.909|
|geometry|Polygon geometry enclosing the product and in accordance with GeoJSON specification (closed, counter-clockwise exterior polygon) and using coordinates with 10-decimals|\{    <br>    "coordinates": \[    <br>        _set of coordinate tuples_    <br>    \],    <br>    "type": "Polygon"    <br>\}|
|id|Unique identifier|VI_20231113T131401_S2A_T26WPS-010m_V101_FAPAR|
|properties.acquisitionInformation.<br>platform.platformShortName|Satellite platform name and serial|SENTINEL-2|
|properties.acquisitionInformation.<br>platform.platformSerialIdentifier||S2A|
|properties.acquisitionInformation.<br>acquisitionParameters.acquisitionType|Type of acquisition|NOMINAL|
|properties.acquisitionInformation.<br>acquisitionParameters.relativeOrbitNumber|Relative orbit number|81|
|properties.acquisitionInformation.<br>acquisitionParameters.beginningDateTime|Nominal timestamp of the product|2023-11-13T13:14:01.024Z|
|properties.acquisitionInformation.<br>acquisitionParameters.endingDateTime|Nominal timestamp of the product|2023-11-13T13:14:01.024Z|
|properties.acquisitionInformation.<br>acquisitionParameters.tileId|Tile in the Sentinel-2 tiling grid|26WPS|
|properties.additionalAttributes.resolution|Spatial resolution (distance in m)|10|
|properties.available|Timestamp of availability of the product in the catalogue|2023-11-13T23:40:53Z|
|properties.date|Nominal timestamp of the product|Nov 13, 2023 @ 14:14:01.024|
|properties.identifier|Unique product identifier|VI_20231113T131401_S2A_T26WPS-010m_V101_FAPAR|
|properties.links.alternates|||
|properties.links.data.\*|Link(s) to data file(s) included in the product. Currently refers to only one GeoTIFF data file per record.||
|\*.href|S3 object location|s3://hr-vpp-products-vi-v01-2023-11/CLMS/Pan-European/Biophysical/VI/v01/2023/11/13/VI_20231113T131401_S2A_T26WPS-010m_V101_FAPAR.tif|
|\*.type|MIME type of data file|image/tiff|
|\*.length|Size of the data file in bytes|8114713|
|\*.title|Title for each data file|FAPAR|
|\*.conformsTo|EPSG code of coordinate reference system (empty for UTM)||
|properties.links.previews|Link(s) to preview image(s)||
|properties.links.related|Link(s) to to related file(s) or resource(s)||
|properties.parentIdentifier|Catalogue collection identifier|copernicus_r_utm-wgs84_10_m_hrvpp-vi_p_2017-now_v01|
|properties.productInformation.availabilityTime|Time when the product became available in the catalogue|Nov 14, 2023 @ 00:40:53.000|
|properties.productInformation.processingCenter|Institute who produced the product|VITO|
|properties.productInformation.processingDate|Ending timestamp of the production|Nov 14, 2023 @ 00:39:55.795|
|properties.productInformation.productType|Type of product|FAPAR|
|properties.productInformation.productVersion|Version of the product, composed of single digit major version, two-digit revision|V101|
|properties.published|Publication timestamp of the product|Nov 14, 2023 @ 00:40:53.000|
|properties.status|Product status in the catalogue|ARCHIVED|
|properties.title|Human readable product title|Vegetation Indices 2017-now (raster 010m) - version 1 revision 01 : FAPAR T26WPS 20231113T131401|
|properties.updated|Latest modification date of the product metadata record|Nov 14, 2023 @ 00:39:55.795|
|type|Type of JSON-LD element|Feature|
