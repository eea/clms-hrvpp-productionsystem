# Networking

## Domain Name Service (DNS)

Two dedicated DNS domains were set up, one for production (hrvpp2.vgt.vito.be) and one for development (hrvpp2-dev.vgt.vito.be).
The domains are forwarded to the three CloudFerro DNS servers (cloud-dns1.cloudferro.com, cloud-dns2.cloudferro.com, cloud-dns3.cloudferro.com).

Two DNS views are defined: one for VITO internal use (exploiting the VPN tunnel/gateway) and one for public use.

## Virtual Private Network (VPN)

As the OpenSense VPN provided by CloudFerro (VPN-as-a-Service) was found unsuitable, a dedicated VPN gateway solution is deployed to secure remote connectivity and login (SSH).
For access to the Spark workers (logs, user interface), an SSH tunnel is configured used that proxies the traffic through a dedicated VPN gateway host, with Strongswan package for IPSec.

## Load Balancing (LB)

Incoming HTTPS traffic (catalogue search/download and WMS/WMTS web services) come in via the OpenStack Load Balancer-as-a-Service (LBaaS). 
Due to the limited functionality (only network LB) of this load balancer, HR-vpp consortium had to add two load balancing nodes (web-1 and web-2) that redirect traffic to the backend service and which take care of the SSL termination.
