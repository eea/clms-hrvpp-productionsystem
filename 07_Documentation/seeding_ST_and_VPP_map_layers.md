# WMTS/WMS map cache seeding for ST and VPP map layers

The seeding for the Vegetation Indices map layers is done automatically, in near-real time.
For the visualization of the annually produced ST and VPP products, the map cache seeding is performed manually.

This manual seeding of ST / VPP map layers is required:
* when one more year of ST/VPP products (UTM) are produced
* when an existing year of ST/VPP products is overwritten due to an upgrade in the processing workflow (e.g. new Timesat version)


## For an additional year of ST/VPP products


In absence of changes to the processing workflow (e.g., new Timesat version), the annual production run just adds one more year of ST/VPP products.

**Step 1: Verify production of UTM-gridded products**

The production workflows create the UTM-gridded ST and VPP products by running Timesat. 
Based on the tracked product status, any erroneous files are corrected (re-produced). 

After the green light to disseminate the ST/VPP products and before starting the seeding, verify that all products are available on storage. 
There should be 1088 UTM tiles per time slot and per product type.

Hence, for one year and one version, there should be:

>1 088 tiles x 2 types (PPI & QFLAG) x 36 periods per year = 78 336 ST UTM files
>
>1 088 tiles x 14 types (AMPL, etc) x 2 seasons = 30 464 VPP UTM files

If not done already, make sure the **required metadata records are created in the Elastic Search index** for production status monitoring.

**Step 2: Ingest into catalogue service**

By running the OSCARS management software package, ingest the created S3 files into the catalogue.

By opening the following links in a browser, the number of catalogued product files can be checked. 
The “totalResults” property of the JSON response provides the count, that should match the number of file objects on the S3 storage from the previous step.

>Seasonal Trajectories: 
>
>https://phenology.vgt.vito.be/products?collection=copernicus_r_utm-wgs84_10_m_hrvpp-st_p_2017-now_v01&start=2022-01-01&productVersion=V105 
>
>VPP parameters: 
>
>https://phenology.vgt.vito.be/products?collection=copernicus_r_utm-wgs84_10_m_hrvpp-vpp_p_2017-now_v01&start=2022-01-01&productVersion=V105 

