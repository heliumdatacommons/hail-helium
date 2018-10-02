FROM ubuntu:bionic

ARG HADOOP_BIN_URL=http://archive.apache.org/dist/hadoop/common/hadoop-2.7.5/hadoop-2.7.5.tar.gz

RUN apt-get update \
    && apt-get install -y curl python3 python3-pip openjdk-8-jdk \
    && rm -f /usr/bin/python \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && curl -o hadoop.tgz ${HADOOP_BIN_URL} \
    && tar zxf hadoop.tgz \
    && mv hadoop-* hadoop \
    && mv hadoop /usr/lib \
    && rm hadoop.tgz \
    && mkdir /var/hadoop

ENV HADOOP_HOME /usr/lib/hadoop
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64
ENV PATH ${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:${PATH}
ENV HADOOP_CONF_DIR ${HADOOP_HOME}/etc/hadoop

ADD etc ${HADOOP_HOME}/etc




