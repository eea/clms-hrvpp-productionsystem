# Software licenses

The following software components are used in the HR-VPP production systems, but not publicly available at this time. 
Instructions on how to obtain them, are described here.

It can be noted that all other software components, except those listed here, are publicly and online available, free-of-charge.
Examples are Python3 packages (like numpy or rasterio), [GDAL](https://gdal.org/) and [SNAP](https://step.esa.int/main/download/snap-download/) with sen2cor.

The consortium of HR-VPP phase 1 and EEA obtained the right to use these components, free-of-charge, for the purpose of their work in HR-VPP (generating HR-VPP products and making them available to users).

### Timesat

HR-VPP uses version 4.x of the Timesat software for analysing time-series of satellite sensor data.

It is a newer version of the Timesat software that can be downloaded [here](https://web.nateko.lu.se/timesat/timesat.asp).

For HR-VPP product generation purposes, the right to use Timesat 4.X can be obtained from its [authors at the University of Lund](https://web.nateko.lu.se/timesat/timesat.asp?cat=8) in Sweden.
The authors plan to make the 4.x version publicly (and freely) available in the near future.

### Python scripts for producing the NDVI, LAI and FAPAR
### TerraCatalogue/OSCARS web catalogue back-end and management software (oscars-management package)
### WMS/WMTS web application (gwc-geotrellis .jar) and cache seeding application (geotrellis-seeder .jar and generatePyramid.py)

These software components are all developed by VITO, Belgium on behalf of ESA and the Belgian Science Policy office (BELSPO), mainly in the context of the [Terrascope](https://terrascope.be/en) activities.

For HR VPP purposes, the right to use these components can be requested to VITO or BELSPO.
For instance, by filling out the contact form at the bottom of the [Terrascope web site](https://terrascope.be/en).

Note that
* For TerraCatalogue, the above only applies to the web service back-end and catalogue management software. The [TerraCatalogue Python client](https://vitobelgium.github.io/terracatalogueclient/index.html), a Python package that queries the TerraCatalogue through its OpenSearch interface and downloads the products, is publicly and freely available.
* The WMS/WMTS and cache seeding applications are developed on top of the [GeoTrellis](https://geotrellis.io) open source software and its Python wrapper ([GeoPySpark](https://github.com/locationtech-labs/geopyspark)).
