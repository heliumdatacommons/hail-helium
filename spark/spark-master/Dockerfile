FROM dchampion24/hail-base:2.2.2

# install JupyterHub
ADD config_jupyter.py /tmp/config_jupyter.py
RUN apt-get install -y python3-dev \
    && pip3 install --no-cache-dir jupyterlab numpy pandas matplotlib seaborn parsimonious jupyter-spark gcsfs \
                                   plotly scipy statsmodels datadog selenium pyensembl jgscm bokeh lxml decorator==4.2.1 \
    && mkdir -p /usr/local/share/jupyter/kernels/hail \
    && python3 /tmp/config_jupyter.py \
    && rm /tmp/config_jupyter.py \
    && jupyter serverextension enable --py jupyter_spark \
    && jupyter nbextension install --py jupyter_spark \
    && jupyter nbextension enable --py jupyter_spark \
    && jupyter nbextension enable --py widgetsnbextension \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && rm -f /var/cache/apt/archives/*.deb

ADD spark_conf/spark-env.sh ${SPARK_HOME}/conf/spark-env.sh
ADD spark_conf/spark-defaults.conf ${SPARK_HOME}/conf/spark-defaults.conf

ADD run.sh /sbin/run.sh
RUN chmod +x /sbin/run.sh

EXPOSE 7077
EXPOSE 4040

ENTRYPOINT ["/sbin/run.sh"]

