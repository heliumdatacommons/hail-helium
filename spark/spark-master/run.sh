#!/usr/bin/env bash


# tell flask proxy to bind to host port 8088 and proxy to localhost:8888 (jupyter)
git clone https://github.com/theferrit32/auth-proxy.git /auth-proxy
cd /auth-proxy
export FLASK_PORT=8088
cat > /auth-proxy/config.json <<EOF
{
    "flask_port": ${FLASK_PORT},
    "auth_service_key": "${AUTH_SERVICE_KEY}",
    "default_proxy_destination": "http://localhost:8888",
    "whitelist": ${OAUTH_WHITELIST},
    "validate_url": "https://auth.commonsshare.org/validate_token?provider=auth0&access_token={token}",
    "auth_url": "https://auth.commonsshare.org/authorize?provider=auth0&scope=openid%20profile%20email"
}
EOF
# workers has to be 1 for in-memory session state
gunicorn --workers 1 --daemon --bind 0.0.0.0:${FLASK_PORT} \
  --access-logfile /tmp/auth-proxy-access.log \
  --error-logfile /tmp/auth-proxy-error.log \
  proxy:app


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

/usr/lib/spark/bin/spark-class org.apache.spark.deploy.master.Master &
mkdir /jupyter
cd /jupyter
#jupyterhub-singleuser --allow-root $@
jupyter lab --allow-root $@
