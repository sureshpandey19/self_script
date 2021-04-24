#!/bin/bash

session=mam.services
path=/var/mam/mam.services
dbuser=db_user
dbpasswd=Dba@1661
dbname=mamcdb_pp
dbip=192.168.166.1
tmuxname=$(tmux ls | grep $session | awk '{ print $1 }' | tr -d :)
x=1
x1=0

	
	tmux ls | grep $session
	if [ $? -ne 0 ]
	then
	echo -e "\e[33mTmux MAM Service Found Already Stopped\e[0m"
	else [ $? -eq 0 ]
	echo -e "\e[33mTmux Running Found\e[0m"
        echo -e "\e[33mTmux Running Services Name is :\e[0m \n\e[42m$tmuxname\e[0m"
	which mysql &> /dev/null
	if [ $? -eq 0 ]
	then
	i=$(mysql -h $dbip $dbname -u $dbuser -p$dbpasswd 2>/dev/null -se "SELECT 0,p.completestatus as process_status FROM process  p WHERE p.completestatus =1 UNION SELECT 0,tp.pick_flag as proxy_status FROM transaction_proxy tp WHERE tp.pick_flag = 1 UNION SELECT 0,tv.pick_flag as vod_status FROM transaction_vod tv WHERE tv.pick_flag = 1 UNION SELECT 0,p.completestatus FROM process p "| awk 'NR == 1 {print $2}' )
		if [ "$i" -eq "$x1" ]
		then
		echo -e "\e[94mNo any MAM Operation is running\e[0m"
		echo -e "\e[94mStopping MAM Services\e[0m"
		tmux kill-session -t $session
		echo -e "\e[94mMAM Services Stopped!\e[0m"
			else [ "$i" -ne "$x" ]
			echo -e "\e[31mMAM Operation Running Found!\e[0m"
			echo -e "\e[94mAsking for Stop\e[0m" 
			read -p "Press any key to Continue (y/n): " ans
				if [ "$ans" == "y" ]
				then
				echo -e "\e[31mStopping..\e[0m"
				tmux kill-session -t $session
				else
				echo -e "\e[94mNothing To do!\e[0m"
		fi
          fi	
	else
                echo -e "unable to connect with mam running process\nDue to mysql service not found!"
                read -p "Are you sure want to stop without checking mam running process??(y/n): " ans
                  if [ "$ans" == "y" ]
                  then
                  echo -e "\e[31mStopping..\e[0m"
                  tmux kill-session -t $session
                sleep 2
                echo "MAM all process forcfully stopped!"
              fi
       fi
fi

