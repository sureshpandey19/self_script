#!/bin/bash
sourcepath=/home/mam
destpath=/var/mam
date=$(date "+%b_%d_%Y_%H_%m")
read -p "Enter tar file name: " tarname
read -p "Enter destination dir: " mambuild
if [[ -f $sourcepath/$tarname ]] && [[ -n $mambuild ]] && [[ -d $destpath/$mambuild ]]
then
echo "########Directory and tar file verification successful!########"
echo "Taking backup of destination running build"
sleep 5
read -p "Enter build backup name: " build
rm -rvf $sourcepath/${build}_$date.tar.gz
tar cvpzf $sourcepath/${build}_$date.tar.gz $destpath/$mambuild
echo "build backup completed"
sleep 2
if [[ -f $sourcepath/${build}_$date.tar.gz ]] && tar tvf $sourcepath/${build}_$date.tar.gz
then
echo "tar file successfully backup and verified"
sleep 5
if [[ $? -eq 0 ]]
then
read -p "Please proceed for update the build:(y/n)" ans
if [[ $ans == y ]]
then
tar -xvf $sourcepath/$tarname -C /
if [[ $? -eq 0 ]]
then
echo -e "\e[32mBuild updated successfully...\e[0m"
else
echo "Build update failed!"
exit
fi
else [[ $ans == n ]] || echo "you choosen invalid option" || exit
echo "Build update rejected from user"
fi
else
echo "some error generated in backup file verification!"
fi
else
echo "Some Error generated in backup process"
exit
fi
else
echo "You entered invalid tar file name or directory!"
fi
