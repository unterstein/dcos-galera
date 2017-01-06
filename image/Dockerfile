FROM mariadb:10

RUN apt-get update && \ 
	apt-get install -y dnsutils && \
	apt-get clean

COPY galera.cnf /etc/mysql/conf.d/galera.cnf
COPY dcos-galera.sh /dcos-galera.sh

ENTRYPOINT ["/dcos-galera.sh"]