In the catalogue response, copy the download URL (href) of the first product file and copy that to the browser’s address bar to test the download. 
A login with [WEkEO user account](https://www.wekeo.eu/data) is required to complete the download.

After the catalogue ingestion of Step 2, the **number of S3 file objects**, the **number of records in the production monitoring** ElasticSearch index and the **number of products available in the catalogue** are all **equal**.

After the verifications of Step 1, the production can normally continue with the production of the LAEA-gridded products by reprojection and resampling of the UTM-gridded ones. 
This takes a few days and can be carried out in parallel to the steps for making the UTM products accessible.

**Step 3: Check Spark worker hardware and trigger the WMS/WMTS cache seeding**

The near-real time seeding for the Vegetation Indices products is carried out on five eo1.small-flavoured virtual machines. 
These workers are always on, in order to seed the incoming VI products directly after their production (which can be at any time of day).
As the actual load is limited (few workflow runs and Spark cluster jobs per day), the same workers can easily be re-used to seed the map layers for for a single year of the Seasonal Trajectories and VPP parameters inside 1-2 days. 
For large re-seeding jobs (depending on the number of map layers and number of dates to be seeded, e.g. multiple years or VI map layers), it can be better to scale up to (at most) 20 worker nodes prior to triggering the seeding.

In the NiFi [workflow for seeding](../02_Workflows_in_NIFI/)
the processors for triggering the seeding the ST are at the bottom and those for the VPP map layers are on the left-hand side.
There is a processor each map layer. 

Open the properties of each processor to update the startDate and endDate (YYYY-MM-DD format) to cover the full year. 
Then start up each processor and stop it again once the flowfiles are generated (or use the “run once” option).
Note that the seeding from LAEA-gridded products is currently disabled.

**Step 4: Monitor the seeding jobs**

A few minutes after the start of the NiFi processors, the first Spark jobs should appear in the Spark Master dashboard. Jobs are prioritized by date. For each date and map layer, the Spark job for seeding is launched first and only when it is finished, the generate pyramid job is launched.

Make sure that the workers are all active and that jobs end within a reasonable time: 
seeding jobs should take less than 10min, generate pyramid jobs should be even faster (<= 5 min). 
Durations – in particular the time a job is in WAITING state - can run up when the cluster is busy or in case of an issue (e.g. disk space of master node filling up).

Wait for all seeding jobs to be completed before verifying the outcome (next step).

**Step 5: Verify the outcome of the seeding on the S3 storage**

The output of the seeding, a set of PNG images, organized in zoom level quads, are created in the buckets hr-vpp-wmts-st-utm-010m and hr-vpp-wmts-vpp-utm-010m, with the key prefixes (object storage “folders”) that are indicated by the “seedCollection” property of each processor, such as “VPP/SOSD-S2” for season 2 (“-S2” suffix) of the Start-of-Season Date (SOSD) layer, or ST/PPI/v2/ for the PPI seasonal trajectories (“v2” refers to the second version of the colour map).

Using the s3cmd (or AWS S3) command line utility, two types of checks can be performed: count checks and modification date checks.

**Step5a: Checking the number of object storage objects (PNG files)**

As the different types of ST and VPP products are all equally and very well filled (few no-data pixels), the number of PNG images that are generated, for a given time slot (date), should be (nearly) the same for the different map layers. 
This can be done by iterating the recursive ls command as in the following bash script:

~~~~
date=2021-01-01
for lay in `cat ./VPP_layers `; do
	for sea in S1 S2; do 
		pth="hr-vpp-wmts-vpp-utm-010m/VPP/${lay}-${sea}/g/${date}/”
		echo -n "${lay},${sea},${date},${pth},”
		s3cmd ls --recursive s3://${pth} | grep .png|wc -l; done; sleep .05;
	done
done
~~~~

This yields a CSV output like:

>MAXD,S1,2021-01-01,hr-vpp-wmts-vpp-utm-010m/VPP/MAXD-S1/g/2021-01-01/,187
>MAXD,S2,2021-01-01,hr-vpp-wmts-vpp-utm-010m/VPP/MAXD-S2/g/2021-01-01/,181
>EOSD,S1,2021-01-01,hr-vpp-wmts-vpp-utm-010m/VPP/EOSD-S1/g/2021-01-01/,187
>…

All the VPP first season (S1) layers should have the same number of PNG image files (187 in this example). 
The second season (S2) layers are different (more data gaps/no-data) than first season, but their count (181) should be the same for the different season 2 layers (MAXD-S2, EOSD-S2 etc). 

To verify this, the printed CSV information can be analyzed easily in a spreadsheet tool or Pyhon Pandas dataframe.

**If any combination of map layer and date shows an aberrant count, repeat the triggering of Step 3 for the affected map layer(s), setting the startDate and endDate properties to cover the affected date(s).**

**Note:**
When a similar count check is performed for the map layers of the Vegetation Indices products, there are small differences between the map layers (typically a delta of 5 PNGs or less) due to the different amounts of no-data in the products. 
The script checkPNGcounts.py is a sample Python script for analyzing the PNG count information.

**Step5b Check the timestamp of re-seeded files**

When a specific time slot (date) and map layer have been re-seeded, it can be important to check that all the PNGs file are reproduced (over-written) and no PNGs with old last modification date remain in the storage.

~~~~
date=2021-01-01
for lay in `cat ./VPP_layers `; do
	for sea in S1 S2; do
		echo "======= $lay $sea =======";
		pth="hr-vpp-wmts-vpp-utm-010m/VPP/${lay}-${sea}/g/${date}/”
		s3cmd ls --recursive s3://${pth} | grep -vE “^2023-04-09”; done; sleep .05; 
	done
done
~~~~
whereby “2023-04-09” is the date of the last seeding run and VPP_layers is a small text file listing the VPP map layers previxes to be checked.

**If the output is non-empty and shows older PNGs for specific dates and map layers, repeat the triggering of Step 3 for the affected map layer(s), setting the startDate and endDate properties to cover the affected date(s).**

**Step 6.	Verify the outcome of the seeding visually**

Use one of the connected portals (e.g., [WEkEO data portal](https://www.wekeo.eu/data) or [Land portal map viewer](https://land.copernicus.eu/en/map-viewer)) or a GIS to display the map layers provided by WMS/WMTS service, for the dates that have been seeded. 
This can be useful to check for visual artifacts such as missing tiles or issues in the seeding configuration. 
Keep in mind that zooming out (level <= 6) displays the seeded PNG images directly, whereas zooming in (level > 6) means that the COG data are fetched and rendered directly.


## For an updated version of an already available year


The seeding workflow uses all the products available in the catalogue, filtering on collection, date and product type. It does not account for the product version.

Therefore, it is required to 
* First update the S3 storage by moving the old version to an offline storage.
* Then, update the catalogue service by ingesting the products of the new version and deleting (or disabling) the catalogue metadata records of the products with the old version.
* Query the catalogue with the productVersion=… filter to verify the number of products per version.

The seeding workflow should only be triggered (see Step 3) when both the storage and catalogue service are fully up-to-date.
After completion of the seeding workflow (Step 4), the verification steps (Step 5 & 6) are to be performed for the re-seeded year.
