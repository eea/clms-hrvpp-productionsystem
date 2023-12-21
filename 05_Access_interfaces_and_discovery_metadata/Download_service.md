# Download service

## Purpose

The download service allows to download the individual GeoTIFF raster files over a secured HTTPS connection.
It furthermore supports partial file access with HTTP GET requests with Range header.

## Endpoint

The Catalogue service is used to look up the download URLs of individual files.
These URLs start with _https://phenology.vgt.vito.be/download/_

## Authentication

It is integrated with the Identity Provider service of WEkEO.

