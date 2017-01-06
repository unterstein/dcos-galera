#!/bin/bash -eu

# calc public ip
ip=`/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`

# wait 5 seconds for dns to
echo "waiting 5 seconds for dns"
sleep 5

# try until DNS is ready
url="galera.marathon.containerip.dcos.thisdcos.directory"

for i in {1..20}
do
	digs=`dig +short $url`
	if [ -z "$digs" ]; then
		echo "no DNS record found for $url"
	else
		# calculate discovery members
		echo $digs
		members=`echo $digs | sed -e "s/$ip //g" -e 's/ /,/g'`
		echo "calculated initial discovery members: $members"
		break
	fi
   sleep 2
done

sed -i -e "s/THIS_NODE_IP/$ip/g" -e "s/GCOM_IPS/$members/g" /etc/mysql/conf.d/galera.cnf

# start mysqld
/docker-entrypoint.sh mysqld
