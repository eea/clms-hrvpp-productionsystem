# Docker images

## Overview

Docker images are built and stored in Artifactory (vito-docker-private.artifactory.vgt.vito.be).

|Name of Docker image|Purpose|Version deployed|
|--------------------|-------|----------------|
|hrvpp-biopar-wekeo|generation of Vegetation Indices, Seasonal Trajectories and VPP parameter products|131|
|hrvpp-wekeo-extractions|VI/ST/VPP data extractions for validation|017|

To build the docker image with SNAP8 and to make it compatible with baseline 04.00 of S2 data, a manual intervention is needed because SNAP8 update feature makes the image builder crash.
As such we first build an image (DockerfileBaseline) from a base centos image with SNAP8.0 without any update. secondly we create a container based on this image and update SNAP from within the container afterwards we create a new image from this container.
This image (biopar:025) is then used as baselayer to further enhance with our own scripts to create the hrvpp-biopar-wekeo images.

## Version history

**Docker image for product generation (hrvpp-biopar-wekeo):**
Image were created with DockerfileHRVPP.
|Version|Description|
|-----|-----|
|<=084|Initial/beta version|
|085-090|Small fixes to S3 mount point, mask_hrvpp.py and PPI_single, errors in V101 BETA processing<br>Decrease number of rows processed per chunk (100->75)<br>Timesat 4.1.6 with fix<br>Added Sen2cor 2.9|
|091-094|Adding LAEA postprocessing|
|095|Correction MDVI error (v102)|
|105|LAEA postprocessing ready for production|
|108-109|Test version with updates to Sen2COR (2.10), SNAP (8) and S2Angle.py|
|110-111|VI	Processing 2021 (V101/V102) with small bugfix|
|114|PPI was not calculated for merged tiles. Added to list of products to merge|
|117|Timesat processing run 2021, with updates to processing, output and performance|
|118|LAEA processing run 2021|
|119-121|Update to switch from WAW2 to WAW3 (CF3) cloud and to enable near-real time VI processing, with revised bucket access and merge for double files|
|127|Update to new timesat version (418) for V105 ST/VPP processing|
|130|Minor fixes to LAEA resampling in V105|
|131|Hotfix to mitigate serious problems at HRSI in NRT processing|

**Docker image for data extractions for validation (hrvpp-wekeo-extractions):**
Images were created with DockerfileExtractions.
|Version|Description|
|-----|-----|
|005|Extracts the validation points for the VIs|
|008|Extracts the validation for the ST/VPP parameters|
|013|Extracts for VIs/ST/VPP fix with SSL issue (older container will not work anymore), correction in date format|
|017|Update to extract 1km aligned with s3 grid|
