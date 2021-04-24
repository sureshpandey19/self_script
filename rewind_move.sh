#!/bin/sh

#Creating a tmux session without attaching to it

source_path=/VIDEO/rewind/Rewind-Raw-Output
destination_path=/VIDEO/rewind/txmaster
mysqldb_ip=192.168.15.88
mysql_db=mamcdb_pp_rewind
uid=cloud_user
pass=Cloud@123
ext=.mxf
idetails=/tmp/tempmedia.txt
clipid=/tmp/clipid.txt
session=move

(mysql -h $mysqldb_ip -u $uid -p$pass -se "SELECT concat(clipid,ext) FROM $mysql_db.mamdatalist WHERE deviceuid = 'bbf83d9d-f2b7-4cd8-8451-f7dfabd49cea' AND isgrowing = 0 and clipid IN (SELECT house_id status FROM $mysql_db.pp_content_workordermamdata WHERE STATUS = 'approved') AND clipid IN (SELECT clipid FROM $mysql_db.mamdatalist WHERE deviceuid = 'bbf83d9d-f2b7-4cd8-8451-f7dfabd11abc')") > $idetails

tmux kill-session -t $session

tmux new-session -d -s $session

tmux split-window -h -t ${session}:0.0

tmux send-keys -t ${session}:0.0 "cd $source_path" C-m "mv `sed -n 1p $idetails` $destination_path/" C-m 

