# Properties in ElasticSearch index for production monitoring

One JSON metadata entry is stored in the index for each L1C input file that is processed (effectively 6-7 million).
Different properties (e.g., production status properties.processing_status.status) are updated during the different steps of the Vegetation Indices product generation workflow.

|Property|Description|Example value|
|--------|-----------|-------------|
|\_id|Input L1C data identifier|S2A_MSIL1C_20231113T131401_N0509_R081_T27VVL_20231113T151310|
|\_index|Name of ElasticSearch index|hrvpp_product_catalog-0001|
|assets.cloudferro.href|Location of the input L1C data|/eodata/Sentinel-2/MSI/L1C/2023/11/13/S2A_MSIL1C_20231113T131401_N0509_R081_T27VVL_20231113T151310.SAFE|
|assets.cloudferro.type||EO Data access|
|assets.hrvpp.vi.fapar.href|S3 location of the produced FAPAR VI file|hr-vpp-products-vi-v01-2023-11/CLMS/Pan-European/Biophysical/VI/v01/2023/11/13/VI_20231113T131401_S2A_T27VVL-010m_V101_FAPAR.tif|
|assets.hrvpp.vi.fapar.product_id|Filename identifier of the produced FAPAR VI data file|VI_20231113T131401_S2A_T27VVL-010m_V101_FAPAR|
|assets.hrvpp.vi.lai.href|S3 location of the produced LAI VI file|hr-vpp-products-vi-v01-2023-11/CLMS/Pan-European/Biophysical/VI/v01/2023/11/13/VI_20231113T131401_S2A_T27VVL-010m_V101_LAI.tif|
|assets.hrvpp.vi.lai.product_id|Filename identifier of the produced LAI VI data file|VI_20231113T131401_S2A_T27VVL-010m_V101_LAI|
|assets.hrvpp.vi.ndvi.href|S3 location of the produced NDVI VI file|hr-vpp-products-vi-v01-2023-11/CLMS/Pan-European/Biophysical/VI/v01/2023/11/13/VI_20231113T131401_S2A_T27VVL-010m_V101_NDVI.tif|
|assets.hrvpp.vi.ndvi.product_id|Filename identifier of the produced NDVI VI data file|VI_20231113T131401_S2A_T27VVL-010m_V101_NDVI|
|assets.hrvpp.vi.ppi.href|S3 location of the produced PPI VI file |hr-vpp-products-vi-v01-2023-11/CLMS/Pan-European/Biophysical/VI/v01/2023/11/13/VI_20231113T131401_S2A_T27VVL-010m_V101_PPI.tif|
|assets.hrvpp.vi.ppi.product_id|Filename identifier of the produced PPI VI data file|VI_20231113T131401_S2A_T27VVL-010m_V101_PPI|
|assets.hrvpp.vi.qflag.href|S3 location of the produced QFLAG2 VI file|hr-vpp-products-vi-v01-2023-11/CLMS/Pan-European/Biophysical/VI/v01/2023/11/13/VI_20231113T131401_S2A_T27VVL-010m_V101_QFLAG2.tif|
|assets.hrvpp.vi.qflag.product_id|Filename identifier of the produced QFLAG2 VI data file|VI_20231113T131401_S2A_T27VVL-010m_V101_QFLAG2|
|geometry|Polygon geometry enclosing the product and in accordance with GeoJSON specification (closed, counter-clockwise exterior polygon) and using coordinates with 10-decimals|\{    <br>    "coordinates": \[    <br>        _set of coordinate tuples_    <br>    \],    <br>    "type": "Polygon"    <br>\}|
|id|Unique identifier of record in ElasticSearch index|29a505cf-6b1a-4b11-964e-076665cee6a1|
|properties.beginposition|Nominal time stamp of the input product|Nov 13, 2023 @ 14:14:01.024|
|properties.endposition|Nominal time stamp of the input product|Nov 13, 2023 @ 14:14:01.024|
|properties.cloudcoverpercentage|Cloud cover % of the input file|29.443|
|properties.filename|Input L1C data file that is processed|S2A_MSIL1C_20231113T131401_N0509_R081_T27VVL_20231113T151310.SAFE|
|properties.generationdate|Production timestamp|2023-11-13T15:13:10+00:00|
|properties.identifier|Input L1C data identifier|S2A_MSIL1C_20231113T131401_N0509_R081_T27VVL_20231113T151310|
|properties.ingestiondate|Timestamp of input data registration|Nov 13, 2023 @ 16:57:13.405|
|properties.platformname|Input data’s satellite platform name and serial|SENTINEL-2|
|properties.platformserialidentifier||A|
|properties.processing_status.<br>l1c_available|Timestamp when input L1C file became available on cloud|2023-11-13T16:11:49.870Z|
|properties.processing_status.<br>metadata_ingested|Timestamp when input file was recorded for processing|Nov 13, 2023 @ 17:11:38.119|
|properties.processing_status.<br>status|Production status|SUCCESS_PPI|
|properties.processing_status.<br>vi_processing_enddate|End of L1C file processing|Nov 14, 2023 @ 01:40:03.678|
|properties.processing_status.<br>vi_processing_startdate|Start of L1C file processing|Nov 13, 2023 @ 21:54:21.377|
|properties.processingbaseline|Baseline of input L1C file|05.09|
|properties.producttype|Type of input product (Sentinel-2, MSI sensor, L1C)|S2MSI1C|
|properties.tileid|Tile in the Sentinel-2 tiling grid|27VVL|
|title|Input L1C data identifier|S2A_MSIL1C_20231113T131401_N0509_R081_T27VVL_20231113T151310|




