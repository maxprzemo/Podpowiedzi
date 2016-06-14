#!/system/bin/sh

VFS=0         # <<<<<<<<<<<<<<< Tu wpisz wartość początkową vfs_cache_pressure

VFSstep=500   # <<<<<<<<<<<<<<< Tu wpisz wartość o jaką będzie zmieniane vfs_cache_pressure

VFSEnd=10000  # <<<<<<<<<<<<<<< Tu wpisz wartość końcową vfs_cache_pressure

# Pobranie czasu
Czas1=$(date +%s)

# Pobranie wartości domyślną vfs_cache_pressure żeby po zakończeniu pomiaru przywrócić tą wartość.
VFSdefault=$(cat /proc/sys/vm/vfs_cache_pressure)

# Ustawienie vfs_cache_pressure na wartość początkową VFS .
echo "$VFS" > /proc/sys/vm/vfs_cache_pressure

# Gdzie ja jestem !!!
# Określa położenie gdzie został uruchomiony skrypt i umieszcza ją w zmiennej H.
H=`pwd`
# Wszystkie pliki z wynikami zostaną zapisane w tej samej lokalizacji co miejsce uruchomienia skryptu.

# Uruchomienie Tapatalk
tapatalk () {
	am start -n com.quoord.tapatalkpro.activity/com.quoord.tapatalkpro.activity.directory.ics.AccountEntryActivity 2>&1 > /dev/null
}

# Uruchomienie Messenger
messenger() {
	am start -n com.facebook.orca/.auth.StartScreenActivity &> /dev/null
}

# Uruchomienie Facebook
facebook() {
	am start -n com.facebook.katana/com.facebook.katana.activity.FbMainTabActivity &> /dev/null
}

# Uruchomienie Chrome
chrome() {
	am start -n com.android.chrome/com.google.android.apps.chrome.Main &> /dev/null
}

# Uruchomienie aplikacji Telefon
telefon() {
	am start -n com.android.contacts/.activities.DialtactsActivity &> /dev/null
}

# Uruchomienie aplikacji Ustawienia
ustawienia() {
	am start -n com.lge.settings.easy/.EasySettings &> /dev/null
}

# Uruchomienie wyszukiwarki Google
camera() {
	am start -n com.lge.camera/.CameraAppLauncher &> /dev/null
}

# Uruchomienie aplikacji SMS
mms() {
	am start -n com.android.mms/com.android.mms.ui.ConversationList 2>&1 > /dev/null
}


# Tworzenie pliku w którym będą wyniki pomiarów.
echo "# " > $H/Wynik.txt
echo "#  * Pomiar na czterech aplikacji Tapatalk, Messenger, Facebook, Chrome." >> $H/Wynik.txt
echo "#  ** Pomiar na ośmiu aplikacjach Tapatalk, Messenger, Facebook, Chrome, Telefon, Ustawienia, Aparat, SMS." >> $H/Wynik.txt
echo "#  *** Ilość pamięci RAM zajęte przez aplikacje które nie zostały zabite." >> $H/Wynik.txt
echo "#" >> $H/Wynik.txt
echo "-------------------------------------------------------------------------------------------------------------------------------" >> $H/Wynik.txt
echo "Test_4*                                   |Test_8**                                  |vfs_cache_pressure                      |" >> $H/Wynik.txt
echo "-------------------------------------------------------------------------------------------------------------------------------" >> $H/Wynik.txt
echo "RAM***    |multi-task|ZRAM                |RAM***    |multi-task|ZRAM                |                                        |" >> $H/Wynik.txt
echo "-------------------------------------------------------------------------------------------------------------------------------" >> $H/Wynik.txt
echo "Kb        |tak/nie   |wolne     |zajęte   |Kb        |tak/nie   |wolne     |zajęte   |wartość                                 |" >> $H/Wynik.txt
echo "-------------------------------------------------------------------------------------------------------------------------------" >> $H/Wynik.txt

