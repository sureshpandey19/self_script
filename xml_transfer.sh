#!/bin/bash
path1=/video/seg_xml
log=$(date +%d_%m_%H_%M)
time=$(date +%T)
ftp_ip=202.38.173.95
ftp_port=1992
ftp_user=MNFTP
ftp_pass=Welcome@12
file_count=$(ls -ltr $path1/*.xml 2> /dev/null | wc -l)
if [[ $file_count -gt 0 ]]
then
filename=$(ls -ltr $path1 | grep .xml | awk '{print $9}')
for i in $filename
do
if [[ -e $path1/$i ]]
then
source_path=$path1/$i
dest_path=Planetcast
unbuffer lftp -e 'set ftp:ssl-allow true; set ssl:verify-certificate no;set net:timeout 30; set net:max_retries 3 ;  set net:reconnect_interval_base 30; set net:connection_limit 1;  
put -O  '$dest_path' '$source_path' ;  
bye' -u  $ftp_user,$ftp_pass  $ftp_ip:$ftp_port
if [[ $? -eq 0 ]]
then
echo "$i successfull tranfer at $time" | tee -a /var/log/mam/trans_log/$log.txt
echo -e "SUBJECT:Segment Transfer Status:$i\n\n Hi Team,\n\nSegments of $i has been sent successfully to BMS at ${time}.\n\nThanks,\n
PMSL MAM ADMIN" | sendmail sureshpandey19@gmail.com ashish.zade@in10media.com
mv $path1/$filename $path1/done/
else
echo "$i Tranfer Failed" | tee -a /var/log/mam/trans_log/$log.txt
fi
fi
done
fi
