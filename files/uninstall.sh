#!/bin/bash
INSTALL_PATH=${INSTALL_PATH:-"/etc/apf"}
if [ -d "/lib/systemd/system" ]; then
	/bin/systemctl disable apf.service
	/bin/systemctl stop apf.service
	/bin/systemctl disable apf-daily.timer
	/bin/systemctl stop apf-daily.timer
	/bin/systemctl disable apf-daily.service
	/bin/systemctl disable update-apf.timer
	/bin/systemctl stop update-apf.timer
	/bin/systemctl disable update-apf.service
	rm -f {/lib/systemd/system/apf.service,/lib/systemd/system/apf-daily.service,/lib/systemd/system/apf-daily.target,/lib/systemd/system/apf-daily.timer,/lib/systemd/system/update-apf.service,/lib/systemd/system/update-apf.timer,/lib/systemd/system/update-apf.target,/usr/local/sbin/apf-restart.sh}
elif [ -d "/etc/rc.d/init.d" ]; then
	chkconfig apf off
	/etc/rc.d/init.d/apf stop
	rm -f /etc/rc.d/init.d/apf
	rm -f /etc/cron.daily/apf
	rm -f /etc/cron.weekly/apf
elif [ -d "/etc/init.d" ]; then
	chkconfig apf off
	/etc/init.d/apf stop
	rm -f /etc/init.d/apf
	rm -f /etc/cron.daily/apf
	rm -f /etc/cron.weekly/apf
fi
rm -rf $INSTALL_PATH/
rm -f /usr/local/sbin/apf
rm -f /usr/local/sbin/apf-start.sh
rm -f /usr/local/sbin/fwmgr
rm -f /usr/local/sbin/apf-uninstall.sh
rm -f /usr/local/sbin/auto-update.sh
rm -f /etc/logrotate.d/apf
