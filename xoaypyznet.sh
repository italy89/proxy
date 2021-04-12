#!/bin/sh
random() {
		tr </dev/urandom -dc A-Za-z0-9 | head -c5
		echo
}

array=(1 2 3 4 5 6 7 8 9 0 a b c d e f)
gen64() {
		ip64() {
				echo "${array[$RANDOM % 16]}${array[$RANDOM % 16]}${array[$RANDOM % 16]}${array[$RANDOM % 16]}"
		}
		echo "$1:$(ip64):$(ip64):$(ip64):$(ip64)"
}

gen_3proxy() {
	cat <<EOF
daemon
maxconn 10000
nscache 65536
timeouts 1 5 30 60 180 1800 15 60
setgid 65535
setuid 65535
stacksize 6291456
flush
auth none

users $(awk -F "/" 'BEGIN{ORS="";} {print $1 "::" $2 " "}' ${WORKDATA})

$(awk -F "/" '{print "auth none\n" \
"proxy -6 -n -a -p" $4 " -i" $3 " -e"$5"\n" \
"flush\n"}' ${WORKDATA})
EOF
}

gen_data() {
	seq $FIRST_PORT $LAST_PORT | while read port; do
		echo "$(random)/$(random)/$IP4/$port/$(gen64 $IP6)"
	done
}

gen_iptables() {
	cat <<EOF
	$(awk -F "/" '{print "iptables -I INPUT -p tcp --dport " $4 "  -m state --state NEW -j ACCEPT"}' ${WORKDATA})
EOF
}

gen_ifconfig() {
	cat <<EOF
$(awk -F "/" '{print "ifconfig ens3 inet6 add " $5 "/64"}' ${WORKDATA})
EOF
}

gen_ifconfig_del() {
	cat <<EOF
$(awk -F "/" '{print "ifconfig ens3 inet6 del " $5 "/64"}' ${WORKDATA})
EOF
}

echo "working folder = /home/proxy-installer"
WORKDIR="/home/proxy-installer"
WORKDATA="${WORKDIR}/data.txt"
mkdir $WORKDIR
cd $WORKDIR

IP4=$(curl -4 -s icanhazip.com)
IP6=$(curl -6 -s icanhazip.com | cut -f1-4 -d':')

echo "Internal ip = ${IP4}. Exteranl sub for ip6 = ${IP6}"

FIRST_PORT=10000
LAST_PORT=10100

echo "Gen data"
gen_data >$WORKDIR/data.txt
echo "Gen Ip Table"
gen_iptables >$WORKDIR/boot_iptables.sh
echo "Gen If Config"
gen_ifconfig >$WORKDIR/boot_ifconfig.sh

echo "Gen Proxy Config"
gen_3proxy > /usr/local/3proxy/conf/3proxy.cfg

cat >/etc/reload_rc.local <<EOF
systemctl start NetworkManager.service
ifup ens3
bash ${WORKDIR}/boot_iptables.sh
bash ${WORKDIR}/boot_ifconfig.sh
ulimit -n 65535
/usr/local/etc/3proxy/bin/3proxy /usr/local/etc/3proxy/3proxy.cfg &
EOF

chmod +x $WORKDIR/boot_*.sh /etc/reload_rc.local
bash /etc/reload_rc.local

echo "End"
