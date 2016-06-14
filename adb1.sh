#!/bin/bash

#adb='adb shell'

#$adb cp -r sys/bus/platform/drivers/ > ~/find/

#$adb grep -lr 'OF_FULLNAME' sys/bus/platform/drivers > ~/grep.txt

#$adb find -L sys/bus/platform/drivers -name 'uevent' -maxdepth 3 > ~/find.txt

#adb pull sys/bus/platform/drivers/sdhci_msm/msm_sdcc.2/uevent ~/Kopie
#$adb cat sys/bus/platform/devices/DIAG_CMD.0/driver/DIAG_CMD.0/driver/DIAG_CMD.0/driver/DIAG_CMD.0/driver/DIAG_CMD.0/driver/DIAG_CMD.0/driver/DIAG_CMD.0/driver/DIAG_CMD.0/driver/DIAG_CMD.0/driver/DIAG_CMD.0/driver/DIAG_CMD.0/driver/DIAG_CMD.0/driver/DIAG_CMD.0/driver/DIAG_CMD.0/driver/DIAG_CMD.0/driver/DIAG_CMD.0/driver/DIAG_CMD.0/driver/DIAG_CMD.0/driver/DIAG_CMD.0/subsystem/devices/fc342000.cti/subsystem/drivers/qcom,rpm-regulator-smd-resource/uevent
#find /proc -name 'cmdline' > ~/sdcard/find.txt
#clear
#!/bin/bash


time monkey -p pl.inpost.mobile -c android.intent.category.LAUNCHER 1


I=1				# inicjujemy zmienną mówiącą o numerze elementu

for WERS in $(cat find.txt)
do
	adb pull $WERS ~/Kopie
	I=`expr $I + 1`
	mv ~/Kopie/uevent ~/Kopie/uevent_$I
done


for WERS in $(cat find.txt)
do
	cat $WERS >> /sdcard/wynik.txt
done
