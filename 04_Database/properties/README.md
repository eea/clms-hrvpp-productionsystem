# ElasticSearch database

[ElasticSearch](https://github.com/elastic/elasticsearch) is the search engine from the open source Elastic Stack.
It stores free-form documents, typically in JSON format, and provides an interface to search through their contents.
It is schema-free, open-source, scalable through replication and sharding and capable of searching millions of documents easily.

## Search indexes

The documents are stored in search indexes. HR-VPP defined indexes for
* the monitoring of product generation workflows
* the product access catalogue, which has one index for the collections (dataset) searches and one index per collection for the product searching.
* the logging of access to the web services, to retain them for longer period
* monitoring metrics such as the consumption of S3 object storage space

## A standards compliant and interoperable Catalogue

The TerraCatalogue OpenSearch implementation applies to the following standards:

* [OpenSearch](https://www.ogc.org/standards/opensearch)
* [OGC- 10-032r8 OGC](https://www.ogc.org/standards/opensearch) OpenSearch Geo and Time Extensions
* [OGC 13-026r9](https://www.ogc.org/standards/opensearch) OGC OpenSearch Extension for Earth Observation
The OpenSearch query parameters are aligned with the Earth Observations Metadata profile of Observations and Measurements (O&M EOP): [OGC 10-157r4](http://docs.opengeospatial.org/is/10-157r4/10-157r4.html#figure-1) Interface development is based on the [CEOS OpenSearch Best Practice Document](https://ceos.org/document_management/Working_Groups/WGISS/Interest_Groups/OpenSearch/CEOS-OPENSEARCH-BP-V1.2.pdf).

The GeoJSON implementation is based on the following standards:

* [eo-geojson](http://www.ogc.org/standards/eo-geojson) - OGC EO Dataset Metadata GeoJSON(-LD) Encoding Standard - Overview
* [OGC-17-003r1](http://docs.opengeospatial.org/is/17-003r1/17-003r1.html#135) – OGC EO Dataset Metadata GeoJSON(-LD) Encoding Standard
* [OGC-17-047-D8](https://docs.ogc.org/is/17-047r1/17-047r1.html) - OpenSearch-EO GeoJSON-LD Response Encoding Standard
* [OGC-17-084-v0.9.0-D2](https://docs.ogc.org/bp/17-084r1/17-084r1.html) - GeoJSON EO Collection Metadata Encoding Standard

Therefore, the above specifications and OGC standards can be consulted for more information on the OpenSearch implementation (JSON-LD format, query filters, response properties etc.)

## Querying the Elastic database using Kibana

The free tool Kibana can be used to query the contents of the ElasticSearch database.

## Database backups

See the section on [Orchestration - backups](../02_Orchestration/backups) for more details.
