#!/bin/bash

ls -ltr /var/log/mam/log.cpv2/mam.opration_test/accesslog | awk '{print $9}' | while read line
do


cat /var/log/mam/log.cpv2/mam.opration_test/accesslog/$line | grep -iE '9xmet20120' >> /home/mamgroup/log_proxy_0807_9xm

#echo $line


done
