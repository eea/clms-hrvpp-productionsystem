# Spark jobs

In the NiFi workflows, jobs are submitted to the three Spark clusters through the Livy interface.
These perform the main data processing and prepare the products for dissemination.

## Overview

The following Spark jobs are submitted in the various workflows.
Open each job's description to find more details on the workflow it is used in, the cloud resources and time it requires to run and the configuration parameters.

For product generation:
* [Vegetation Indices production](./vegetation_indices_production_job.md)
* [Vegetation Indices double file merge](./vegetation_indices_double_merge_job.md)
* [Timesat processing job](./timesat_processing_job.md)

For product access:
* [WMTS cache seeding for pivotal zoom level](./seeding_job.md)
* [WMTS build pyramid](./seeding_build_pyramid_job.md)

## Scripts and software dependencies

In the [indices](./indices) sub-folder, you can find a copy of the Python3 scripts used to compute the Difference Vegetation Index (DVI) and the temporarl maximum DVI (MDVI), that are inputs to the Plant Phenology Index (PPI) calculation.
These scripts are included in the Docker image of the [Vegetation Indices production](./vegetation_indices_production_job.md) job.
The Python3 scripts used to calculate the other Vegetation Indices (NDVI, FAPAR, LAI), as well as those to run Timesat and the cache seeding, are not publicly available (see [Software licenses](../01_Cloud_deployment/Software_licenses.md) on how to obtain them) and hence excluded from this GitHub repository.

See the [Product User Manual](https://land.copernicus.eu/en/technical-library/product-user-manual-of-vegetation-indices/@@download/file) or [ATBD](https://land.copernicus.eu/en/technical-library/algorithm-theoretical-base-document-for-vegetation-indices/@@download/file) for more details on the retrieval algorithm for the Vegetation Indices.

The other, external software packages (e.g. Python packages, GDAL, SNAP with sen2cor) are all available online publicly and free-of-charge.
See [Cloud deployment](../01_Cloud_deployment/) for more details on the software packages and versions that are deployed, either directly or inside the Docker images.
