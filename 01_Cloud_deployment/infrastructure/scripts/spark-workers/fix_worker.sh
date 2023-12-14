#!/bin/bash

sudo hostnamectl set-hostname $1
sudo sed -i "s/SPARK_PUBLIC_DNS=.*/SPARK_PUBLIC_DNS=$1/" /etc/spark/worker.sh

ipa=`hostname --ip-address`
sudo sed -i "s/SPARK_LOCAL_IP=.*/SPARK_LOCAL_IP=$ipa/" /etc/spark/worker.sh

sudo systemctl restart spark-worker
