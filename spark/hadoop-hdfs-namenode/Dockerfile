FROM dchampion24/hadoop-base:2.7.5

ADD run_namenode.sh /sbin/run_namenode.sh
RUN chmod +x /sbin/run_namenode.sh

EXPOSE 8020
EXPOSE 50070

ENTRYPOINT ["/sbin/run_namenode.sh"]




