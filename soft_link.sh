#!/bin/bash
mx_path=/var/www/html/cloudMX/PROXY
pl_path=/Video/runningchannels
path=/Video
soft_lin_path=/var/mam/mam.services/mamgui/wwwroot/proxy
cur_date=$(date | cut -d ' ' -f 2,3 | awk -F ' ' '{print $1$2}')
fld_date=$(ls -ltr $path | awk  '{print $6$7}')
for f in $fld_date
do
#echo $f
if [[ $cur_date == $f ]]
then

list=$(ls -ltr $path | awk  '{print $6$7,$9}' | grep $f)
folder_name=$(echo $list | awk '{print $2}')
if [[ -e $path/$folder_name/txmaster/ ]]
then

status=$(ls -ltr $soft_lin_path | awk NR!=1 | grep -w ${folder_name^^}_TXMASTER | cut -c 1)

if [[ $status == "l" ]]

then

echo "softlink exists"

else

echo "creating soft link"

cd $soft_lin_path

ln -s $path/$folder_name/txproxy ${folder_name^^}_TXMASTER

fi

#pl_status=(ls -ltr $soft_lin_path | awk NR!=1 | grep -wE "${folder_name^^}_M|${folder_name^^}_B" | cut -c 1)

if [[ -e  $mx_path/${folder_name^^}_MAIN ]] && [[ -e  $mx_path/${folder_name^^}_BKUP ]]

then

echo "folder exists"

else

cd $mx_path

mkdir ${folder_name^^}_MAIN
mkdir ${folder_name^^}_BKUP

chmod -R 777 $mx_path/${folder_name^^}_MAIN
chmod -R 777 $mx_path/${folder_name^^}_BKUP

cd $mx_path/${folder_name^^}_MAIN
ln -s $path/$folder_name/txproxy PRI
sleep 1
cd $mx_path/${folder_name^^}_BKUP
ln -s $path/$folder_name/txproxy PRI



fi


fi

fi


done

