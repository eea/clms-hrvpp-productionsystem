# Updating the processing of the Vegetation Indices

Note that this processing is running every day, automatically.
It is advised to temporarily stop the automated processing to perform the updates.

**Step 1: Update prerunner script**


Update scripts/pl_sen2_vi/src/sentinel2biopar/cluster/S3_prerunner.py with
* reference to the docker image prepared in the previous step
* reference to the configuration (.ini) file

~~~~
def run_s3_hrvpp(products):
    .....
    container = client.containers.run("vito-docker-private.artifactory.vgt.vito.be/hrvpp-biopar-wekeo:087",
                       "python3 /home/user/workflow_runner_hrvpp.py --product_id {0} --product_location {1} \
                       -v -c /home/user/config_hrvpp_WEkEO_v101.ini --out_dir /home/user --delete_tmp".format(
                        product_id, product_location),
    ......
~~~~

**Step 2: Upload new S3_prerunner.py to hr-vpp-scripts bucket**


**Step 3: Run the [Vegetation Indices workflow](../02_Workflows_in_NIFI/) in NiFi**


* In the VI workflow, open the list of NiFi variables to update the variables _version_ and _versionvi_.
* Verify the ElasticSearch query for populating (ingesting) the Sentinel-2 input data and revise it if needed.  
* Run the NiFi workflow.


**Step 4: Run the [workflow for handling double input filenames](../02_Workflows_in_NIFI/) in NiFi**


Repeat the same updates as for the main Vegetation Indices workflow, described above.
