#!/bin/bash

# Check if the script is being run by root

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi


# Check if ntp is being installed

if [ $(dpkg-query -W -f='${Status}' ntp 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  apt-get install -y ntp > /dev/null;
fi

# Delete default ntp servers

sed -i '/pool [012]/d' /etc/ntp.conf
sed -i '/pool 3/c ua.pool.ntp.org' /etc/ntp.conf

# Copy ntp config

cp /etc/ntp.conf /etc/ntp.conf_default

# ntp service restart

service ntp restart > /dev/null

# Add cron task

ntppass=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
touch /etc/cron.d/ntp
echo "MAILTO=root" > /etc/cron.d/ntp
echo "*/1     *       *       *       *       root    $ntppass/ntp_verify.sh" >> /etc/cron.d/ntp
