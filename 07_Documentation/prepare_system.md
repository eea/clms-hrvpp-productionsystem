# Prepare storage buckets and Docker for product generation

## When more dates are to be processed

Check if buckets (hr-vpp-products-vi-version-YYYYMM) are available for the new  version.

Use script XXXX to create the buckets and set their access privileges (bucket policy / ACL)

## When a new version of the processing software is to be used

**Step 1: Create new configuration file (.ini)**

hrvpp/scripts/pl_sen2_vi/docker/config_hrvpp_WEkEO_v101.ini

~~~~
[general]

version = 200

version_product = 101
~~~~


**Step 2: Update docker file with new configuration**

In hrvpp/scripts/pl_sen2_vi/docker/Dockerfile  
check the reference to biopar wheel (hrvpp-biopar:021), and if needed update reference to latest wheel performing Neural Net calculation for LAI, FAPAR:

~~~~
FROM vito-docker-private.artifactory.vgt.vito.be/hrvpp-biopar:021 

RUN pip install --no-cache-dir rasterio[s3]==1.0.26 "s3fs<0.5.0"  awscli fire requests 
RUN mkdir -p /home/user

COPY pl_sen2_vi/src/sentinel2biopar/cluster/workflow_runner_hrvpp.py /home/user
COPY pl_sen2_vi/docker/config_hrvpp_WEkEO_v100.ini /home/user
COPY pl_vi/MDVI.py /home/user
COPY pl_sen2_vi/src/sentinel2biopar /home/user/sentinel2biopar
COPY pl_vi/PPI_single.py /home/user
COPY pl_timesat /home/user
~~~~

**Step 3: Create new docker image with updated code**

* update docker version
* docker build -t vito-docker-private.artifactory.vgt.vito.be/hrvpp-biopar-wekeo:0xx -f hrvpp/scripts/pl_sen2_vi/docker/Dockerfile/home/deroob/git/ hrvpp/scripts/
* docker push vito-docker-private.artifactory.vgt.vito.be/hrvpp-biopar-wekeo:xxx
