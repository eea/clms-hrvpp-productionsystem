# Properties for product collections in the collections index for the catalogue service

|Property|Description|Example value|
|--------|-----------|-------------|
|type||Feature|
|id|Unique identifier|copernicus_r_utm-wgs84_10_m_hrvpp-vi_p_2017-now_v01|
|geometry|Geometry enclosing the entire collection, in accordance with GeoJSON specification (closed, counter-clockwise exterior polygon) and using coordinates with 10-decimals|{    <br>     "type": "Polygon",    <br>    "coordinates": [     <br>     ]     <br>     }|
|bbox|Range of coordinates (west, south, east, north) enclosing the collection’s footprint|[         -25,         27,         45,        72      ]|
|properties.title|Human readable title for the collection|Vegetation Indices, daily, UTM projection|
|properties.identifier|Identier codefor the collection|copernicus_r_utm-wgs84_10_m_hrvpp-vi_p_2017-now_v01|
|properties.rights|Description of legal access rights and license conditions|License: All users benefit from the free and open data access policy as defined in the European Union Copernicus regulation N° 377/2014 and Commission Delegated Regulation N° 1159/2013. This includes lawful use reproduction, distribution, communication to the public, adaptation, modification with other data and information or any combination thereof. Access and use can only be limited in rare cases of security concerns, protection of Third Party risks or risks of service disruption.|
|properties.abstract|Abstract text introducing and describing the collection|This Vegetation Indices product includes the Normalized Difference Vegetation Index (NDVI), the normalized differece of near inrared and red reflectances, the Plant Phenology Index, the Fraction of Absorbed Photosynthetically Active Radiation (FAPAR) and the Leaf Area Index (LAI). These indices are derived from the Copernicus Sentinel-2 satellite observations and updated daily.|
|properties.date||2017-01-01T00:00:00Z|
|properties.updated||2020-09-17T15:23:57Z|
|properties.lang|Language of the metadata properties|eng|
|properties.categories|Categorization based on thesaurus such the EIONET\’s GEMET and the INSPIRE themes|\[           \{             "term": https://www.eionet.europa.eu/gemet/concept/4599",             "label": "land"          \}          \]|
|properties.keyword|Search keywords|\[ "NDVI", "LAI", "FAPAR", "PPI", "index", "land", “vegetation", "plant", "phenology", "growing season","productivity", "sentinel"\]|
|properties.publisher|Publisher of the metadata record|VITO|
|properties.authors.type|Author (producer) of the collection (dataset)|Organization|
|properties.authors.email||helpdeskticket@vgt.vito.be|
|properties.authors.name||VITO|
|properties.contactPoint.type|Full contact details for user support and the legal responsible entity (custodian).|Organization|
|properties.contactPoint.email||copernicus@eea.europa.eu|
|properties.contactPoint.name||European Environment Agency|
|properties.contactPoint.uri||https://land.copernicus.eu|
|properties.contactPoint.<br>hasAddress.country-name||Denmark|
|properties.contactPoint.<br>hasAddress.postal-code||DK-1050|
|properties.contactPoint.<br>hasAddress.locality||Copenhagen K|
|properties.contactPoint.<br>hasAddress.street-address||Kongens Nytorv 6|
|properties.acquisitionInformation\[\*\].|Repeated for each of the satellite platforms and sensors used||
|properties.acquisitionInformation\[\*\].<br>acquisitionParameters.beginningDateTime|Time period covered by the collection|2017-01-01T00:00:00Z|
|properties.acquisitionInformation\[\*\].<br>acquisitionParameters.endingDateTime||2023-09-30T23:59:59Z|
|properties.acquisitionInformation\[\*\].<br>platform.platformShortName|Name and serial identifier of the satellite platform(s) used as input to produce the collection|SENTINEL-2|
|properties.acquisitionInformation\[\*\].<br>platform.platformSerialIdentifier||S2A|
|properties.acquisitionInformation\[\*\].<br>instrument.sensorType|Type (radar, optical, etc) and name of the sensor on board the satellite|OPTICAL|
|properties.acquisitionInformation\[\*\].<br>instrument.instrumentShortName||MSI|
|properties.distribution.type||Distribution|
|properties.distribution.type.license.type|Type of license and links to the legal terms of use|Terms of use: https://land.copernicus.eu/terms-of-use|
|properties.distribution.type.license.label||LicenseDocument|
|properties.distribution.accessRights.type|Statement on the legal data access rights|RightsStatement|
|properties.distribution.accessRights.label||All users benefit from the free and open data access policy as defined in the European Union Copernicus regulation N° 377/2014 and Commission Delegated Regulation N° 1159/2013. This includes lawful use reproduction, distribution, communication to the public, adaptation, modification with other data and information or any combination thereof. Access and use can only be limited in rare cases of security concerns, protection of Third Party risks or risks of service disruption.|
|properties.productInformation.<br>availabilityTime|Timestamp of availability of the collection|2021-01-01T00:00:00Z|
|properties.productInformation.<br>productType|Types of products included in the collection|[ "NDVI", "PPI", "FAPAR", "LAI", "QFLAG2"  ]|
|properties.productInformation.<br>processingCenter|Institute who produced the product|VITO|
|properties.productInformation.<br>processingLevel|Processing level|3|
|properties.productInformation.<br>compositeType|Type of compositing, indicating by “P” for period, followed by a digit and an indication of the units (H=hours, D = days, M = months, Y = years)|P1D|
|properties.productInformation.<br>processorVersion|Version of the production software, composed of single digit major version, two-digit revision|V101|
|properties.productInformation.<br>format|File format|geotiff|
|properties.productInformation.<br>productVersion|Version of the collection, composed of single digit major version, two-digit revision|V101|
|properties.productInformation.<br>resolution|Spatial resolution(s)of the data products included in the collection, expressed as distance in meters|[ 10 ]|
|properties.productInformation.<br>platformShortName|Names and serial identifiers of the satelliteplatform(s) that provide the input observations for the production of the collection|SENTINEL-2|
|properties.productInformation.<br>platformSerialIdentifier||[ "S2A", "S2B"  ]|
|properties.bands\[\*\].<br>title|A human readable title|NDVI|
|properties.bands\[\*\].<br>resolution|The spatial resolution, expressed as distance in meter|10|
|properties.bands\[\*\].<br>bitPerValue|The number of bits per pixel (cell) value|16|
|properties.bands\[\*\].<br>scaleFactor|Optionally, the scale factor and offset to translate the digitally stored values to their physical equivalents (physical = digital * scale factor + offset)|0.0001|
|properties.bands\[\*\].<br>offset||0|
|links.describedby\[\*\].<br>href|Web address of the online description or documentation|https://land.copernicus.eu/pan-european/biophysical-parameters/high-resolution-vegetation-phenology-and-productivity|
|links.describedby\[\*\].<br>type|MIME type of the online resource the link refers to|text/html|
|links.describedby\[\*\].<br>title|Title of the online description or documentation that the link refers to|Product information web site|
|links.previews\[\*\].<br>href|Web address of the preview image(s)|https://sdi.eea.europa.eu/catalogue/srv/api/records/65f095af-5225-490b-8a29-4500d4c31b8a/attachments/65f095af-5225-490b-8a29-4500d4c31b8a.png |
|links.previews\[\*\].<br>type|MIME type of the preview image(s)|image/jpeg|
|links.previews\[\*\].<br>title|Title of the preview images|Illustration image|
|links.via\[\*\].<br>href|Web address of the parent metadata record(s) in EEA SDI|https://sdi.eea.europa.eu/catalogue/srv/eng/catalog.search#/metadata/b6cc3b37-0686-4bb1-b8c3-3c08520743c3 |
|links.via\[\*\].<br>type|MIME type of the parent metadata record(s)|application/vnd.iso.19139+xml|
|links.via\[\*\].<br>title|Title of the parent metadata record(s)|INSPIRE Collection Metadata File|
|links.search\[\*\].<br>href|Web address of the OpenSearch Description Document|https://phenology.vgt.vito.be/description.geojson?collection=copernicus_r_utm-wgs84_10_m_hrvpp-vi_p_2017-now_v01|
|links.search\[\*\].<br>type|MIME type of the OpenSearch Description Document|application/geo+json|
|links.search\[\*\].<br>title|Title of the OpenSearch Description Document that the link refers to|OpenSearch entry point|

