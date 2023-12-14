# Workflows in Apache NiFi

The HR-VPP workflows are set up in [Apache NiFi](https://nifi.apache.org/), an open source system to manage and automate data flows.
It is well-documented online, with for instance
* [User Guide](https://nifi.apache.org/docs/nifi-docs/html/user-guide.html)
* [Project documentation](https://nifi.apache.org/docs.html)
* [Developer's guide](https://nifi.apache.org/docs/nifi-docs/html/developer-guide.html)
and plenty of online tutorials.

## Accessing HR-VPP workflows in NiFi through its web interface

Before the [NiFi web interface](https://nifi-1.hrvpp2.vgt.vito.be:8443/nifi/login) can be used to manage, edit or run the HR-VPP workflows, a few steps need to be followed first.

Firstly, access to the NiFi web interface requires authentication via an LDAP service, that is currently VITO's Terrascope LDAP.

Secondly, access to this web interface is restricted to a specific range of IP addresses.

Thirdly, NiFi administrators need to configure NiFi to provide your user with the privileges to access the HR-VPP workflows. 
As HR-VPP uses a dedicated NiFi service, the HR-VPP workflows are the only processors/processGroups in this instance.

## HR-VPP workflows in NiFi

Section 3 of the System Description Document (SDD) gives an overview of the NiFi workflows. 

Separate workflows (process groups in NiFi) are defined in Nifi.

For product generation:

|Workflow for|NiFi process group name|
|------------|-----------------------|
|Ingestion of input Sentinel-2 products|HR-VPP - Metadata ingestion|
|Daily generation of Vegetation Indices (PPI, NDVI, LAI, FAPAR and their Quality Flag)|HR-VPP VI Theme|
|A variation on the Vegetation Indices workflow that handles input files with double finames|Double filenaming fix|
|Annual production of Seasonal Trajectories and VPP parameters in UTM|HR-VPP Timesat|
|Reprojection of Seasonal Trajectories and VPP parameters in ETRS89-LAEA and resample from 10m to 100m|HR-VPP LAEA|

To make products available to users:

|Workflow for|NiFi process group name|
|------------|-----------------------|
|Catalogue ingestion|HR-VPP VI Theme for Vegetation Indices |
|WMS/WMTS cache seeding|HR-VPP - Seeding|

\(\*\) The ingestion of the Vegetation Indices in the web catalogue service is automatic and included in the product generation workflow. The ingestion of the ST/VPP products is done manually, via the TerraCatalogue command-line interface.

For other purposes:

|Workflow for|NiFi process group name|
|------------|-----------------------|
|Monitoring of object storage disk space|S3 bucket stats|
|Spark log cleanup|Spark log cleanup|

## HR-VPP workflow dimensions and costs

A full copy of the NiFi configuration (NiFi template) is not available in time for the HR-VPP phase 2 tender, but it can be provided, for production continuity purposes, at the start of phase 2.

As can be seen in the workflow diagrams in the SDD document, the majority of the processors (steps) in the NiFi workflows are there to tie the workflows together, check/update JSON metadata and NiFi flowfiles, catch common errors, perform automatic retries.
These components take a very small amount of processing time and cloud hardware resources and are thus insignificant in terms of costing.

The [Spark jobs](../03_Spark_jobs) perform the heavy lifting and are the elements to be considered for cloud resource budgetting.
