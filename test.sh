#!/system/bin/sh

find /proc -name 'cmdline' -maxdepth 2 > ~/sdcard/find.txt

for WERS in $(cat find.txt)
do
echo "==== $WERS"  >> /sdcard/wynik.txt
cat $WERS >> /sdcard/wynik.txt
echo "" >> /sdcard/wynik.txt
done
