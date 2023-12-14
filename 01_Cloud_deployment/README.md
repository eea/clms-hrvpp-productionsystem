# HR-VPP runs on a Copernicus cloud platform

Given the large volume of input Sentinel-2 observations to be processed in HR-VPP that makes bulky
downloads challenging, it makes sense to take the processing to a public cloud platform where the data is
already residing and available. 

For this reason, the HR-VPP tender required the use of a **Copernicus-funded cloud platform**, both for the product generation, storage, and data access web services.

Within the context of Copernicus, the European Commission funded the deployment of five cloud-based
platforms providing centralised access to Copernicus data and information, as well as to processing tools. 
These platforms are known as the Data and Information Access Services (DIAS). 

After a comparison between their offering, the HR-VPP consortium and EEA decided on the DIAS cloud to be used for the first phase of
HR-VPP: the **CloudFerro infrastructure**, which is accessible through CREODIAS and the federated [WEkEO](https://www.wekeo.eu/) cloud (so-called
[WEkEO Elasticity](https://wekeoelasticity.cloudferro.com/)).

The Copernicus cloud platform is in charge of:
* Collecting the Sentinel-2 MSI data from the ground segment and making these available, through
their own catalogue and storage, to HR-VPP for processing
* Making available the other CLMS datasets used in the processing, in particular the HR Snow and Ice
products.
* Providing the networking with public access
* Providing the hardware (fixed and pay-per-use) such as virtual machines for computation and storage
for intermediate and output data files.
* Providing the cloud platform (OpenStack)
* Deployment and operation of an object storage proxy solution, which exposes different S3 object
storage buckets as if they were a single, logical bucket.

The HR-VPP consortium handles the
* the [deployment and scaling of the cloud infrastructure](./infrastructure) (allocation of provisioned hosts) through Terraform, 
* the [deployment of services for product generation and access](./services) and services through Puppet
* running the software (e.g., actual data processing workflows) 
* monitoring the processing and web services

To access the OpenStack console:
* obtain a WEkEO account
* open https://wekeoelasticity.cloudferro.com/ and sign in
* click on [Horizon Cloud Managment Panel](https://horizon.cloudferro.com/project/) for waw3-1 platform
* log in on WEkEO Elasticity
