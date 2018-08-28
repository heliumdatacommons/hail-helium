FROM ubuntu:bionic

# install Spark
ARG SPARK_BIN_URL=http://download.nextag.com/apache/spark/spark-2.2.2/spark-2.2.2-bin-hadoop2.7.tgz
ARG MIN_HEAP_SIZE=1g
ARG MAX_HEAP_SIZE=4g

RUN apt-get update \
    && apt-get install -y curl python3 python3-pip openjdk-8-jdk \
    && rm -f /usr/bin/python \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && curl -o spark.tgz ${SPARK_BIN_URL} \
    && tar zxf spark.tgz \
    && mv spark-* spark \
    && mv spark /usr/lib \
    && rm spark.tgz \
    && rm -rf /usr/bin/python \
    && ln -s /usr/bin/python3 /usr/bin/python

ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64
ENV SPARK_HOME /usr/lib/spark
ENV PATH $PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

RUN echo '#!/usr/bin/env bash' >> ${SPARK_HOME}/conf/spark-env.sh \
    && echo 'export SPARK_LOCAL_IP=$(hostname -i)' >> ${SPARK_HOME}/conf/spark-env.sh \
    && echo 'export LIBPROCESS_IP=$SPARK_LOCAL_IP' >> ${SPARK_HOME}/conf/spark-env.sh \
    && echo 'echo "Spark env exported"' >> ${SPARK_HOME}/conf/spark-env.sh

# compile Hail
ENV JAVA_OPTS "-Xms${MIN_HEAP_SIZE} -Xmx4g${MAX_HEAP_SIZE}"

RUN apt-get install -y git g++ make \
    && git clone https://github.com/hail-is/hail.git \
    && cd hail \
    && ./gradlew -Dspark.version=2.2.0 -Dpy4j.version=0.10.7 shadowJar archiveZip \
    && mv build/distributions/hail-python.zip /opt/hail.zip \
    && mv build/libs/hail-all-spark.jar /opt/hail.jar \
    && cd .. \
    && rm -rf hail /root/.gradle

ENV PYTHONPATH /usr/lib/spark/python:/usr/lib/spark/python/lib/py4j-0.10.7-src.zip:/opt/hail.zip
ENV PYTHONHASHSEED 0
ENV PYSPARK_PYTHON /usr/bin/python3
ENV PYSPARK_DRIVER_PYTHON /usr/bin/python3

RUN echo "export PYTHONPATH=${PYTHONPATH}" >> ${SPARK_HOME}/conf/spark-env.sh \
    && echo "export PYTHONHASHSEED=${PYTHONHASHSEED}" >> ${SPARK_HOME}/conf/spark-env.sh \
    && echo "export PYSPARK_PYTHON=${PYSPARK_PYTHON}" >> ${SPARK_HOME}/conf/spark-env.sh \
    && echo "export PYSPARK_DRIVER_PYTHON=${PYSPARK_DRIVER_PYTHON}" >> ${SPARK_HOME}/conf/spark-env.sh \
    && echo "spark.jars=/opt/hail.jar" >> ${SPARK_HOME}/conf/spark-defaults.conf \
    && echo "spark.executorEnv.PYTHONHASHSEED=0" >> ${SPARK_HOME}/conf/spark-defaults.conf \
    && echo "spark.submit.pyFiles=/opt/hail.zip" >> ${SPARK_HOME}/conf/spark-defaults.conf \
    && echo "spark.driver.extraClassPath=/opt/hail.jar" >> ${SPARK_HOME}/conf/spark-defaults.conf \
    && echo "spark.executor.extraClassPath=./hail.jar" >> ${SPARK_HOME}/conf/spark-defaults.conf \
    && echo '#!/usr/bin/env bash' >> ${SPARK_HOME}/conf/spark-env.sh \
    && echo 'export SPARK_LOCAL_IP=$(hostname -i)' >> ${SPARK_HOME}/conf/spark-env.sh \
    && echo 'export LIBPROCESS_IP=$SPARK_LOCAL_IP' >> ${SPARK_HOME}/conf/spark-env.sh

# install JupyterHub
ADD config_jupyter.py /tmp/config_jupyter.py
RUN apt-get install -y python3-dev \
    && pip3 install --no-cache-dir jupyterhub numpy pandas matplotlib seaborn parsimonious jupyter-spark gcsfs \
                                   plotly scipy statsmodels datadog selenium pyensembl jgscm bokeh lxml decorator==4.2.1 \
    && mkdir -p /usr/local/share/jupyter/kernels/hail \
    && python3 /tmp/config_jupyter.py \
    && rm /tmp/config_jupyter.py \
    && jupyter serverextension enable --user --py jupyter_spark \
    && jupyter nbextension install --user --py jupyter_spark \
    && jupyter nbextension enable --user --py jupyter_spark \
    && jupyter nbextension enable --user --py widgetsnbextension \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && rm -f /var/cache/apt/archives/*.deb

ADD run.sh /sbin/run.sh
RUN chmod +x /sbin/run.sh
ENTRYPOINT ["/sbin/run.sh"]

