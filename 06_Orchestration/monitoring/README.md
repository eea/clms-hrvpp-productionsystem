# Monitoring using dashboards and alerts

Section 2.3.8 of the System Description Document describes the different levels of monitoring:
* monitoring of the processing steps in the NiFi interface, noting that the workflows include automatic detection of common errors and retries
* monitoring of the jobs running on the Spark clusters, through the master node's interface, which is useful for checking the state of the cluster, the status and duration of submitted jobs and the job logging.
* system health and performance checks and alerts in icinga and Grafana dashboards
* monitoring the production status (e.g., number of files produced, processing status), the object storage space consumption and web service access through Kibana's queries and reports

Kibana_export.ndjson is an export of all the saved components in Kibana, including the ElasticSearch data queries and configurations for the tables/graphs used.

The Grafana* JSON files configure the Grafana dashboards.

