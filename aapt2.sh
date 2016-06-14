#!/bin/bash

#adb -d shell su -c "pm list packages -f -3" > listapk.txt

#cat listapk.txt | sed -e 's|=| |g' | awk -F" " '/package/ {print $1}' | sed -e 's|package:||g' > list2.txt

for WERS in $(cat list2.txt)
do
	sleep 1
	# echo $WERS
	adb -d shell su -c "aapt dump badging ${WERS}" > crs.txt
	pkg=$(cat crs.txt | awk -F" " '/package/ {print $2}' | awk -F"'" '/name=/ {print $2}')
	act=$(cat crs.txt | awk -F" " '/launchable-activity/ {print $2}'| awk -F"'" '/name=/ {print $2}')
	case "$pkg" in
		"com.android.chrome")
							adb -d shell su -c "am force-stop ${pkg}"
							adb -d shell su -c "time am start -W com.android.chrome/com.google.android.apps.chrome.Main" > HO.txt
							;;
		"com.google.android.youtube")
							adb -d shell su -c "am force-stop ${pkg}"
							adb -d shell su -c "time am start -W com.google.android.youtube/com.google.android.apps.youtube.app.WatchWhileActivity" > HO.txt
							;;
							*)
							adb -d shell su -c "am force-stop ${pkg}"
							adb -d shell su -c "time am start -W ${pkg}/${act}" > HO.txt
							;;
	esac
	C1=$(cat HO.txt | grep real | awk '{print $1}')
	C2=$(echo $C1 | sed -e 's|0m||g' | sed -e 's|s||g' | awk '{print $1}')
	echo "$pkg : $C2 sek."
	echo "${pkg} ${C2}" > Tym.txt
	awk '{printf "|%-40s| %-5s|\n",$1,$2}' Tym.txt >> Wynik.txt
	sleep 1
	# adb -d shell su -c "am force-stop ${pkg}"
	sleep 1
	# echo $ADB >> ls.txt
done
# adb shell am start -n $pkg/$act

Io=1
Ik=5
while (($Io<=$Ik)); do
		for WERS in $(cat list2.txt)
		do
			sleep 1
			# echo $WERS
			adb -d shell su -c "aapt dump badging ${WERS}" > crs.txt
			pkg=$(cat crs.txt | awk -F" " '/package/ {print $2}' | awk -F"'" '/name=/ {print $2}')
			act=$(cat crs.txt | awk -F" " '/launchable-activity/ {print $2}'| awk -F"'" '/name=/ {print $2}')

			case "$pkg" in
			"com.android.chrome")
							adb -d shell su -c "am force-stop ${pkg}"
							adb -d shell su -c "time am start -W com.android.chrome/com.google.android.apps.chrome.Main" > HO.txt
							;;
			"com.google.android.youtube")
							adb -d shell su -c "am force-stop ${pkg}"
							adb -d shell su -c "time am start -W com.google.android.youtube/com.google.android.apps.youtube.app.WatchWhileActivity" > HO.txt
							;;
							*)
							adb -d shell su -c "am force-stop ${pkg}"
							adb -d shell su -c "time am start -W ${pkg}/${act}" > HO.txt
							;;
			esac

			C1=$(cat HO.txt | grep real | awk '{print $1}')
			C2=$(echo $C1 | sed -e 's|0m||g' | sed -e 's|s||g' | awk '{print $1}')
			echo "$pkg : $C2 sek."
			#sed -i "s/$pkg/$C2 |/g" Wynik.txt
			sed -i "/$pkg/ s/$/ $C2 |/" Wynik.txt
			# echo "${pkg} ${C2}" > Tym.txt
			# awk '{printf "|%-40s|%-10s|\n",$1,$2}' Tym.txt >> Wynik.txt
			sleep 1
			# adb -d shell su -c "am force-stop ${pkg}"
			sleep 1
			# echo $ADB >> ls.txt
		done
	Io=$(($Io + 1))
done

	FILE=Wynik.txt
while read line; do
     
     pak=$(echo $line | sed -e 's/|//g' | awk '{print $1}')
     echo $pak
     echo $line | awk '{ print $3, $5, $7, $9, $11, $13}' | awk '{ for(i=1; i<=NF;i++) j+=$i; print j; j=0 }' > suma.txt
     sums=$(cat suma.txt)
     echo $sums
     Pkoniec=6
     T4=$(echo "scale = 2; ${sums} / ${Pkoniec}" | bc | awk '{printf "%.2f \n", $1}')
     sed -i "/$pak/ s/$/ Średnio : $T4 /" Wynik.txt
done < $FILE

     T18=$(cat Wynik.txt | awk '{ sum += $17 } END { print sum }')
     T20=$(cat Wynik.txt | wc -l)
     T35=$(echo "scale = 2; ${T18} / ${T20}" | bc | awk '{printf "%.2f \n", $1}')
     echo "-----------------------------------------------------------------------------------------------------" >> Wynik.txt
     echo "                                                                       Średnia całkowita    |  $T35" >> Wynik.txt
     echo "-----------------------------------------------------------------------------------------------------" >> Wynik.txt
#cat Wynik1.txt | grep "com.android.stk" | awk '{ print $3, $5, $7, $9, $11}' | awk '{ for(i=1; i<=NF;i++) j+=$i; print j; j=0 }'
