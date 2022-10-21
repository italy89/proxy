#!/bin/bash

echo ""
echo -en "\033[37;1;41m РЎРєСЂРёРїС‚ Р°РІС‚РѕРјР°С‚РёС‡РµСЃРєРѕР№ РЅР°СЃС‚СЂРѕР№РєРё IPv6 РїСЂРѕРєСЃРё. \033[0m"
echo ""
echo ""
echo -en "\033[37;1;41m РҐРѕСЃС‚РёРЅРі VPS СЃРµСЂРІРµСЂРѕРІ - VPSVille.ru \033[0m"
echo -en "\033[37;1;41m РЎРµС‚Рё IPv6 - /64, /48, /36, /32 РїРѕРґ РїСЂРѕРєСЃРё. \033[0m"
echo ""
echo ""
echo -en "\033[37;1;41m Р’РќРРњРђРќРР• \033[0m"
echo ""
echo -en "\033[37;1;41m Р”Р°РЅРЅС‹Р№ СЃРєСЂРёРїС‚ РЅР°СЃС‚СЂР°РёРІР°РµС‚ РІ Р°РІС‚РѕРјР°С‚РёС‡РµСЃРєРѕРј СЂРµР¶РёРјРµ IPv6 РїСЂРѕРєСЃРё С‚РѕР»СЊРєРѕ РЅР° Р±Р°Р·Рµ СЃРёСЃС‚РµРјС‹ Debian 8 \033[0m"
echo ""
echo ""

read -p "РќР°Р¶РјРёС‚Рµ [Enter] РґР»СЏ РїСЂРѕРґРѕР»Р¶РµРЅРёСЏ..."

echo ""
echo "РљРѕРЅС„РёРіСѓСЂР°С†РёСЏ IPv6 РїСЂРѕРєСЃРё"
echo ""

echo "Nhap subnet 64/32/128 [ENTER]:"
read network

if [[ $network == *"::/48"* ]]
then
    mask=48
elif [[ $network == *"::/64"* ]]
then
    mask=64
elif [[ $network == *"::/32"* ]]
then
    mask=32
    echo "Р’РІРµРґРёС‚Рµ СЃРµС‚СЊ /64, СЌС‚Рѕ С€Р»СЋР· РЅРµРѕР±С…РѕРґРёРјС‹Р№ РґР»СЏ РїРѕРґРєР»СЋС‡РµРЅРёСЏ СЃРµС‚Рё /32. РЎРµС‚СЊ /64 РїРѕРґРєР»СЋС‡РµРЅР° РІ Р»РёС‡РЅРѕРј РєР°Р±РёРЅРµС‚Рµ РІ СЂР°Р·РґРµР»Рµ - РЎРµС‚СЊ."
    read network_mask
elif [[ $network == *"::/36"* ]]
then
    mask=36
    echo "Р’РІРµРґРёС‚Рµ СЃРµС‚СЊ /64, СЌС‚Рѕ С€Р»СЋР· РЅРµРѕР±С…РѕРґРёРјС‹Р№ РґР»СЏ РїРѕРґРєР»СЋС‡РµРЅРёСЏ СЃРµС‚Рё /36. РЎРµС‚СЊ /64 РїРѕРґРєР»СЋС‡РµРЅР° РІ Р»РёС‡РЅРѕРј РєР°Р±РёРЅРµС‚Рµ РІ СЂР°Р·РґРµР»Рµ - РЎРµС‚СЊ."
    read network_mask
else
    echo "РќРµРѕРїРѕР·РЅР°РЅРЅР°СЏ РјР°СЃРєР° РёР»Рё РЅРµРІРµСЂРЅС‹Р№ С„РѕСЂРјР°С‚ СЃРµС‚Рё, РІРІРµРґРёС‚Рµ СЃРµС‚СЊ СЃ РјР°СЃРєРѕР№ /64, /48, /36 РёР»Рё /32"
    exit 1
fi
echo "Р’РІРµРґРёС‚Рµ РєРѕР»РёС‡РµСЃС‚РІРѕ Р°РґСЂРµСЃРѕРІ РґР»СЏ СЃР»СѓС‡Р°Р№РЅРѕР№ РіРµРЅРµСЂР°С†РёРё"
read MAXCOUNT
THREADS_MAX=`sysctl kernel.threads-max|awk '{print $3}'`
MAXCOUNT_MIN=$(( MAXCOUNT-200 ))
if (( MAXCOUNT_MIN > THREADS_MAX )); then
    echo "kernel.threads-max = $THREADS_MAX СЌС‚РѕРіРѕ РЅРµРґРѕСЃС‚Р°С‚РѕС‡РЅРѕ РґР»СЏ СѓРєР°Р·Р°РЅРЅРѕРіРѕ РєРѕР»РёС‡РµСЃС‚РІР° Р°РґСЂРµСЃРѕРІ!"
