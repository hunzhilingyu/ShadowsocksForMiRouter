#!/bin/sh

clear
echo "#############################################################"
echo "# Install Shadowsocks for Miwifi(r1d)"
echo "#############################################################"

# Check wheather Shadowsocks has been installed
if [[ -d /etc/firewall.user.back ]]; then
	echo "Error: You have installed Shadowsocks. Please remove it after update the MiRouter!" 1>&2
	exit 1
fi

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "Error: This script must be run as root!" 1>&2
   exit 1
fi
cd /userdisk/data/
rm -f shadowsocks-miwifi.tar.gz
wget http://cdn.32ph.com/shadowsocks-miwifi.tar.gz
tar zxf shadowsocks-miwifi.tar.gz

# install shadowsocks ss-redir to /usr/bin
mount / -o rw,remount
cp -f ./shadowsocks-miwifi/ss-redir  /usr/bin/ss-redir
chmod +x /usr/bin/ss-redir
sync
mount / -o ro,remount

# Config shadowsocks init script
cp ./shadowsocks-miwifi/shadowsocks /etc/init.d/shadowsocks
chmod +x /etc/init.d/shadowsocks

#config setting and save settings.
mkdir -p /etc/shadowsocks
echo "#############################################################"
echo "#"
echo "# Please input your shadowsocks configuration"
echo "#"
echo "#############################################################"
echo ""
echo "input server_address(ipaddress is suggested):"
read serverip
echo "input server_port:"
read serverport
echo "input local_port(1082 is suggested):"
read localport
echo "input password:"
read shadowsockspwd
echo "input method"
read method

# Config shadowsocks
cat > /etc/shadowsocks/config.json<<-EOF
{
    "server":"${serverip}",
    "server_port":${serverport},
    "local_port":${localport},
    "password":"${shadowsockspwd}",
    "timeout":60,
    "method":"${method}"
}
EOF

#config dnsmasq
mkdir -p /etc/dnsmasq.d
#cp -f ./shadowsocks-miwifi/fgserver.conf /etc/dnsmasq.d/fgserver.conf
#cp -f ./shadowsocks-miwifi/fgset.conf /etc/dnsmasq.d/fgset.conf
wget --no-check-certificate https://raw.githubusercontent.com/bazingaterry/ShadowsocksForMiRouter/master/fgserver.conf -o /etc/dnsmasq.d/fgserver.conf
wget --no-check-certificate https://raw.githubusercontent.com/bazingaterry/ShadowsocksForMiRouter/master/fgset.conf -o /etc/dnsmasq.d/fgset.conf

#config firewall
cp -f /etc/firewall.user /etc/firewall.user.back
echo "ipset -N setmefree iphash -! " >> /etc/firewall.user
echo "iptables -t nat -A PREROUTING -p tcp -m set --match-set setmefree dst -j REDIRECT --to-port ${localport}" >> /etc/firewall.user

#restart all service
/etc/init.d/dnsmasq restart
/etc/init.d/firewall restart
/etc/init.d/shadowsocks start
/etc/init.d/shadowsocks enable

#install successfully
rm -rf /userdisk/data/shadowsocks-miwifi
echo ""
echo "Congratulations, shadowsocks-miwifi installed complete !"
echo ""
exit 0
