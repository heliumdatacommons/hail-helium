FROM dchampion24/hadoop-base:2.7.5

ADD run_datanode.sh /sbin/run_datanode.sh
RUN chmod +x /sbin/run_datanode.sh

EXPOSE 50010
EXPOSE 50020
EXPOSE 50075

ENTRYPOINT ["/sbin/run_datanode.sh"]




