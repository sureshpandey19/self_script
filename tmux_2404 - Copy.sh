#!/bin/sh

session=mam.services
path=/var/mam/saas
mampid=/home/mam/1.txt
dbuser=cloud_user
dbpasswd=Cloud@123
dbname=mamcdb_rewind
process=/home/mam/2.txt
a=1


echo mamlogpid `ps aux | awk '/logwriter/ && !/awk/ { print $2 }'` > $mampid
echo mamserverpid `ps aux | awk '/mamserver/ && !/awk/ { print $2 }'` > $mampid
echo mamguipid `ps aux | awk '/mamgui/ && !/awk/ { print $2 }'` > $mampid
echo "SELECT p.completestatus as process_status FROM process  p WHERE p.completestatus =1
UNION
SELECT tp.pick_flag as proxy_status FROM transaction_proxy  tp WHERE tp.pick_flag = 1
UNION 
SELECT tv.pick_flag as vod_status FROM transaction_vod tv WHERE tv.pick_flag = 1;" | mysql $dbname -u $dbuser -p$dbpasswd > $process

if [ $a == `cat /home/mam/2.txt | tail -1` ]
then
   echo "mam operation process is running"
else
	 echo "There is no any mam operation process running..."
	tmux kill-session -t $session
	tmux new-session -d -s $session
  	tmux split-window -h -p 30 -t ${session}:0.0
	tmux split-window -h -p 30 -t ${session}:0.0
	tmux split-window -h -p 30 -t ${session}:0.0
	tmux split-window -h -p 30 -t ${session}:0.0
	tmux split-window -h -p 30 -t ${session}:0.0
	tmux split-window -h -p 30 -t ${session}:0.0
	tmux split-window -h -p 30 -t ${session}:0.0
	tmux split-window -h -p 30 -t ${session}:0.0
	tmux split-window -h -p 30 -t ${session}:0.0
	tmux select-layout tiled
	tmux send-keys -t ${session}:0.0 "cd $path/mam.log/" C-m "./logwriter"  C-m
	echo mamlogpid `ps aux | awk '/logwriter/ && !/awk/ { print $2 }'` > $mampid
	tmux send-keys -t ${session}:0.1 "cd $path/mam.db/" C-m "./dbservices"  C-m
	echo mamdbservicepid `ps aux | awk '/dbservice/ && !/awk/ { print $2 }'` >> $mampid
	tmux send-keys -t ${session}:0.2 "cd $path/mam.server/" C-m "./mamserver"  C-m
	echo mamserverpid `ps aux | awk '/mamserver/ && !/awk/ { print $2 }'` >> $mampid
	tmux send-keys -t ${session}:0.3 "cd $path/mam.gui/" C-m "./mamgui"  C-m
	echo mamguipid `ps aux | awk '/mamgui/ && !/awk/ { print $2 }'` >> $mampid
	tmux send-keys -t ${session}:0.4 "cd $path/mam.opr/" C-m "./mamoperation"  C-m
	echo mamoprpid `ps aux | awk '/mamoperation/ && !/awk/ { print $2 }'` >> $mampid

fi
