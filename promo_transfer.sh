#!/bin/bash
#script for promo transfer
source_path=/video
dest_path=/txmaster
log_path=/var/log/mam
log=promo_transfer_$(date "+%d%m").log
ids=$(ls -ltr $source_path/ | awk -F " " 'NR != 1  {print $9}' | grep -iE ".mxf|.mov" | grep -E "HMOV-PR|RWD-PR")

if [[ -n $ids ]]
then
  for i in $ids
    do
      isize1=$(ls -ltr $source_path/$i | awk '{ print $5 }')
      sleep 5
      isize2=$(ls -ltr $source_path/$i | awk '{ print $5 }')
        if [[ $isize2 -eq $isize1 ]]
        then
          mv $source_path/$i $dest_path/
           if [[ $? -eq 0 ]]
           then
             echo "$i at $(date +%T) from $source_path to $dest_path successfully Moved" | tee -a $log_path/$log 
	   fi	
        else
          echo "$i size mismatch found This could be Growing case!" | tee -a $log_path/$log
        fi
   
done
fi
