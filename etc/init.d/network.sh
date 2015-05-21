#!/bin/sh

# gpio 23 = DHCP Static key
echo 23 > /sys/class/gpio/export
echo in > /sys/class/gpio/gpio23/direction


if [ ! -f /config/network.conf ] ; then
    cp /etc/network.conf.factory /config/network.conf
fi

# Read network configuration
dhcp_key="`cat /sys/class/gpio/gpio23/value`"
if [ "dhcp_key" = "1" ] ; then
	dhcp=true
	hostname=antMiner
elif [ -s /config/network.conf ] ; then
    . /config/network.conf
else
    dhcp=true
    hostname=antMiner
fi

echo 23 > /sys/class/gpio/unexport

if [ -n "$hostname" ] ; then
	hostname $hostname
	echo $hostname > /etc/hostname
fi

# Setup link 
ip link set lo up
ip link set eth0 up

ip addr flush dev eth0

if [ "$dhcp" = "true" ] ; then
    if [ "$QUIET" = "true" ] ; then
        udhcpc -b -x hostname:$hostname eth0 > /dev/null
    else
        udhcpc -b -x hostname:$hostname eth0
    fi
else
    # Manual setup
    ip addr add $ipaddress/$netmask dev eth0
    
    ip ro add default via $gateway

    > /etc/resolv.conf
    for ip in $dnsservers ; do
	echo nameserver $ip >> /etc/resolv.conf
    done
fi
