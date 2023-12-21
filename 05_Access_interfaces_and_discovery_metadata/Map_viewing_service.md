# Viewing service with OGC WMS/WMTS API

## Purpose

The viewing service provides rendered map tiles for display in web portal or GIS clients.

## Implementation and endpoint

The map viewing service is implemented using the gwc-geotrellis web application, that builds on GeoTrellis, Spark and the Python package GeoPySpark (GeoTrellis for PySpark).
Together with cloud provider CloudFerro, the HR-VPP team put significant effort into ensuring the performance of these viewing services, also for coarse zoom levels.

As foreseen in the OGC standard, the WMS/WMTS web services support the GetCapabilities request, at the following endpoints:

[WMTS service endpoint](https://phenology.vgt.vito.be/wms?request=GetCapabilities)

[WMS service endpoint](https://phenology.vgt.vito.be/wmts?request=GetCapabilities)

The layer names following this naming convention.

|Dataset|WMS\/WMTS layer names|Where \<producttype\> is one of|
|-------|--------------------|---------------------------|
|Vegetation Indices, 10m grid, UTM projection|CLMS\_HRVPP\_VI\_\<producttype\>\_10M|FAPAR, LAI, NDVI, PPI, QFLAG2|
|Seasonal Trajectories, 10m grid, UTM projection|CLMS\_HRVPP\_ST\_\<producttype\>\_10M|PPI, QFLAG|
|Seasonal Trajectories, 10m grid, LAEA projection|CLMS\_HRVPP\_ST\_\<producttype\>\_10M_LAEA|PPI, QFLAG|
|VPP parameters, 10m grid, UTM projection|CLMS\_HRVPP\_VPP\_\<producttype\>\_10M|AMPL, EOSD, EOSV, LENGTH, LSLOPE, MAXD, MAXV, MINV, RSLOPE, SOSD, SOSV, SPROD, TPROD, QFLAG|
|VPP parameters, 10m grid, LAEA projection|CLMS\_HRVPP\_VPP\_\<producttype\>\_10M|AMPL, EOSD, EOSV, LENGTH, LSLOPE, MAXD, MAXV, MINV, RSLOPE, SOSD, SOSV, SPROD, TPROD, QFLAG|

For a description of the product type abbreviations, please see the bottom table on [this page](./README.md).

The 100m LAEA ST/VPP products are not available as separate WMS/WMTS map layers.
