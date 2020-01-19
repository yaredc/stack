#!/bin/sh

/usr/bin/crontab -u www-data /var/www/crontab
/usr/sbin/crond -d 0 -l 0 -f -L /proc/self/fd/1
