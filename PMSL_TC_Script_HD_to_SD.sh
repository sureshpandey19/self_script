#!/bin/bash

#Declare variables

FILE_READ_LOCATION="/incoming"
TEMP_LOCATION="/incoming/temp"
DESTINATION="/incoming/hd"
PENDING_LOCATION="/incoming/pending"
DONE_LOCATION="/incoming/done"
FFMPEG_LOCATION="/usr/bin/"


#Do not Modify

START_TC=0;
IS_EXIST=1;
IS_GROWING=1;
HD_FLAG=1;
MOVE=0;
FPROBE="";
SD_TO_HD=1;
RESOLUTION="1920x1080"






while true;
do

    TOTALFILES=`ls $FILE_READ_LOCATION | egrep '.mov$|.mxf$'`;
		

if [ "$TOTALFILES" == "" ]; then
	echo "No file found for TC"
	sleep 5;
	else
			for FILE in $TOTALFILES
			do
		IS_EXIST=1;
		IS_GROWING=1;
		START_TC=0;
		MOVE=0;	
		START_MERGING=0;
		
			echo $TOTALFILES;

				echo "File Picked for Transcoding: $FILE"

				TC_FILE=`basename $FILE | cut -d. -f1`;
	   			TC_FILE_NAME=$TC_FILE.mxf;

				
                                        SIZE1=`du -sh  $FILE_READ_LOCATION/$FILE | awk '{print $1}'`
                                        TIME1=`date +%s -r  $FILE_READ_LOCATION/$FILE`
                                        sleep 7;
                                        SIZE2=`du -sh  $FILE_READ_LOCATION/$FILE | awk '{print $1}'`
                                        TIME2=`date +%s -r  $FILE_READ_LOCATION/$FILE`
                                                if [ $SIZE1 == $SIZE2 ] && [ $TIME1 == $TIME2 ]; then
                                                IS_GROWING=0;
						 echo "File Picked for Transcoding: $FILE" | tee -a ./TC_log.txt;
                                                echo "$FILE is not growing" | tee -a ./TC_log.txt;
                                                else
                                                echo "$FILE is growing";
                                                continue;
                                                fi
                                

				 if [ $IS_GROWING == 0 ];then
				if [ ! -f "$DESTINATION/$TC_FILE_NAME" ]; then
				IS_EXIST=0;
				echo "`date '+%D %T'` $TC_FILE_NAME (HD) does not exist at destination" | tee -a ./TC_log.txt;
				else 
				echo "`date '+%D %T'` File already exist at destination" | tee -a ./TC_log.txt;
				fi
				fi

					sleep 1;

				if [ $IS_EXIST == 0 ];then
					
					FPROBE=`$FFMPEG_LOCATION/ffprobe $FILE_READ_LOCATION/$FILE 2>&1`;
					CHECK_RESOLUTION=`echo $FPROBE | grep -o $RESOLUTION | wc -l`;
				
						if [ $CHECK_RESOLUTION -gt 0  ]; then			
						echo "`date '+%D %T'` Transcoding Not Required, Moving to HD!!!" | tee -a ./TC_log.txt ;
						 mv $FILE_READ_LOCATION/$FILE $DESTINATION;
						MOVE=2;
						else
						START_TC=1;
						fi


				fi


				if [ "$START_TC" == 1  ]; then
				
				STREAM_COUNT=`echo $FPROBE | grep -o 'Stream #' | wc -l`
				echo "`date '+%D %T'`Starting Transcoding SD to HD" | tee -a ./TC_log.txt;

				sleep 2;
				#HD to Sd Transcoding	
					
				   if [ "$SD_TO_HD" == 1 ];then
		$FFMPEG_LOCATION/ffmpeg -y -i $FILE_READ_LOCATION/$FILE -map 0:0  -vcodec mpeg2video -b:v 50000k -bufsize 50000k -minrate 50000k -maxrate 50000k $TEMP_LOCATION/"$TC_FILE"0.m2v;

					 if [ $? == 0 ]; then
					 START_MERGING=1;	
					echo "Video Transcoding Done, Moving To audio Transcoding!!!"
                        		else                
			                MOVE=0;
					echo "`date '+%D %T'` Transcoding Failed!!!" | tee -a ./TC_log.txt
					fi

					MERGE[0]="-i "$TEMP_LOCATION"/"$TC_FILE"0.m2v ";	
					MAPPING[0]='-map 0:0 '
					AUDIO=0;
					
					for (( COUNTER=1; COUNTER < $STREAM_COUNT; COUNTER++ ))
					do
			$FFMPEG_LOCATION/ffmpeg -y -i $FILE_READ_LOCATION/$FILE  -map 0:1.$AUDIO -ac 1  -b:a 15000k $TEMP_LOCATION/"$TC_FILE""$COUNTER".wav;
                                        
						let "AUDIO+=1";
						MERGE[$COUNTER]="-i "$TEMP_LOCATION"/"$TC_FILE""$COUNTER".wav ";
						MAPPING[$COUNTER]="-map "$COUNTER":0 "
					done 

					for i in $(seq 0 1 $STREAM_COUNT)
					do
					INPUT_MERGE+=${MERGE[$i]}
					INPUT_MAPPING+=${MAPPING[$i]}
					done

					TIMECODE=`echo "$FPROBE" | grep "timecode" | head -n1 | cut -d: -f2-5`
									
						if [ "$TIMECODE" == "" ]; then
									
					        	TIMECODE="00:00:00:00"
									
						fi
					
				    HDPARAMETER1='-vcodec mpeg2video -acodec pcm_s24le -b:v 50000k -bufsize 50000k -minrate 50000k -maxrate 50000k -b:a 15000k ';
	HDPARAMETER2='-s 1920:1080 -aspect 16:9 -filter:v colormatrix=bt601:bt709,crop=720:568:0:30,scale=1440:1080,pad=1920:1080:240:0:0x000000,setdar=16/9 ';

               			
				   fi
				fi
				
					if [ "$START_MERGING" == 1 ];then

			echo "`date '+%D %T'` Starting Video Merge!!!" | tee >> ./TC_log.txt
			sleep 2;
		$FFMPEG_LOCATION/ffmpeg -y $INPUT_MERGE $HDPARAMETER1 -timecode $TIMECODE  $INPUT_MAPPING $HDPARAMETER2 $DESTINATION/$TC_FILE_NAME;
					      		
							if [ $? == 0 ]; then
							MOVE=1;	
							echo "`date '+%D %T'` Merging Succesfull!!!" | tee -a ./TC_log.txt
							rm -f $TEMP_LOCATION/*;
							else
							echo "`date '+%D %T'` Merging Failed!!! " | tee -a ./TC_log.txt
							MOVE=0;	
							rm -f $DESTINATION/$TC_FILE_NAME;
							rm -f $TEMP_LOCATION/*;
							fi
					fi


					
				if [ $MOVE == 1 ]; then
 				mv $FILE_READ_LOCATION/$FILE $DONE_LOCATION;
				echo "`date '+%D %T'` File moved to Done location!!!!" | tee -a ./TC_log.txt
				fi
				if [ $MOVE == 0 ]; then
                                mv $FILE_READ_LOCATION/$FILE $PENDING_LOCATION;
				echo "`date '+%D %T'` File Moved to Pending!!!" | tee -a ./TC_log.txt
                                fi


	echo "_______________________________________________________________________"| tee -a ./TC_log.txt;
done
fi
done				
