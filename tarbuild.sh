#!/bin/bash
basepath=/var/mam
destpath=/home/mam
date=$(date "+%b_%d_%Y_%H_%m")
read -p "Please Enter source path: " src
if [[ -d $basepath/$src ]] && [[ -d $destpath/ ]] && [[ -n $src ]]
then
   echo "Source is valid directories"
   read -p "Enter tar file name: " tarname
   if [[ -n $tarname ]]
   then
   echo "tar source path: $basepath/$src/ destination path: ${destpath/$dest/} and file name : ${tarname}_$date.tar.gz"
   sleep 10
   rm -rvf $destpath/$dest${tarname}_$date.tar.gz
   tar -cvpzf $destpath/$dest${tarname}_$date.tar.gz $basepath/$src/
   if [[ -f $destpath/$dest${tarname}_$date.tar.gz ]] &> /dev/null
   then
        echo "tar generated!"
	if [[ $? -eq 0 ]]
        then
	tarfile=${tarname}_$date.tar.gz
        tar tvf $destpath/$dest/$tarfile && echo -e "\e[32mtar file successfully generated and verified!\e[0m" || echo -e "\e[31mtar backup verification failed!\e[0m" && exit
        else
        echo "tar error generated!"
        exit
        fi
   else
        echo "tar generated fail!"
   fi
   else
        echo "Enter valid tar name!"
   fi
else
   echo "Source or destination are not valid path!"
fi

