#!/usr/bin/env bash

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
</configuration>
EOF

hdfs datanode