fi

echo "Р’РІРµРґРёС‚Рµ Р»РѕРіРёРЅ РґР»СЏ РїСЂРѕРєСЃРё"
read proxy_login
echo "Р’РІРµРґРёС‚Рµ РїР°СЂРѕР»СЊ РґР»СЏ РїСЂРѕРєСЃРё"
read proxy_pass
echo "Р’РІРµРґРёС‚Рµ РЅР°С‡Р°Р»СЊРЅС‹Р№ РїРѕСЂС‚ РґР»СЏ РїСЂРѕРєСЃРё"
read proxy_port

base_net=`echo $network | awk -F/ '{print $1}'`
base_net1=`echo $network_mask | awk -F/ '{print $1}'`

echo "РќР°СЃС‚СЂРѕР№РєР° РїСЂРѕРєСЃРё РґР»СЏ СЃРµС‚Рё $base_net СЃ РјР°СЃРєРѕР№ $mask"
sleep 2
echo "РќР°СЃС‚СЂРѕР№РєР° Р±Р°Р·РѕРІРѕРіРѕ IPv6 Р°РґСЂРµСЃР°"
ip -6 addr add ${base_net}2 peer ${base_net}1 dev eth0
sleep 5
ip -6 route add default via ${base_net}1 dev eth0
ip -6 route add local ${base_net}/${mask} dev lo

echo "РџСЂРѕРІРµСЂРєР° IPv6 СЃРІСЏР·РЅРѕСЃС‚Рё..."
if ping6 -c3 google.com &> /dev/null
then
    echo "РЈСЃРїРµС€РЅРѕ"
else
    echo "РџСЂРµРґСѓРїСЂРµР¶РґРµРЅРёРµ: IPv6 СЃРІСЏР·РЅРѕСЃС‚СЊ РЅРµ СЂР°Р±РѕС‚Р°РµС‚!"
fi


echo "РљРѕРїРёСЂРѕРІР°РЅРёРµ РёСЃРїРѕР»РЅСЏРµРјС‹С… С„Р°Р№Р»РѕРІ"

if [ -f /root/3proxy.tar ]; then
   echo "РђСЂС…РёРІ 3proxy.tar СѓР¶Рµ СЃРєР°С‡Р°РЅ, РїСЂРѕРґРѕР»Р¶Р°РµРј РЅР°СЃС‚СЂРѕР№РєСѓ..."
else
   echo "РђСЂС…РёРІ 3proxy.tar РѕС‚СЃСѓС‚СЃС‚РІСѓРµС‚, СЃРєР°С‡РёРІР°РµРј..."
   wget https://blog.vpsville.ru/uploads/3proxy.tar; tar -xvf 3proxy.tar
fi

if [ -f /root/ndppd.tar ]; then
   echo "РђСЂС…РёРІ ndppd.tar СѓР¶Рµ СЃРєР°С‡Р°РЅ, РїСЂРѕРґРѕР»Р¶Р°РµРј РЅР°СЃС‚СЂРѕР№РєСѓ..."
else
   echo "РђСЂС…РёРІ ndppd.tar РѕС‚СЃСѓС‚СЃС‚РІСѓРµС‚, СЃРєР°С‡РёРІР°РµРј..."
   wget https://blog.vpsville.ru/uploads/ndppd.tar; tar -xvf ndppd.tar
fi


echo "РќР°СЃС‚СЂРѕР№РєР° СЏРґСЂР°"

dpkg -l|grep linux-image|grep "\-4\."
if [ $? -eq 0 ]
then
    echo "РЈСЃС‚Р°РЅРѕРІР»РµРЅРѕ СЏРґСЂРѕ 4.С…, РїСЂРѕРґРѕР¶Р°РµРј РЅР°СЃС‚СЂРѕР№РєСѓ..."
else
    echo "РџСЂРµРґСѓРїСЂРµР¶РґРµРЅРёРµ: СЏРґСЂРѕ 4.x РЅРµ СѓСЃС‚Р°РЅРѕРІР»РµРЅРѕ, РїСЂРёСЃС‚СѓРїР°РµРј Рє СѓСЃС‚Р°РЅРѕРІРєРµ..."
cd /tmp; wget https://blog.vpsville.ru/uploads/kernel-4.3/linux-headers-4.3.0-040300_4.3.0-040300.201511020949_all.deb; wget https://blog.vpsville.ru/uploads/kernel-4.3/linux-headers-4.3.0-040300-generic_4.3.0-040300.201511020949_amd64.deb; wget https://blog.vpsville.ru/uploads/kernel-4.3/linux-image-4.3.0-040300-generic_4.3.0-040300.201511020949_amd64.deb; dpkg -i *.deb;
fi


