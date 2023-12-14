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

## Querying the Elastic database using Kibana

The free tool Kibana can be used to query the contents of the ElasticSearch database.

## Database backups

See the section on [Orchestration - backup](../06_Orchestration/backup) for more details.
