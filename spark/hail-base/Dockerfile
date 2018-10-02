FROM dchampion24/hadoop-base:2.7.5

ARG MIN_HEAP_SIZE=1g
ARG MAX_HEAP_SIZE=4g

# install Spark
ARG SPARK_BIN_URL=http://download.nextag.com/apache/spark/spark-2.2.2/spark-2.2.2-bin-hadoop2.7.tgz

RUN curl -o spark.tgz ${SPARK_BIN_URL} \
    && tar zxf spark.tgz \
    && mv spark-* spark \
    && mv spark /usr/lib \
    && rm spark.tgz

ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64
ENV SPARK_HOME /usr/lib/spark
ENV PATH $PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
ENV SPARK_DIST_CLASSPATH $HADOOP_HOME/etc/hadoop:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/contrib/capacity-scheduler/*.jar
ENV PYSPARK_PYTHON /usr/bin/python3
ENV PYSPARK_DRIVER_PYTHON /usr/bin/python3
ENV PYTHONPATH /usr/lib/spark/python:/usr/lib/spark/python/lib/py4j-0.10.7-src.zip:/opt/hail.zip

ADD conf/spark-env.sh ${SPARK_HOME}/conf/spark-env.sh

# compile Hail
ENV JAVA_OPTS "-Xms${MIN_HEAP_SIZE} -Xmx${MAX_HEAP_SIZE}"

RUN apt-get install -y git g++ make libfreetype6-dev pkg-config libpng-dev \
    && git clone https://github.com/hail-is/hail.git \
    && cd hail/hail \
    && ./gradlew -Dspark.version=2.2.2 -Dbreeze.version=0.13.2 -Dpy4j.version=0.10.7 shadowJar archiveZip \
    && mv build/distributions/hail-python.zip /opt/hail.zip \
    && mv build/libs/hail-all-spark.jar /opt/hail.jar \
    && cd .. \
    && rm -rf hail /root/.gradle

# install GCS connector
ARG GCS_CONNECTOR_URL=https://storage.googleapis.com/hadoop-lib/gcs/gcs-connector-hadoop2-latest.jar
RUN curl -o ${SPARK_HOME}/jars/gcs-connector-hadoop2-latest.jar ${GCS_CONNECTOR_URL}

