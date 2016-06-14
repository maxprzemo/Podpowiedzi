#!/bin/bash

# Opera
#com.opera.browser/com.opera.Opera
#adb -d shell su -c "time am start -W com.opera.browser/com.opera.Opera"
#/data/app/com.opera.browser-1/base.apk

# Firefox
#org.mozilla.firefox/.App
#adb -d shell su -c "time am start -W org.mozilla.firefox/.App"
#/data/app/org.mozilla.firefox-1/base.apk

# Chrome
#com.android.chrome
#adb -d shell su -c "time am start -W com.android.chrome/com.google.android.apps.chrome.Main"
#/data/app/com.android.chrome-2/base.apk


# Pobranie czasu
Czas1=$(date +%s)

if [ -f Wynik.txt ];
then
	rm -f Wynik.txt
fi

touch Wynik.txt

browsers=( "/data/app/com.android.chrome-2/base.apk" "/data/app/com.opera.browser-1/base.apk" "/data/app/org.mozilla.firefox-1/base.apk" )

for WERS in "${browsers[@]}"
do
	sleep 1
	# echo $WERS
	adb -d shell su -c "aapt dump badging ${WERS}" > crs.txt
	pkg=$(cat crs.txt | awk -F" " '/package/ {print $2}' | awk -F"'" '/name=/ {print $2}')
	act=$(cat crs.txt | awk -F" " '/launchable-activity/ {print $2}'| awk -F"'" '/name=/ {print $2}')
	apkname=$(cat crs.txt | awk -F"'" '/application-label:/ {print $2}' | sed -e 's| |_|g')
	case "$pkg" in
		"com.android.chrome")
							adb -d shell su -c "am force-stop ${pkg}"
							adb -d shell su -c "time am start -W com.android.chrome/com.google.android.apps.chrome.Main" > HO.txt
							;;
		"com.opera.browser")
							adb -d shell su -c "am force-stop ${pkg}"
							adb -d shell su -c "time am start -W com.opera.browser/com.opera.Opera" > HO.txt
							;;
		"org.mozilla.firefox")
							adb -d shell su -c "am force-stop ${pkg}"
							adb -d shell su -c "time am start -W org.mozilla.firefox/.App" > HO.txt
							;;
		*)
							adb -d shell su -c "am force-stop ${pkg}"
							adb -d shell su -c "time am start -W ${pkg}/${act}" > HO.txt
							;;
	esac
	adb -d shell su -c "cat /sys/class/thermal/thermal_zone1/temp" > thermal_zone1.txt
	C1=$(cat HO.txt | grep real | awk '{print $1}')
	C2=$(echo $C1 | sed -e 's|0m||g' | sed -e 's|s||g' | awk '{print $1}')
	# echo "$pkg [$apkname] : $C2 sek."
	echo "${pkg} ${C2}" > Tym.txt
	apkfor=$(echo " [$apkname]")
	awk -v var="$apkfor" '{printf "| %-65s| %-5s|\n",$1 var,$2}' Tym.txt >> Wynik.txt
	awk -v var="$apkfor" '{printf "| %-65s| %-5s|\n",$1 var,$2}' Tym.txt > Tym2.txt
	echo "$(cat Tym2.txt) Temp CPU to : $(cat thermal_zone1.txt | awk '{printf "%.2f ", $1}') st.C "
	sleep 1
	# adb -d shell su -c "am force-stop ${pkg}"
	# sleep 1
	# echo $ADB >> ls.txt
done


