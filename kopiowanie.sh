#!/bin/bash

model=$(adb devices -l | awk '{print $5}' | sed 's/model://g')

if [ $model == MotoG3 ]; then
	echo "połączenie z MotoG3 aktywne"
	else
	echo "brak połaczenia"
	exit 1
fi

find ~/HDD/vanirAOSP/out/target/product/osprey -name 'vanir_osprey_6.*.zip' > find.txt
Plik=$(cat find.txt)

if [ -f "$Plik" ] ; then
	adb push $Plik /sdcard/
	else
   echo ">>>>>>>>> Plik nie istnieje <<<<<<<<<"
fi
sed -i 's:/home/maxprzemo/HDD/vanirAOSP/out/target/product/osprey/::g' find.txt
Plik=$(cat find.txt)
echo " Skopiowano $Plik do pamięci telefonu"
adb shell su -c "touch cache/recovery/openrecoveryscript"
adb shell su -c "echo 'wipe cache' > cache/recovery/openrecoveryscript"
adb shell su -c "echo 'wipe dalvik' >> cache/recovery/openrecoveryscript"
adb shell su -c "echo 'install sdcard/$Plik' >> cache/recovery/openrecoveryscript"
adb shell su -c "reboot recovery"