# Tworzenie tabeli w którym będą wyniki pomiarów na ekranie komputera
echo "# "
echo "#  * Pomiar na czterech aplikacji Tapatalk, Messenger, Facebook, Chrome."
echo "#  ** Pomiar na ośmiu aplikacjach Tapatalk, Messenger, Facebook, Chrome, Telefon, Ustawienia, Aparat, SMS."
echo "#  *** Ilość pamięci RAM zajęte przez aplikacje które nie zostały zabite."
echo "#"
echo "-------------------------------------------------------------------------------------------------------------------------------"
echo "Test_4*                                   |Test_8**                                  |vfs_cache_pressure                      |"
echo "-------------------------------------------------------------------------------------------------------------------------------"
echo "RAM***    |multi-task|ZRAM                |RAM***    |multi-task|ZRAM                |                                        |"
echo "-------------------------------------------------------------------------------------------------------------------------------"
echo "Kb        |tak/nie   |wolne     |zajęte   |Kb        |tak/nie   |wolne     |zajęte   |wartość                                 |"
echo "-------------------------------------------------------------------------------------------------------------------------------"

	# Sprawdzanie czy wszystkie aplikacje nadal pracują 
test_ram() {
	procrank > $H/procrank.txt 2> /dev/null

	T3=$(cat $H/procrank.txt | grep com.quoord.tapatalkpro.activity | awk '{print $4}' | sed -e 's|K||g' | awk '{ sum += $1 } END { print sum }')
	M3=$(cat $H/procrank.txt | grep com.facebook.orca | awk '{print $4}' | sed -e 's|K||g' | awk '{ sum += $1 } END { print sum }')
	F3=$(cat $H/procrank.txt | grep com.facebook.katana | awk '{print $4}' | sed -e 's|K||g' | awk '{ sum += $1 } END { print sum }')
	C3=$(cat $H/procrank.txt | grep com.android.chrome | awk '{print $4}' | sed -e 's|K||g' | awk '{ sum += $1 } END { print sum }')
	
	echo "$T3 $M3 $F3 $C3" > $H/testRAM.txt
	
	Ram_four=$(($T3 + $M3 + $F3 + $C3))
	
	P=$(wc -w $H/testRAM.txt | awk '{print $1}')
	
		if [ $P == 4 ]; then
			T5="TAK"
		else
			T5="NIE"
		fi
		#rm $H/procrank.txt
		#rm $H/testRAM.txt
}

# Sprawdzanie czy wszystkie aplikacje nadal pracują 
test_ram_eight() {
	procrank > $H/procrank_eight.txt 2> /dev/null

	T3=$(cat $H/procrank_eight.txt | grep com.quoord.tapatalkpro.activity | awk '{print $4}' | sed -e 's|K||g' | awk '{ sum += $1 } END { print sum }')
	M3=$(cat $H/procrank_eight.txt | grep com.facebook.orca | awk '{print $4}' | sed -e 's|K||g' | awk '{ sum += $1 } END { print sum }')
	F3=$(cat $H/procrank_eight.txt | grep com.facebook.katana | awk '{print $4}' | sed -e 's|K||g' | awk '{ sum += $1 } END { print sum }')
	C3=$(cat $H/procrank_eight.txt | grep com.android.chrome | awk '{print $4}' | sed -e 's|K||g' | awk '{ sum += $1 } END { print sum }')
	Co3=$(cat $H/procrank_eight.txt | grep com.android.contacts | awk '{print $4}' | sed -e 's|K||g' | awk '{ sum += $1 } END { print sum }')
	S3=$(cat $H/procrank_eight.txt | grep com.lge.settings.easy | awk '{print $4}' | sed -e 's|K||g' | awk '{ sum += $1 } END { print sum }')
	G3=$(cat $H/procrank_eight.txt | grep com.lge.camera | awk '{print $4}' | sed -e 's|K||g' | awk '{ sum += $1 } END { print sum }')
	M3=$(cat $H/procrank_eight.txt | grep com.android.mms | awk '{print $4}' | sed -e 's|K||g' | awk '{ sum += $1 } END { print sum }')
	
	echo "$T3 $M3 $F3 $C3 $Co3 $S3 $G3 $M3 " > $H/testRAMeight.txt
	
	Ram_eight=$(($T3 + $M3 + $F3 + $C3 + $Co3 + $S3 + $G3 + $M3))
	
	P=$(wc -w $H/testRAMeight.txt | awk '{print $1}')
	
		if [ $P == 8 ]; then
			T6="TAK"
		else
			T6="NIE"
		fi
		#rm $H/procrank_eight.txt
		#rm $H/testRAMeight.txt
}