echo "РљРѕРЅС„РёРіСѓСЂРёСЂРѕРІР°РЅРёРµ ndppd"
mkdir -p /root/ndppd/
rm -f /root/ndppd/ndppd.conf
cat >/root/ndppd/ndppd.conf <<EOL
route-ttl 30000
proxy eth0 {
   router no
   timeout 500   
   ttl 30000
   rule __NETWORK__ {
      static
   }
}
EOL
sed -i "s/__NETWORK__/${base_net}\/${mask}/" /root/ndppd/ndppd.conf

echo "РљРѕРЅС„РёРіСѓСЂРёСЂРѕРІР°РЅРёРµ 3proxy"
rm -f /root/ip.list
echo "Р“РµРЅРµСЂР°С†РёСЏ $MAXCOUNT Р°РґСЂРµСЃРѕРІ "
array=( 1 2 3 4 5 6 7 8 9 0 a b c d e f )
count=1
first_blocks=`echo $base_net|awk -F:: '{print $1}'`
rnd_ip_block ()
{
    a=${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}
    b=${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}
    c=${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}
    d=${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}
    if [[ "x"$mask == "x48" ]]
    then
        e=${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}
        echo $first_blocks:$a:$b:$c:$d:$e >> /root/ip.list
    elif [[ "x"$mask == "x32" ]]
    then
        e=${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}
        f=${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}
        echo $first_blocks:$a:$b:$c:$d:$e:$f >> /root/ip.list
    elif [[ "x"$mask == "x36" ]]
    then
        num_dots=`echo $first_blocks | awk -F":" '{print NF-1}'`
        if [[ x"$num_dots" == "x1" ]]
        then
            #first block
            block_num="0"
            first_blocks_cut=`echo $first_blocks`
        else
            #2+ block
            block_num=`echo $first_blocks | awk -F':' '{print $NF}'`
            block_num="${block_num:0:1}"
            first_blocks_cut=`echo $first_blocks | awk -F':' '{print $1":"$2}'`
        fi
        a=${block_num}${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}
        e=${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}
        f=${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}
        echo $first_blocks_cut:$a:$b:$c:$d:$e:$f >> /root/ip.list
    else
        echo $first_blocks:$a:$b:$c:$d >> /root/ip.list
    fi
}
while [ "$count" -le $MAXCOUNT ]
do
        rnd_ip_block
        let "count += 1"
done
echo "Р“РµРЅРµСЂР°С†РёСЏ РєРѕРЅС„РёРіР° 3proxy"
mkdir -p /root/3proxy
rm /root/3proxy/3proxy.cfg
cat >/root/3proxy/3proxy.cfg <<EOL
#!/bin/bash

daemon
maxconn 10000
nserver 127.0.0.1
nscache 65536
timeouts 1 5 30 60 180 1800 15 60
setgid 65535
setuid 65535
stacksize 6000
flush
auth none
users $(awk -F "/" 'BEGIN{ORS="";} {print $1 "::" $2 " "}' ${WORKDATA})
$(awk -F "/" '{print "auth none\n" \
"proxy -6 -n -a -p" $4 " -i" $3 " -e"$5"\n" \
"flush\n"}' ${WORKDATA})
EOL

echo >> /root/3proxy/3proxy.cfg
ip4_addr=`ip -4 addr sh dev eth0|grep inet |awk '{print $2}'`
port=${proxy_port}
count=1
for i in `cat /root/ip.list`; do
    echo "proxy -6 -s0 -n -a -p$port -i$ip4_addr -e$i" >> /root/3proxy/3proxy.cfg
    ((port+=1))
    ((count+=1))
done

if grep -q "net.ipv6.ip_nonlocal_bind=1" /etc/sysctl.conf;
then
   echo "Р’СЃРµ РїР°СЂР°РјРµС‚СЂС‹ РІ sysctl СѓР¶Рµ Р±С‹Р»Рё СѓСЃС‚Р°РЅРѕРІР»РµРЅС‹"
else
   echo "РљРѕРЅС„РёРіСѓСЂРёСЂРѕРІР°РЅРёРµ sysctl"
   echo "net.ipv6.conf.eth0.proxy_ndp=1" >> /etc/sysctl.conf
   echo "net.ipv6.conf.all.proxy_ndp=1" >> /etc/sysctl.conf
   echo "net.ipv6.conf.default.forwarding=1" >> /etc/sysctl.conf
   echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.conf
   echo "net.ipv6.ip_nonlocal_bind=1" >> /etc/sysctl.conf
   echo "vm.max_map_count=95120" >> /etc/sysctl.conf
   echo "kernel.pid_max=95120" >> /etc/sysctl.conf
   echo "net.ipv4.ip_local_port_range=1024 65000" >> /etc/sysctl.conf
   sysctl -p
