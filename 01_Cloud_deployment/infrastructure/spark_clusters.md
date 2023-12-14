# Scalable Spark clusters

For product generation and access services, three *stand-alone Spark clusters* are deployed: 
one for the generation of the Vegetation Indices, one for the production of the Seasonal Trajectories and VPP parameters and one for WMTS cache seeding.

Apache Spark is used intensively as the engine for parallel *processing* and analysing *large data volumes*.
The Spark engine ensures high availability, with extensive monitoring, and scalability: 
the same processing job can be developed and evaluated on one or a few nodes. Then, the pool of worker hosts can be extended quickly to large amounts.

The processing workflows are brought together in Apache NiFi workflows. Where needed, the workflow submits jobs to the Spark cluster through the easy, REST-ful interface that is provided by Apache Livy.

|Spark cluster|VM flavour for master node|VM flavour for worker nodes|Master instance name|Worker pool instance names|
|---|---|---|---|---|
|Vegetation Indices production|eo2.large|eo2.xlarge|vi-master-prd-1|vi-worker-prd-\*|
|ST/VPP production|eo2.large|eo2.xlarge|ts-master-prd-1|ts-worker-prd-\*|
|WMTS cache seeding|eo2.large|eo1.small|seed-master-prd-1|seed-worker-prd-\*|