# Zabicie aplikacji :) Tylko ją wyłącza a nie odinstalowuje .
killer_app() {
  ps | grep com.quoord.tapatalkpro.activity | awk '{print $2}' | xargs kill &> /dev/null
  ps | grep com.facebook.katana | awk '{print $2}' | xargs kill &> /dev/null
  ps | grep com.facebook.orca | awk '{print $2}' | xargs kill &> /dev/null
  ps | grep com.android.chrome | awk '{print $2}' | xargs kill &> /dev/null
  ps | grep com.android.contacts | awk '{print $2}' | xargs kill &> /dev/null
  ps | grep com.lge.settings.easy | awk '{print $2}' | xargs kill &> /dev/null
  ps | grep com.lge.camera | awk '{print $2}' | xargs kill &> /dev/null
  ps | grep com.android.mms | awk '{print $2}' | xargs kill &> /dev/null
}

test_four() {
	target=$1
case "$target" in
	"4" )
  tapatalk
  sleep 3
  messenger
  sleep 3
  facebook
  sleep 3
  chrome
  sleep 3
  test_ram
  # Pomiar SWAP
  D8=$(free | grep Swap: | awk '{print $4}')
  D9=$(free | grep Swap: | awk '{print $3}')
  sleep 1
  killer_app
  sleep 5
        ;;
esac
}

test_eight() {
	target=$1
case "$target" in
	"8" )
  tapatalk
  sleep 3
  messenger
  sleep 3
  facebook
  sleep 3
  chrome
  sleep 3
  telefon
  sleep 3
  ustawienia
  sleep 3
  camera
  sleep 3
  mms
  sleep 3
  test_ram_eight
  # Pomiar SWAP
  D10=$(free | grep Swap: | awk '{print $4}')
  D11=$(free | grep Swap: | awk '{print $3}')
  sleep 1
  killer_app
  sleep 5
        ;;
esac
}

killer_app

while (($VFS<=$VFSEnd)); do
	
	test_four 4
	sleep 1
	test_eight 8
	
	
	# Dodanie wyników pomiaru do pliku Wyniki.txt 
	echo "$Ram_four $T5 $D8 $D9 $Ram_eight $T6 $D10 $D11 $VFS " > $H/Tabela.txt
	awk '{printf "%-10s|%-10s|%-10s|%-9s|%-10s|%-10s|%-10s|%-9s|%-40s|\n",$1,$2,$3,$4,$5,$6,$7,$8,$9}' $H/Tabela.txt >> $H/Wynik.txt
	awk '{printf "%-10s|%-10s|%-10s|%-9s|%-10s|%-10s|%-10s|%-9s|%-40s|\n",$1,$2,$3,$4,$5,$6,$7,$8,$9}' $H/Tabela.txt > $H/Wynik1.txt
	Print1=$(cat $H/Wynik1.txt)
	echo "$Print1"
	
	# Dodawanie wartości VFS
	VFS=$(($VFSstep + $VFS))
	
	# Ustawianie /proc/sys/vm/vfs_cache_pressure do wartości VFS
	echo "$VFS" > /proc/sys/vm/vfs_cache_pressure
	
done

# Ustawienie vfs_cache_pressure na wartość początkową VFSdefault  .
echo "$VFSdefault" > /proc/sys/vm/vfs_cache_pressure

# Obiczenie ile czasu zajeło przeprowaczenie testów.
Czas2=$(date +%s)
Sek=$(($Czas2 - $Czas1))
echo "-------------------------------------------------------------------------------------------------------------------------------" >> $H/Wynik.txt
echo "" >> $H/Wynik.txt
echo "Czas wykonania pomiaru to: $Sek sekund/y" >> $H/Wynik.txt
