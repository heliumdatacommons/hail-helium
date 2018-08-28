#!/usr/bin/env bash

/usr/lib/spark/bin/spark-class org.apache.spark.deploy.master.Master &
mkdir /jupyter
cd /jupyter
jupyterhub-singleuser --allow-root $@
