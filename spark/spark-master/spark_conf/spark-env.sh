#!/usr/bin/env bash
export SPARK_LOCAL_IP=$(hostname -i)
export LIBPROCESS_IP=${SPARK_LOCAL_IP}
export PYTHONPATH=/usr/lib/spark/python:/usr/lib/spark/python/lib/py4j-0.10.7-src.zip:/opt/hail.zip
export PYTHONHASHSEED=0
export PYSPARK_PYTHON=/usr/bin/python3
export PYSPARK_DRIVER_PYTHON=/usr/bin/python3