#!/bin/bash

adb -d shell su -c "pm list packages -f -s" > listapk.txt

cat listapk.txt | sed -e 's|=| |g' | awk -F" " '/package/ {print $1}' | sed -e 's|package:||g' > list2.txt

for WERS in $(cat list2.txt)
do
	# echo $WERS
	adb -d shell su -c "aapt dump badging ${WERS}" > crs.txt
	pkg=$(cat crs.txt | awk -F" " '/package/ {print $2}' | awk -F"'" '/name=/ {print $2}')
	act=$(cat crs.txt | awk -F" " '/launchable-activity/ {print $2}'| awk -F"'" '/name=/ {print $2}')
	echo $pkg
	adb -d shell su -c "am force-stop ${pkg}"
	adb -d shell su -c "time am start -W ${pkg}/${act}" > HO.txt
	C1=$(cat HO.txt | grep real | awk '{print $1}')
	C2=$(echo $C1 | sed -e 's|0m||g' | sed -e 's|s||g' | awk '{print $1}')
	echo $C2
	# echo $ADB >> ls.txt
done
# adb shell am start -n $pkg/$act
