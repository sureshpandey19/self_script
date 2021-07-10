#!/bin/bash
D_HOST_M="192.168.82.200"
D_USER="cloud_user"
D_PASS="Cloud@123"
D_BASE="mamcdb_cloud"
D_OPT=" -N --disable-pager --raw --silent"
D_CMD_1="mysql -h $D_HOST_M -u $D_USER -p$D_PASS -D $D_BASE"
#'76e824bf-842d-421b-9fbd-37bhungama9a095_'

while :

 do

  sleep 1

   echo " $D_CMD_1 $D_OPT -e \"select concat(clipid,ext) from mamdatalist where deviceuid in ('76e824bf-842d-421b-9fbd-37bhungama9a095_') and (videocodec not like '%mpeg2video | xdcamhd422%' and videocodec not like '%dvvideo | dvcpro50%' and videocodec not like '%mpeg2video | pcm%' and videocodec not like '%MPEG-4 part 2%' and videocodec not like '%mpeg4%') and (clipid not like '%MOV%' or clipid not like '%TC%') limit 1 \""  | sh | sed -e '$!d' | while read i

     do

       clipid=$(mediainfo /Video/hungama/txmaster/"${i}" | grep -iE 'xdcam|mpeg2|complete name|dv|dvcpro' | awk NR==1 | awk -F ':' '{print $2}' | awk -F '/txmaster/' '{print $2}' | awk -F '.' '{print $1}')

       val1=$(mediainfo /Video/hungama/txmaster/"${i}" | grep -iE 'xdcam|mpeg2|complete name|dv|dvcpro|pcm' | awk NR==2 | awk -F ':' '{print $2}')

       val2=$(mediainfo /Video/hungama/txmaster/"${i}" | grep -iE 'xdcam|mpeg2|complete name|dv|dvcpro|pcm' | awk NR==3 | awk -F ':' '{print $2}')


         if [[ ${val1} == *"XDCAM"* ]] || [[ ${val2} == *"MPEG"* ]]

         then

               echo "$D_CMD_1 -e \"update mamdatalist set videocodec='mpeg2video | xdcamhd422',longvideocodec='MPEG-2 video | XDCAM HD422' where clipid = '${clipid}' and videocodec='mpeg2video' and deviceuid in ('76e824bf-842d-421b-9fbd-37bhungama9a095_')\" " |sh

               echo "Entry Update into database.."

               sleep 1


                 elif [[ ${val1} == *"DVCPRO"* ]] || [[ ${val2} == *"DV"* ]]

                 then

                     echo "$D_CMD_1 -e \"update mamdatalist set videocodec='dvvideo | dvcpro50',longvideocodec='DV (Digital Video) | DVCPRO 50' where clipid = '${clipid}' and videocodec='dvvideo' and deviceuid in ('76e824bf-842d-421b-9fbd-37bhungama9a095_')\" " |sh

                     echo "Entry Update into database.."

                     sleep 1
		elif [[ ${val1} == *"PCM"* ]] || [[ ${val2} == *"PCM"* ]]
then
 echo "$D_CMD_1 -e \"update mamdatalist set videocodec='mpeg2video',longvideocodec='MPEG-2 video | PCM' where clipid = '${clipid}' and videocodec='mpeg2video' and deviceuid in ('76e824bf-842d-421b-9fbd-37bhungama9a095_')\" " |sh


         fi



      done

done
