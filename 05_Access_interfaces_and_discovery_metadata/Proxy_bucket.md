# Proxy or overlay S3 bucket

As mentioned [in the storage description](../01_Cloud_deployment/infrastructure/storage.md), CloudFerro created an overlay (proxy) bucket that exposes all HR-VPP product buckets (hr-vpp-products-vi-v01-\*, hr-vpp-products-vi-v01-\*, hr-vpp-products-st-v01-\*, hr-vpp-products-vpp-v01-\*, hr-vpp-products-st-v01-laea-\* and hr-vpp-products-vpp-v01-laea-\*) as a single 'HRVPP' bucket.

This overlay bucket is only accessible *from within a CloudFerro tenant* using the internal S3 endpoint http://data.cloudferro.com*.

[This notebook](https://github.com/eea/clms-hrvpp-tools-python/blob/main/HRVPP_opensearch_demo/HRVPP%20overlay%20bucket%20demo.ipynb) shows how to use the OpenSearch API to search for HR-VPP product files and look up their S3 access URLs using the overlay bucket.
