#!/usr/bin/env bash

N_CORES=$(echo ${MARATHON_APP_RESOURCE_CPUS} | cut -d'.' -f1)
MEM=$(echo ${MARATHON_APP_RESOURCE_MEM} | cut -d'.' -f1)

cat > ${HADOOP_HOME}/etc/hadoop/core-site.xml <<EOF
<configuration>

  <property>
    <name>fs.defaultFS</name>
    <value>${NAMENODE}</value>
  </property>

  <property>
    <name>hadoop.tmp.dir</name>
    <value>/var/hadoop</value>
  </property>

  <property>
    <name>google.cloud.auth.service.account.enable</name>
    <value>true</value>
  </property>

  <property>
    <name>google.cloud.auth.service.account.json.keyfile</name>
    <value>/gcp.json</value>
  </property>

</configuration>
EOF

cat >> ${SPARK_HOME}/conf/spark-defaults.conf <<EOF
spark.master spark://$(hostname -i):7077
spark.hadoop.google.cloud.auth.service.account.enable true
google.cloud.auth.service.account.json.keyfile /gcp.json
EOF

echo ${GCP_KEY} > /gcp.json

ln -s ${HADOOP_HOME}/etc/hadoop/core-site.xml ${SPARK_HOME}/conf/core-site.xml

/usr/lib/spark/bin/spark-class org.apache.spark.deploy.worker.Worker -c ${N_CORES} -m ${MEM}M $@

