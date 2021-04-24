#!/bin/bash

RS_OPTION=" -rptgoxXh \
	--progress \
	--inplace \
	--append-verify \
	--size-only \
	--partial \
	--bwlimit=20000 \
	--log-file=/var/log/rsync.log"
SOURCE=/video/watch/done/
DEST=/video/epic/watch/done/
#DEST_IP=192.168.166.3
PROG=$(which rsync)

while true
do

	$PROG $RS_OPTION -e 'ssh -p 1022 'mam@192.168.166.3 --exclude '/*/' $SOURCE $DEST_IP:$DEST

done
