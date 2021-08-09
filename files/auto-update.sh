#!/bin/bash
cd /root
exec 1> >(logger -s -t $(basename $0)) 2>&1
wget -N -d --user-agent="Mozilla/5.0 (Windows NT x.y; rv:10.0) Gecko/20100101 Firefox/10.0" https://github.com/tomdoyle87/Apf-SystemD/releases/download/v1.0/apf-current-systemd.tar.gz
sleep 1
if tail -n 4 /var/log/messages | egrep "‘apf-current-systemd.tar.gz’ saved"; then
	echo "Updating"
	systemctl stop apf
	INSTALL_PATH=${INSTALL_PATH:-"/etc/apf"}
	tar xvzf apf-current-systemd.tar.gz
	cp {$INSTALL_PATH/conf.apf,$INSTALL_PATH/allow_hosts.rules,$INSTALL_PATH/deny_hosts.rules,$INSTALL_PATH/glob_allow.rules,$INSTALL_PATH/glob_deny.rules} /root/
	rm -rf $INSTALL_PATH/
	mv /root/apf/files/ $INSTALL_PATH/
	mv -f {/root/conf.apf,/root/allow_hosts.rules,/root/deny_hosts.rules,/root/glob_allow.rules,/root/glob_deny.rules} $INSTALL_PATH/
	chmod -R 640 $INSTALL_PATH/
	chmod 750 $INSTALL_PATH/apf
	chmod 750 $INSTALL_PATH/apf-start.sh
	chmod 750 $INSTALL_PATH/uninstall.sh
	chmod 750 $INSTALL_PATH/firewall
	chmod 750 $INSTALL_PATH/vnet/vnetgen
	chmod 750 $INSTALL_PATH/extras/get_ports
	chmod 750 $INSTALL_PATH/
	chmod 750 $INSTALL_PATH/auto-update.sh
		if [ -d "/lib/systemd/system" ]; then
			cp /root/apf/apf-restart.sh $INSTALL_PATH/
			chmod 755 $INSTALL_PATH/apf-restart.sh
		elif [ -d "/etc/rc.d/init.d" ]; then       
			chmod 755 /etc/cron.daily/apf
		elif [ -d "/etc/init.d" ]; then
        		chmod 755 /etc/cron.daily/apf
		fi
	cp -pf {/root/apf/.ca.def,/root/apf/importconf} $INSTALL_PATH/extras/
	mkdir $INSTALL_PATH/doc
	cp {/root/apf/README,/root/apf/README-SystemD,/root/apf/CHANGELOG,/root/apf/COPYING.GPL} $INSTALL_PATH/doc
	$INSTALL_PATH/vnet/vnetgen
		if [ -f "/usr/bin/dialog" ] && [ -d "$INSTALL_PATH/extras/apf-m" ]; then
			last=`pwd`
			cd $INSTALL_PATH/extras/apf-m/
			sh install -i
			cd $last
		fi
	systemctl start apf
	rm -rf /root/apf/
	echo -e "Subject: Apf updated\nApf Updated, See Changelog:\n\nhttps://raw.githubusercontent.com/tomdoyle87/Apf-SystemD/master/CHANGELOG" | sendmail root
	exit
else
	echo No Updates
fi
exit
