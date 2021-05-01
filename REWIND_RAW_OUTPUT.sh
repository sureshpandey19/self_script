#!/bin/bash
arrbase[0]=/mnt/d/DOWNLOAD
arrext[0]=mxf
deviceUID[0]=120

D_HOST_M="192.168.15.251"
D_USER="db_user"
D_PASS="Dbuser@123"
D_BASE="mamcdb_rewind"
D_OPT=" -N --disable-pager --raw --silent"
D_CMD_1="mysql -h $D_HOST_M -u $D_USER -p$D_PASS -D $D_BASE"

#while true
#do
j=0
for i in ${arrext[@]}
do
	echo "Search For New File with ext " $i
	sleep 2
	base=${arrbase[$j]}
	cd $base
	file=`ls | wc -l`
	if [ $file == 0 ]; then	
		echo "*********No file exist in $i ext. and $base **********"
	else
		total=`ls $base | grep $i` 
		for file_name in $total
		do
			size1=`du -sh $file_name | awk '{print $1}'`
			time1=`date +%s -r $file_name`
			sleep 5
			size2=`du -sh $file_name | awk '{print $1}'`
			time2=`date +%s -r $file_name`
			if [ $size1 == $size2 ] && [ $time1 == $time2 ]; then
			    echo $file_name
				flname=$(echo "$file_name" | cut -f 1 -d '.')
				ext="."$(echo "$file_name" | cut -f 2 -d '.')
				echo $ext
				TIMECODE=`ffmpeg -i $file_name 2>&1 | grep -i Timecode | cut -d : -f 2-5`
				TIMECODE1=`echo $TIMECODE | cut -c1-11`
				echo $TIMECODE1
				DURATION=`ffmpeg -i $file_name 2>&1 | grep Duration | cut -d ' ' -f 4 | sed s/,//`
				echo $DURATION
              
				J_REC=`echo "$D_CMD_1 $D_OPT -e \"select clipid	from mamdatalist where clipid='$flname' and deviceuid='120' limit 1 \"" | sh | sed 's/[\t]/,/g'`
				echo $J_REC
				if [[ $J_REC == "" ]]
				then
					echo "$D_CMD_1 -e \" insert into mamdatalist (uid,clipid,ext,deviceuid,createdby,updatedby,som,duration,isActive) values(uuid(),'$flname','$ext','${deviceUID[$j]}','1','1','$TIMECODE1','$DURATION','0')\" "|sh
					echo "Entry Update into database.."
					dt=$(date +"%m-%d-%Y "%I:%M:%S"")
					echo $dt" :" $file_name" Update into Database     " >> transfer_log-$(date +%Y-%m-%d).log
				else
				    echo "Entry Already found in database.."
					dt=$(date +"%m-%d-%Y "%I:%M:%S"")
					echo $dt" :"$file_name" Entry Already found in Database     " >> transfer_log-$(date +%Y-%m-%d).log
				fi
          	fi
		done
	fi	
	j=`expr $j + 1`
done
#done 