fi

echo "РљРѕРЅС„РёРіСѓСЂРёСЂРѕРІР°РЅРёРµ rc.local"
rm /etc/rc.local

if [ "$mask" = "64" ]; then
echo -e '#!/bin/bash \n'  >> /etc/rc.local
echo "ulimit -n 600000" >> /etc/rc.local
echo "ulimit -u 600000" >> /etc/rc.local
echo "ulimit -i 20000" >> /etc/rc.local
echo "ip -6 addr add ${base_net}2 peer ${base_net}1 dev eth0" >> /etc/rc.local
echo "sleep 5" >> /etc/rc.local
echo "ip -6 route add default via ${base_net}1 dev eth0" >> /etc/rc.local
echo "ip -6 route add local ${base_net}/${mask} dev lo" >> /etc/rc.local
echo "/root/ndppd/ndppd -d -c /root/ndppd/ndppd.conf" >> /etc/rc.local
echo "/root/3proxy/bin/3proxy /root/3proxy/3proxy.cfg" >> /etc/rc.local
echo -e "\nexit 0\n" >> /etc/rc.local
/bin/chmod +x /etc/rc.local
fi

if [ "$mask" = "48" ]; then
echo -e '#!/bin/bash \n'  >> /etc/rc.local
echo "ulimit -n 600000" >> /etc/rc.local
echo "ulimit -u 600000" >> /etc/rc.local
echo "ulimit -i 20000" >> /etc/rc.local
echo "ip -6 addr add ${base_net}2 peer ${base_net}1 dev eth0" >> /etc/rc.local
echo "sleep 5" >> /etc/rc.local
echo "ip -6 route add default via ${base_net}1 dev eth0" >> /etc/rc.local
echo "ip -6 route add local ${base_net}/${mask} dev lo" >> /etc/rc.local
echo "/root/ndppd/ndppd -d -c /root/ndppd/ndppd.conf" >> /etc/rc.local
echo "/root/3proxy/bin/3proxy /root/3proxy/3proxy.cfg" >> /etc/rc.local
echo -e "\nexit 0\n" >> /etc/rc.local
/bin/chmod +x /etc/rc.local
fi

if [ "$mask" = "36" ]; then
echo -e '#!/bin/bash \n'  >> /etc/rc.local
echo "ulimit -n 600000" >> /etc/rc.local
echo "ulimit -u 600000" >> /etc/rc.local
echo "ulimit -i 20000" >> /etc/rc.local
echo "ip -6 addr add ${base_net1}2/64 dev eth0" >> /etc/rc.local
echo "ip -6 route add default via ${base_net1}1" >> /etc/rc.local
echo "ip -6 route add local ${base_net}/${mask} dev lo" >> /etc/rc.local
echo "/root/ndppd/ndppd -d -c /root/ndppd/ndppd.conf" >> /etc/rc.local
echo "/root/3proxy/bin/3proxy /root/3proxy/3proxy.cfg" >> /etc/rc.local
echo -e "\nexit 0\n" >> /etc/rc.local
/bin/chmod +x /etc/rc.local
fi

if [ "$mask" = "32" ]; then
echo -e '#!/bin/bash \n'  >> /etc/rc.local
echo "ulimit -n 600000" >> /etc/rc.local
echo "ulimit -u 600000" >> /etc/rc.local
echo "ulimit -i 20000" >> /etc/rc.local
echo "ip -6 addr add ${base_net1}2/64 dev eth0" >> /etc/rc.local
echo "ip -6 route add default via ${base_net1}1" >> /etc/rc.local
echo "ip -6 route add local ${base_net}/${mask} dev lo" >> /etc/rc.local
echo "/root/ndppd/ndppd -d -c /root/ndppd/ndppd.conf" >> /etc/rc.local
echo "/root/3proxy/bin/3proxy /root/3proxy/3proxy.cfg" >> /etc/rc.local
echo -e "\nexit 0\n" >> /etc/rc.local
/bin/chmod +x /etc/rc.local
fi

echo -en "\033[37;1;41m РљРѕРЅС„РёРіСѓСЂР°С†РёСЏ Р·Р°РІРµСЂС€РµРЅР°, РЅРµРѕР±С…РѕРґРёРјР° РїРµСЂРµР·Р°РіСЂСѓР·РєР° \033[0m"
exit 0
