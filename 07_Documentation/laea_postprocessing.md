
**Step 1: Update prerunner script**

Update scripts/pl_LAEA/S3_prerunner_LAEA.py with
o	reference to docker image
o	update years (if necessary and input version)   

**Step 2: Update prerunner script to hr-vpp-scripts bucket**

**Step 3: Update and run the [LAEA reprojection workflow](../02_Workflows_in_NIFI/) in NiFi**

* Open the workflow in NiFi
* Right-click to edit the parameters
* Look for parameters referenced in the _HRVPP LAEA_ process group (workflow) and update them where needed.
  e.g. _ts_startyear_, _version_ts_
* Start generating flowfiles (first processor) to start of the workflow
