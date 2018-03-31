#!/bin/bash

# Check if the script is being run by root

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

# Check if ntp service is up and running

result=$(ps ax | grep ntpd | grep -v grep > /dev/null)

if [ $? -eq 1 ]

	then
	echo "NOTICE: ntp is not running"
        service ntp start
	else
        echo "All is ok" > /dev/null
fi

# Check if changes were made

result=$(diff -u0B /etc/ntp.conf /etc/ntp.conf_default)

if [ $? -eq 1 ]

	then
	echo "NOTICE: /etc/ntp.conf was changed"
	echo $result
        cat /etc/ntp.conf_default > /etc/ntp.conf && service ntp restart
	else
        echo "All is ok" > /dev/null
	fi
