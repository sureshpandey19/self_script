#!/bin/bash
LOCATION[1]="/tx_hits"
LOCATION[2]="/tx_hits_movies"
DESTINATION="/video/proxy/thmub"
CHECKLOCATION="/video/proxy/thumb"
DONELOCATION="${LOCATION[$COUNTER]}/video/"
MOVE="0"
TIMESTAMP_FILENAME="TIMESTAMP_Do_Not_Delete.txt"
KEYFRAME_FLAG="0"
TOTAL_NO_OF_LOCATIONS=2;
INVENTORY_NAME="FILES_LIST.txt"
LOG_LOCATION="/var/log/m.c"						
READ_PASTDATA="0";						#if Disable value is 0;
READ_PASTDATA_DURATION="1 days ago";


if [ ! -f $LOG_LOCATION/$TIMESTAMP_FILENAME ]; then
touch $LOG_LOCATION/$TIMESTAMP_FILENAME;
fi

if [ "$READ_PASTDATA" -ne "0"  ]; then
touch -d "$READ_PASTDATA_DURATION" $LOG_LOCATION/$TIMESTAMP_FILENAME;
fi

while true
do
	
		for COUNTER in $(seq 1 1 $TOTAL_NO_OF_LOCATIONS)
		do

		echo "Reading Location $COUNTER";
	TOTALFILES=`find ${LOCATION[$COUNTER]} -type f -cnewer $LOG_LOCATION/$TIMESTAMP_FILENAME | egrep -i '.mov$|.mp4$'`
     echo "$TOTALFILES" > $LOG_LOCATION/"$INVENTORY_NAME"; 
     echo "`date '+%D %T'` Base Timestamp is ` ls -l $LOG_LOCATION/$TIMESTAMP_FILENAME | awk '{print $8, $7, $6}'`";
    

if [ "$TOTALFILES" == "" ]; then
	echo "File not found!"
	sleep 5;
	continue;
else
	echo "------Files Found-----"
	cat $LOG_LOCATION/"$INVENTORY_NAME";
	 echo "`date '+%D %T'` Base TimeStamp is ` ls -l $LOG_LOCATION/$TIMESTAMP_FILENAME | awk '{print $8, $7, $6}'`"  | tee -a $LOG_LOCATION/ProxyCreationLogs.txt;
	touch $LOG_LOCATION/$TIMESTAMP_FILENAME;
       echo "`date '+%D %T'` Now Base Timestamp is ` ls -l $LOG_LOCATION/$TIMESTAMP_FILENAME | awk '{print $8, $7, $6}'`" | tee -a $LOG_LOCATION/ProxyCreationLogs.txt;
	while [ `cat $LOG_LOCATION/"$INVENTORY_NAME" | wc -l` -ne 0 ]
	do
	FILE=`cat $LOG_LOCATION/"$INVENTORY_NAME" | awk 'FNR == 1 {print}'`;
		 echo "`date '+%D %T'` File picked for proxy creation is > "$FILE"" | tee -a $LOG_LOCATION/ProxyCreationLogs.txt;
		sleep 2;
		sed -i "\|$FILE|d" $LOG_LOCATION/"$INVENTORY_NAME";
           PROXYFILE=`basename "$FILE" | cut -d. -f1`
		   PROXYFILENAME="$PROXYFILE".jpg
					
							if [ ! -f "$DESTINATION/$PROXYFILENAME" ] && [ ! -f "$CHECKLOCATION/$PROXYFILENAME" ]; then
								echo "`date '+%D %T'` Creating Thumbnail of "$FILE"" | tee -a $LOG_LOCATION/ProxyCreationLogs.txt 
								sleep 2 
								/usr/local/bin/ffmpeg -n -i "$FILE" -ss 00:01:01.000 -vframes 1 $DESTINATION/"$PROXYFILENAME"
								
															if [ $? == 0  ]; then
                                                        	 echo "`date '+%D %T'` "$FILE" -->Thumbnail Has been created" | tee -a $LOG_LOCATION/ProxyCreationLogs.txt
															else
                                                         	 echo "`date '+%D %T'` Thumbnail creation failed, Starting Deletion of $DESTINATION/"$PROXYFILENAME" " | tee -a $LOG_LOCATION/ProxyCreationLogs.txt
                                                                 rm -f $DESTINATION/"$PROXYFILENAME";
                                                        	 fi

											                      								
							else 
								 echo "`date '+%D %T'` Creating Thumbnail for "$FILE"" | tee -a $LOG_LOCATION/ProxyCreationLogs.txt;	
								echo "`date '+%D %T'` "$PROXYFILENAME" is not a file OR Already available at $DESTINATION" | tee -a $LOG_LOCATION/ProxyCreationLogs.txt
									
								sleep 1;
							fi	
							
							
							if [ $KEYFRAME_FLAG == "1" ]; then
							
                                            PROXYFILENAME="$PROXYFILE"'_key.jpg';
											if [ ! -f "$DESTINATION/$PROXYFILENAME" ] && [ ! -f "$CHECKLOCATION/$PROXYFILENAME" ]; then
                                                                echo "Creating Keyframe of "$FILE"" | tee -a $LOG_LOCATION/ProxyCreationLogs.txt

                                                                No_Of_Frame=`/usr/local/bin/ffmpeg -nostats -i "$FILE" -vcodec copy -f rawvideo -y /dev/null 2>&1`
                                                                No_Of_Frame=`echo "$No_Of_Frame" | grep frame | awk '{split($0,a,"fps")}END{print a[1]}' | sed 's/.*= *//'`

                                                                FRAME_COUNT=`echo "$No_Of_Frame / 100 " | bc`
                                                                /usr/local/bin/ffmpeg -loglevel panic -y -i "$FILE"  -frames 1 -q:v 1 -vf "select=not(mod(n\,$FRAME_COUNT)),scale=213:120,tile=100x1" $DESTINATION/"$PROXYFILENAME"
																if [ $? == 0  ]; then
                                                        	 echo "`date '+%D %T'` "$FILE" -->Keyframe has Been created." | tee -a $LOG_LOCATION/ProxyCreationLogs.txt
															else
                                                         	 echo "`date '+%D %T'` Keyframe creation failed, Starting Deletion of $DESTINATION/"$PROXYFILENAME" " | tee -a $LOG_LOCATION/ProxyCreationLogs.txt
                                                                 rm -f $DESTINATION/"$PROXYFILENAME";
                                                        	 fi
											else 
																	
																echo "`date '+%D %T'` "$PROXYFILENAME" is not a file OR Already available at $DESTINATION" | tee -a $LOG_LOCATION/ProxyCreationLogs.txt				 
                                                                               
															   sleep 1;
											fi
						    fi

							if [ $MOVE == "1" ]; then
									mv -f "$FILE"  $DONELOCATION/
									echo "`date '+%D %T'` "$FILE" has been moved to done!" | tee -a $LOG_LOCATION/ProxyCreationLogs.txt   
							fi
							
							
				echo "_________________________________________________________________________________________________" | tee -a $LOG_LOCATION/ProxyCreationLogs.txt;
	done



fi
done
done
