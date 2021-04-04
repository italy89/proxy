#!/bin/bash
# Author: kenshin17
# OS: Centos 7
# Description: Script install NDP Proxy Daemon, active full subnet ipv6.

IPv6SUBNET="2604:6600:8:b::/64"

echo "######################## CONFIG SYSCTL #########################"
echo "net.ipv6.conf.all.accept_ra = 2" >> /etc/sysctl.conf
echo "net.ipv6.conf.eth0.accept_ra = 2" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.forwarding=1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.proxy_ndp=1" >> /etc/sysctl.conf
echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.conf
echo "net.ipv6.conf.all.proxy_ndp=1" >> /etc/sysctl.conf
echo "net.ipv6.conf.eth0.proxy_ndp=1" >> /etc/sysctl.conf
echo "net.ipv6.ip_nonlocal_bind = 1" >> /etc/sysctl.conf
sysctl -p

echo "############################# ROUTE ############################"
ip -6 route add local $IPv6SUBNET dev lo

echo "######################### INSTALL NDPPD ########################"
# install requirements
yum group -y install "Development Tools"

CHECK_NDPPD=`which ndppd`
if [ $CHECK_NDPPD ]; then
    echo "####################### NDPPD is INSTALLED #######################";
else
echo "######################## INSTALLING NDPPD ########################";
# compile NDP Proxy Daemon
git clone https://github.com/DanielAdolfsson/ndppd
cd ndppd/
make all && make install
# config
cat <<EOF > /etc/ndppd.conf
route-ttl 30000
address-ttl 30000

proxy eth0 {

router yes
timeout 500
autowire no
keepalive yes
retries 3
promiscuous no
ttl 30000

rule $IPv6SUBNET {
    static
    autovia no
    }
}
EOF
fi

echo "######################### STARTING NDPPD #########################";
if pgrep ndppd >/dev/null 2>&1
    then
        echo "NDP Proxy Daemon is running"
    else
        ndppd -d -c /etc/ndppd.conf
fi
