#!/bin/bash

arrbase[0]=/video/incoming/amc/input/amc_input_subtitle
arrbase[1]=/video/incoming/amc/input/amc_input_subtitle

arrext[0]=mxf
arrext[1]=mov

arrtype[0]=ftp
arrtype[1]=ftp

arrdest[0]=192.168.41.5,amc,amc,/amc_input/amc_input_subtitle
arrdest[1]=192.168.41.5,amc,amc,/amc_input/amc_input_subtitle

while true
do
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
				    
			       
     			    if [ ${arrtype[$j]} == "move" ]
					then
					   # mv -f $base/$file_name $arrdest[i]
					   mv -f $base/$file_name  ${arrdest[$j]}
					   #echo "file move ${arrdest[$j]"
					   sleep 1
	                fi
					if [ ${arrtype[$j]} == "ftp" ]		
					then
							ftpip="$(cut -d, -f1 <<< ${arrdest[$j]})"
							echo $ftpip
							ftpusr="$(cut -d, -f2 <<<${arrdest[$j]})"
							echo $ftpusr 
							ftppass="$(cut -d, -f3 <<<${arrdest[$j]})"
							echo $ftpusr 
							ftpdir="$(cut -d, -f4 <<<${arrdest[$j]})"
							echo $ftpusr 							
							if [ "`ncftpls -l -u $ftpusr -p $ftppass  ftp://$ftpip$ftpdir/$file_name`" ]
							then
								    echo "File already exist.........."
									mv -f $base/$file_name "$base/pending"
									echo "file move to pending folder"
                            else  							
								echo "-T $base/$file_name ftp://$ftpusr:$ftppass@$ftpip$ftpdir/$file_name "                                         
								curl -T $base/$file_name --limit-rate 50M ftp://$ftpusr:$ftppass@$ftpip$ftpdir/$file_name
								if [ $? == 0 ]; then
									mv -f $base/$file_name "$base/done"
									echo "file move to done folder"
								else
									mv -f $base/$file_name "$base/pending"
									echo "file move to pending folder"
								fi
							fi	
						
					fi
          	    fi
		done
	fi	
	j=`expr $j + 1`
done
done 