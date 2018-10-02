#!/usr/bin/env bash
export SPARK_LOCAL_IP=$(hostname -i)
export LIBPROCESS_IP=${SPARK_LOCAL_IP}

