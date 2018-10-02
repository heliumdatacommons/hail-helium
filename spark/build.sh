#!/usr/bin/env bash

docker build hadoop-base -t dchampion24/hadoop-base:2.7.5
docker build hadoop-hdfs-namenode -t dchampion24/hadoop-hdfs-namenode:2.7.5
docker build hadoop-hdfs-datanode -t dchampion24/hadoop-hdfs-datanode:2.7.5
docker build hail-base -t dchampion24/hail-base:2.2.2
docker build spark-master -t dchampion24/hail:spark-master
docker build spark-worker -t dchampion24/hail:spark-worker

docker push dchampion24/hadoop-base:2.7.5
docker push dchampion24/hadoop-hdfs-namenode:2.7.5
docker push dchampion24/hadoop-hdfs-datanode:2.7.5
docker push dchampion24/hail-base:2.2.2
docker push dchampion24/hail:spark-master
docker push dchampion24/hail:spark-worker
