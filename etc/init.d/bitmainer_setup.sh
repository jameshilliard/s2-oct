#!/bin/sh
#####################debug###
echo "check mouted config"

check0p3=cat /etc/mtab | grep "mmcblk0p3"
#if [ $? -eq 0 ]; then
	echo $check0p3

	if [ ""x = "$check0p3"x ] ; then
		echo "mounting config"
		mount /dev/mmcblk0p3 /config
	fi
#fi
echo "mounting mmcblk0p1"
mkdir /mnt/mmc1
mount /dev/mmcblk0p1 /mnt/mmc1

###########################
# dropbear
NO_START=0

if [ ! -f /config/dropbear ] ; then
    echo NO_START=0 > /config/dropbear
fi

cp /config/dropbear /etc/default/dropbear

###########################


###########################
# miner.conf
if [ ! -f /config/asic-freq.config ] ; then
    cp /etc/asic-freq.config /config/
fi

# No configuration, create it!
if [ ! -f /config/cgminer.conf ] ; then
    cp /etc/cgminer.conf.factory /config/cgminer.conf
fi
###########################


###########################
# httpdpasswd
if [ ! -f /config/lighttpd-htdigest.user ] ; then
    cp /etc/lighttpd-htdigest.user /config/lighttpd-htdigest.user
fi

# shadow
if [ ! -f /config/shadow ] ; then
    cp -p /etc/shadow.factory /config/shadow
    chmod 0400 /config/shadow
    rm -f /etc/shadow
    ln -s /config/shadow /etc/shadow
else
    rm -f /etc/shadow
    ln -s /config/shadow /etc/shadow
fi
###########################
