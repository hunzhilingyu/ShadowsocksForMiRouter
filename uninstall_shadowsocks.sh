#!/bin/sh

clear

# Make sure you have install Shadowsocks
if [[ ! -f /etc/firewall.user.back ]]; then
	echo "Error: You have not install Shadowsocks!"
	exit 1
fi

# Make sure only root can run our script
if [[ `id -u` -ne 0 ]]; then
   echo "Error: This script must be run as root!" 1>&2
   exit 1
fi
#stop ss-redir process
/etc/init.d/shadowsocks stop
/etc/init.d/shadowsocks disable

#uninstall shadowsocks
mount / -o rw,remount
rm -f /usr/bin/ss-redir
sync
mount / -o ro,remount

cd /userdisk/data/
rm -rf shadowsocks-miwifi

# if you want to delete config file, you can comment out the following code.
# rm -rf /etc/shadowsocks
mv -f /etc/firewall.user.back /etc/firewall.user
rm -f /etc/dnsmasq.d/fgserver.conf


#restart all service
/etc/init.d/dnsmasq restart
/etc/init.d/firewall restart

# delete shadowsocks init file
rm -f /etc/init.d/shadowsocks
echo "Shadowsocks uninstall success!"
echo ""
exit 0
