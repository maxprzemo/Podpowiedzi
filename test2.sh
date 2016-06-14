#!/system/bin/sh

find /proc -name 'cgroup' -maxdepth 2 > ~/sdcard/find2.txt

for WERS in $(cat find2.txt)
do
echo "==== $WERS" >> /sdcard/wynik2.txt
cat $WERS >> /sdcard/wynik2.txt
echo "" >> /sdcard/wynik2.txt
done
