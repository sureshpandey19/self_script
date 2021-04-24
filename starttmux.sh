#!/bin/bash

session=mam.services
path=/var/mam/mam.filamchi
x=$(tmux ls | awk '{ print $1 }' | tr -d :)
services=
Hpanesize=
Vpanesize=


tmux ls | grep $session
if [ $? -eq 0 ]
then
   echo -e "\e[33mTmux Already running\e[0m"
   echo -e "\e[33mTmux Running Services Name is :\e[0m \n\e[42m$x\e[0m"
else
	 echo -e "\e[31mTmux Not Found Running...\e[0m"
	echo -e "\e[32mStarting MAM Process\e[0m"
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
	tmux send-keys -t ${session}:0.1 "cd $path/mam.db/" C-m "./dbservice"  C-m
	tmux send-keys -t ${session}:0.2 "cd $path/mam.server/" C-m "./mamserver"  C-m
	tmux send-keys -t ${session}:0.3 "cd $path/mam.ui/" C-m "./mamgui"  C-m
	tmux send-keys -t ${session}:0.4 "cd $path/proxy_agent/" C-m "./proxy_agent | y"  C-m
	tmux send-keys -t ${session}:0.5 "cd $path/mam.logviewer/" C-m "./CloudX"  C-m
	tmux send-keys -t ${session}:0.6 "cd $path/event_controller/" C-m "./event_controller"  C-m
	tmux send-keys -t ${session}:0.7 "cd $path/xmlcreator/" C-m "./xmlcreator"  C-m

fi


