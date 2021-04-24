#!/bin/bash

ext=".mxf|.mov|.tga|.png|.txt"
threshold_value=30
video_type="Video1 Video"


func()
{
if [[ $# -eq 2 ]] && [[ -e /$video_f/$1/input/video_input/ ]] && [[ -e /$video_f/$1/input/gfx_input/ANIMATION/ ]] && [[ $2 == "video" ]] || [[ $2 == "gfx" ]]

then

  if [[ $2 == "video" ]] 

  then

       count_v=$(ls -ltr /$video_f/$1/input/video_input/ | grep -E $ext | wc -l)

         if [[ $count_v -gt 0 ]] 

         then

               file_timestamp_v=$(ls -ltr /$video_f/$1/input/video_input/ | grep -E ".mov|.mxf" | awk '{print $6,$7,$8}' | head -1)
               cur_timestamp=$(date | awk '{print $2,$3,$4}')
               time_diff_v=$(( ($(date -d "${cur_timestamp}" +%s) - $(date -d "${file_timestamp_v}" +%s)) / 60))




                 if [[ $time_diff_v -gt $threshold_value ]]

                   then

                   echo $count_v


                 fi
        else

        echo "0"


fi
else [[ $2 == "gfx" ]] 


  count_g=$(ls -ltr /$video_f/$1/input/gfx_input/ANIMATION/ | grep -E $ext | wc -l)
    if [[ $count_g -gt 0 ]]

    then

          file_timestamp_g=$(ls -ltr /$video_f/$1/input/gfx_input/ANIMATION/ | grep -E ".mov|.mxf" | awk '{print $6,$7,$8}' | head -1)
          cur_timestamp=$(date | awk '{print $2,$3,$4}')
          time_diff_g=$(( ($(date -d "${cur_timestamp}" +%s) - $(date -d "${file_timestamp_g}" +%s)) / 60))




           if  [[ $time_diff_g -gt $threshold_value ]]

           then

           echo $count_g






     fi

   else

   echo "0"


fi



fi
else

exit 3



fi
}
for video_f in $video_type
do
category=$(cat /var/mam/zabbix/ch.data | grep -w ${1} | awk '{print $2}')
if [[ $category == cpv1 ]] && [[ $video_f == Video1 ]]
then
func $1 $2
fi

if [[ $category == cpv2 ]] && [[ $video_f == Video ]]
then
func $1 $2
fi
done
