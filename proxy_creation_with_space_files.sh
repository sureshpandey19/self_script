logdate=$(date +"%Y-%m-%d")

while :

do

ls -ltr /Video3/enter10/txmaster/*.mov | awk -F '/Video' '{print $2}' | awk -F '.' '{print $1}' | awk -F 'txmaster/' '{print $2}' | while read i

do



if [[ ! -f /Video3/enter10/txproxy/"${i}".mp4 ]]

then

now=$(date "+%Y-%m-%d %H:%M:%S")

echo $i "at" $now "proxy generating...." >> /home/mamgroup/enter10proxy_{$logdate}.log

sleep 1

/usr/local/bin/ffmpeg  -i /Video3/enter10/txmaster/"${i}".mov -y -r 25 -b:a 64k -b:v 1024k  -c:v h264_nvenc -pix_fmt yuv420p  -threads 16  -map 0:0 -strict -2 -sn -dn   /Video3/enter10/txproxy/"${i}".mp4;/usr/local/bin/ffmpeg -i /Video3/enter10/txmaster/"${i}".mov -vf  'thumbnail,scale=640:360' -frames:v 1  -y /Video3/enter10/txproxy/"${i}".jpg;

else

echo $i "proxy already available"

sleep 1

fi


done

done
