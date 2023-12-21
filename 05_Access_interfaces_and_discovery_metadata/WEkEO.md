# Interfacing with WEkEO

The integration of HR-VPP datasets into the WEkEO systems are done at three levels:
* broker and HDA API
* dataset metadata
* the map display

## Broker and HDA API

In December 2023 and January 2024, WEkEO's HDA API is in transition from version 1 to version 2.
It is recommended to work with version 2, providing feedback to WEkEO support for its verification, and expecting some changes and short interruptions in the API leading up to its release in 2024.

[Broker endpoint](https://wekeo-broker.prod.wekeo2.eu/databroker/)

[Swagger interface](https://wekeo-broker.prod.wekeo2.eu/databroker/ui/#/)

For example code on how to use the HDA API client:
[API demo notebook](https://github.com/eea/clms-hrvpp-tools-python/tree/main/HRVPP_hda_demo)

When user searches for and requests HR-VPP data, either on the WEkEO data portal or directly via the HDA API, the request calls the broker.
This broker translates the WEkEO (HDA) request into an OpenSearch request for the HR-VPP catalogue.
When the HR-VPP catalogue sends it OpenSearch response, the broker will read this and reformat it to a HDA API response.

The visibility of request/response fields is defined by the OpenSearch Description Document and dataset metadata records in the HR-VPP catalogue.

The broker is developed by the WEkEO consortium, independently of HR-VPP and free-of-charge.
Updates to the broker code are to be done at the discretion of the WEkEO team and their deployment schedule.

## Dataset metadata

A set of five (5) dataset metadata files are prepared and ingested into the WEkEO product navigator for display on the WEkEO data portal.

There is one record for
* the Vegetation Indices (UTM projection)
* the Seasonal Trajectories (10m grid, UTM projection)
* the Seasonal Trajectories (10m and 100m grids, ETRS89-LAEA projection)
* the Vegetation Phenology and Productivity parameters (10m grid, UTM projection)
* the Vegetation Phenology and Productivity parameters (10m and 100m grids, ETRS89-LAEA projection)

Note that this granularity is different from the EEA SDI records.

INSPIRE-compliant XML metadata is prepared/updated by HR-VPP and submitted to the WEkEO team for integration.
The preview images are prepared by the WEkEO team.

The current metadata files can be downloaded from the [WEkEO data portal](https://www.wekeo.eu/data):
* click on + icon to open the dataset catalogue
* search for _hrvpp_
* click on the Details button for one of the HR-VPP datasets to open the metadata record
* scroll down and click on the _JSON metadata_ and _XML metadata_ links to retrieve the metadata records

Preview images can be downloaded at:
* [Vegetation Indices](./assets/WEkEO/previews/EO-EEA-DAT-CLMS-HRVPP-VI.jpg)
* [Seasonal Trajectories, UTM](./assets/WEkEO/previews/EO-EEA-DAT-CLMS-HRVPP-ST.jpg)
* [Seasonal Trajectories, LAEA](./assets/WEkEO/previews/EO-EEA-DAT-CLMS-HRVPP-ST-LAEA.jpg)
* [VPP parameters, UTM](./assets/WEkEO/previews/EO-EEA-DAT-CLMS-HRVPP-VPP.jpg)
* [VPP parameters, LAEA](./assets/WEkEO/previews/EO-EEA-DAT-CLMS-HRVPP-VPP-LAEA.jpg)

## Map viewing on the portal

Next to displaying the dataset metadata and calling the broker when users submit data requests interactively on the portal, the WEkEO data portal displays the HR-VPP datasets by integrating the WMS/WMTS service.

The configuration of this map display is to be arranged with the WEkEO portal team, by e.g. supplying the name of the WMS/WMTS map layers to be displayed.

For each datasets, multiple map layers can be defined.
For example, when users add the Vegetation Indices dataset to the portal's map, they can opt to display the NDVI, LAI, FAPAR, PPI and/or Quality Flag layers separately.
