#!/bin/bash

#proxy_diff=$(diff <(ls -1 /Video3/enter10/txmaster/ | sed s/.mov//g) <(ls -1 /Video3/enter10/txproxy/ | sed s/.mp4//g | sed s/.jpg//g | sed s/_key//g | sort | uniq) | awk '{print $2}' | awk '!/^$/' | tee /var/mam/mam.services.cpv1/mam.script/proxy_diff.txt)

logdate=$(date +"%Y-%m-%d")


while read i




do



if [[ -e /Video3/enter10/txmaster/"${i}".mov ]] && [[ ! -f /Video3/enter10/txproxy/"${i}".mp4 ]]

then

now=$(date "+%Y-%m-%d %H:%M:%S")

echo $i "at" $now "proxy generating...." >> /home/mamgroup/enter10proxy_{$logdate}.log

sleep 1

/usr/local/bin/ffmpeg  -i /Video3/enter10/txmaster/"${i}".mov -y -r 25 -b:a 64k -b:v 1024k  -c:v h264_nvenc -pix_fmt yuv420p  -threads 16  -map 0:0 -strict -2 -sn -dn   /Video3/enter10/txproxy/"${i}".mp4;/usr/local/bin/ffmpeg -i /Video3/enter10/txmaster/"${i}".mov -vf  'thumbnail,scale=640:360' -frames:v 1  -y /Video3/enter10/txproxy/"${i}".jpg;

else

echo $i "Parent Clip not available!"

sleep 1

fi


done < /var/mam/mam.services.cpv1/mam.script/proxy_diff.txt
