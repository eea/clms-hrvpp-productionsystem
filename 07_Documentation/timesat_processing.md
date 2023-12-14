# Updating and/or running the Timesat processing for Seasonal Trajectories and VPP parameters

**Step 1: update the prerunner script**

Update scripts/pl_timesat/S3_prerunner_timesat.py with
* reference to docker image
* update year(s) 
* update version of PPI input files
* update version of QFLAG input files
* update output version



~~~~
def run(tile, list, sizes):
    ...
    container = client.containers.run("vito-docker-private.artifactory.vgt.vito.be/hrvpp-biopar-wekeo:127",
                                      "python3 /home/user/workflow_timesat.py --tile {0} --paths \x27{1}\x27 --local {2} --version {3} --qversion {4} --mode {5} --multi {6} --oversion {7}".format(tile,
                                                                                                         listtostring[:-1], local, version, qversion, mode,multiparallel,oversion),

    ...
def main(tilestring):
    ...
    start_year = 2019
    output_version='105'
    version = '102'
    qversion = '101'
    years_to_include = 3
    ....
~~~~

Update scripts/pl_timesat/S3_prerunner_timesat.py with
* reference to docker image
* update year(s) 
* update output version

~~~~
def run(tile, list, sizes):
    ...
    container = client.containers.run("vito-docker-private.artifactory.vgt.vito.be/hrvpp-biopar-wekeo:127",
                                      "python3 /home/user/workflow_timesat_merge.py --file {0} --multi {1} --version {2}".format(file,
                                                                                                                              multiparallel, version),
    ...
def main(tilestring):
    ...
    start_year = 2019
    output_version='105'
    years_to_include = 3
    ....
~~~~

**Step 2: Upload revised prerunner scripts to hr-vpp-scripts bucket**


**Step 3: Update and run the [Timesat ST/VPP workflow](../02_Workflows_in_NIFI/) in NiFi**

Open the workflow in NiFi and right-click to edit the parameters.
Check each parameter value, at least
* _version_timesat_ for Timesat software version 
* _version_ts_ as the output file version 
* _ts_startyear_
and update them where needed.

Then run the workflow.

Timesat starts with downloading a large amount of files. The amount of simultaneous downloaded file **MUST** be limited to **90**.

It’ s recommend to start **not more than 50 jobs an hour**.  

At start-up of the workflow, it's best to check some logs and confirm that the download has finished before starting more.
