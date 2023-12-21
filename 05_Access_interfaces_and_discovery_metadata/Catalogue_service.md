# Catalogue service with OpenSearch API

## Purpose

The catalogue is a web service that allows to discover collections (datasets) and search for individual products within each collection.

## Implementation

The catalogue web service is based on VITO's [TerraCatalogue](https://docs.terrascope.be/?_gl=1*8vj7j*_ga*MTkzNTQzMDQyNy4xNjM2MDEzMjAx*_ga_8W09K9NBS9*MTcwMDQ5NDQxNi4xNC4xLjE3MDA0OTQ0MjEuMC4wLjA.#/Developers/WebServices/TerraCatalogue/TerraCatalogue) solution, that implements the OGC-standard OpenSearch specification, with its extensions for geo, time and Earth Observation in accordance with CEOS best practices.
The encoding is done in GeoJSON-LD format.

Collection (dataset) and product (file) metadata records are stored in the [ElasticSearch database](../04_Database/properties/). On this database description page, you can find more information on the specifications that the solution adheres to, along with some metadata examples.

## OpenSearch API

OpenSearch is a self-describing search: it provides a simple description document (OSDD) of the search interface, with available filters, allowed filter values, sort keys and so on.

[Overall OpenSearch Description Document](https://phenology.vgt.vito.be/description)

[Description for searching one example collection for Vegetation Indices](https://phenology.vgt.vito.be/description?collection=copernicus_r_utm-wgs84_10_m_hrvpp-vi_p_2017-now_v01)

In the OpenSearch catalogue, five collections are defined, each with its corresponding index in the ElasticSearch database.

|Identifier|Description|
|----------|-----------|
|copernicus_r_utm-wgs84_10_m_hrvpp-vi_p_2017-now_v01|Vegetation Indices, daily, UTM projection|
|copernicus_r_utm-wgs84_10_m_hrvpp-st_p_2017-now_v01|Seasonal Trajectories, 10-daily, UTM projection|
|copernicus_r_utm-wgs84_10_m_hrvpp-vpp_p_2017-now_v01|Vegetation Phenology and Productivity parameters, yearly, UTM projection|
|copernicus_r_3035_x_m_hrvpp-st_p_2017-now_v01|Seasonal Trajectories, 10-daily, LAEA projection|
|copernicus_r_3035_x_m_hrvpp-vpp_p_2017-now_v01|Vegetation Phenology and Productivity parameters, yearly, LAEA projection|

The collections' discovery metadata can be retrieved from 

[Collections metadata](https://phenology.vgt.vito.be/collections)

A few tips:
* In the product search, the productType filter can be used to search for individual Vegetation Indices (NDVI, LAI, ...), VPP parameters (AMPL = amplitude, SOSD = start of season date, etc). 
* Similarly, the productGroupId filters the VPP parameters on the season (s1 for season 1, s2 for season 2).
* By default, the response contains HTTPS download URLs. Use the _accessedFrom=S3_ option in the search request, to retrieve the S3 object storage paths instead.