Io=1
Ik=9
while (($Io<=$Ik)); do
		for WERS in "${browsers[@]}"
		do
			sleep 1
			# echo $WERS
			adb -d shell su -c "aapt dump badging ${WERS}" > crs.txt
			pkg=$(cat crs.txt | awk -F" " '/package/ {print $2}' | awk -F"'" '/name=/ {print $2}')
			act=$(cat crs.txt | awk -F" " '/launchable-activity/ {print $2}'| awk -F"'" '/name=/ {print $2}')
			apkname=$(cat crs.txt | awk -F"'" '/application-label:/ {print $2}' | sed -e 's| |_|g')
			case "$pkg" in
			"com.android.chrome")
							adb -d shell su -c "am force-stop ${pkg}"
							adb -d shell su -c "time am start -W com.android.chrome/com.google.android.apps.chrome.Main" > HO.txt
							;;
			"com.opera.browser")
							adb -d shell su -c "am force-stop ${pkg}"
							adb -d shell su -c "time am start -W com.opera.browser/com.opera.Opera" > HO.txt
							;;
			"org.mozilla.firefox")
							adb -d shell su -c "am force-stop ${pkg}"
							adb -d shell su -c "time am start -W org.mozilla.firefox/.App" > HO.txt
							;;
							*)
							adb -d shell su -c "am force-stop ${pkg}"
							adb -d shell su -c "time am start -W ${pkg}/${act}" > HO.txt
							;;
			esac
			adb -d shell su -c "cat /sys/class/thermal/thermal_zone1/temp" > thermal_zone1.txt
			C1=$(cat HO.txt | grep real | awk '{print $1}')
			C2=$(echo $C1 | sed -e 's|0m||g' | sed -e 's|s||g' | awk '{print $1}')
			
			######################################
			# Dane do pliku Wynik.txt
			sed -i "/$pkg / s/$/ $C2 |/" Wynik.txt
			
			######################################
			# Dane na ekranie
			echo "${pkg} ${C2}" > Tym.txt
			apkfor=$(echo " [$apkname]")
			awk -v var="$apkfor" '{printf "| %-65s| %-5s|\n",$1 var,$2}' Tym.txt > Tym2.txt
			echo "$(cat Tym2.txt) Temp CPU to : $(cat thermal_zone1.txt | awk '{printf "%.2f ", $1}') st.C "
			sleep 1
			# adb -d shell su -c "am force-stop ${pkg}"
			# sleep 1
			# echo $ADB >> ls.txt
		done
	Io=$(($Io + 1))
done

	FILE=Wynik.txt
while read line; do
     
     pak=$(echo $line | sed -e 's/|//g' | awk '{print $1}')
     echo $pak
     echo $line | awk '{ print $5, $7, $9, $11, $13, $15, $17, $19, $21, $23}' | awk '{ for(i=1; i<=NF;i++) j+=$i; print j; j=0 }' > suma.txt
     sums=$(cat suma.txt)
     echo $sums
     Pkoniec=10
     T4=$(echo "scale = 2; ${sums} / ${Pkoniec}" | bc | awk '{printf "%.2f \n", $1}')
     sed -i "/$pak / s/$/ Średnio : $T4 /" Wynik.txt
done < $FILE

     T18=$(cat Wynik.txt | awk '{ sum += $19 } END { print sum }')
     T20=$(cat Wynik.txt | wc -l)
     T35=$(echo "scale = 2; ${T18} / ${T20}" | bc | awk '{printf "%.2f \n", $1}')
     echo "--------------------------------------------------------------------------------------------------------------------------------" >> Wynik.txt
     echo "                                                                                                  Średnia całkowita    | $T35   " >> Wynik.txt
     echo "--------------------------------------------------------------------------------------------------------------------------------" >> Wynik.txt
 

# Obiczenie ile czasu zajeło przeprowaczenie testów.
Czas2=$(date +%s)
Sek=$((Czas2 - Czas1))
T76=$((Sek / 60))
T78=$((Sek % 60))

     echo "                                                                                            Czas pomiaru to $T76 min $T78 sek   " >> Wynik.txt
     echo "--------------------------------------------------------------------------------------------------------------------------------" >> Wynik.txt

DATA=$(date +%Y-%m-%d-%H:%M)
MODEL=$(adb devices -l | grep "model"| awk '{print $5}' | sed 's/model://g')
mv Wynik.txt Wyniki/Wynik_${MODEL}_${DATA}.txt
