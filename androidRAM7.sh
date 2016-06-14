#!/system/bin/sh

#-------------------------------------------------------------------------------------------------------------------------------------------
VFS=0      # <<<<<<<<<<<<<<< Tu wpisz wartość początkową vfs_cache_pressure
#-------------------------------------------------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------------------------------------------
VFSEnd=10000  # <<<<<<<<<<<<<<< Tu wpisz wartość końcową vfs_cache_pressure
#-------------------------------------------------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------------------------------------------
VFSstep=500  # <<<<<<<<<<<<<<< Tu wpisz wartość o jaką będzie zmieniane vfs_cache_pressure
#-------------------------------------------------------------------------------------------------------------------------------------------

# Pobranie czasu
Czas1=$(date +%s)

#-------------------------------------------------------------------------------------------------------------------------------------------
# Pobranie wartości vfs_cache_pressure żeby po zakończeniu pomiaru przywrócić tą wartość.
VFSdefault=$(cat /proc/sys/vm/vfs_cache_pressure)
#-------------------------------------------------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------------------------------------------
# Ustawienie vfs_cache_pressure na wartość początkową VFS .
echo "$VFS" > /proc/sys/vm/vfs_cache_pressure
#-------------------------------------------------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------------------------------------------
# Gdzie ja jestem !!!
# Określa położenie skryptu i umieszcza ją w zmiennej H.
H=`pwd`
# Wszystkie pliki z wynikami zostaną zapisane w tej samej lokalizacji co plik skryptu .
#-------------------------------------------------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------------------------------------------
# Tworzenie pliku w którym będą wyniki pomiarów.
echo "tapatalk           |messanger           |facebook            |chrome              |ZRAM                |vfs_cache_pressure  |multitasking        |" > $H/Wynik.txt
echo "--------------------------------------------------------------------------------------------------------------------------------------------------" >> $H/Wynik.txt
echo "RAM       |CZAS    |RAM       |CZAS     |RAM       |CZAS     |RAM       |CZAS     |zapełnienie         |wartość             |                    |" >> $H/Wynik.txt
echo "--------------------------------------------------------------------------------------------------------------------------------------------------" >> $H/Wynik.txt
#-------------------------------------------------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------------------------------------------
# Tworzenie tabeli w którym będą wyniki pomiarów na ekranie komputera
echo "tapatalk           |messanger           |facebook            |chrome              |ZRAM                |vfs_cache_pressure  |multitasking   |"
echo "---------------------------------------------------------------------------------------------------------------------------------------------"
echo "RAM       |CZAS    |RAM       |CZAS     |RAM       |CZAS     |RAM       |CZAS     |zapełnienie         |wartość             |               |"
echo "---------------------------------------------------------------------------------------------------------------------------------------------"
#-------------------------------------------------------------------------------------------------------------------------------------------


#-------------------------------------------------------------------------------------------------------------------------------------------
# To jest funkcja. Można ją wywołać w dowolnym momencie wpisując jej nazwę . Funkcja zostanie użyta w pętli pomiaru .
tapatalk () {
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Uruchomienie oraz pomiar czasu uruchamiania aplikacji. Zapisanie wyniku do pliku tapatalkpro.txt
	(time am start -n com.quoord.tapatalkpro.activity/com.quoord.tapatalkpro.activity.directory.ics.AccountEntryActivity) &> $H/tapatalkpro.txt
	# Pobieranie linijki z pomiarem czasu i zapisanie jej do zmiennej T1 .
	T1=$(cat $H/tapatalkpro.txt | grep real | awk '{print $1}')
	sleep 5
	# Pomiar zajmowanej przez aplikacje pamięci RAM i zapisanie jej w zmiennej T2.
	T2=$(procrank 2> /dev/null | grep com.quoord.tapatalkpro.activity | awk '{print $4}' | sed -e 's|K||g' | awk '{ sum += $1 } END { print sum }')
	#-------------------------------------------------------------------------------------------------------------------------------------------
}

messenger() {
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Uruchomienie oraz pomiar czasu uruchamiania aplikacji. Zapisanie wyniku do pliku messenger.txt
	(time am start -n com.facebook.orca/.auth.StartScreenActivity) &> $H/messenger.txt
	# Pobieranie linijki z pomiarem czasu i zapisanie jej do zmiennej M1 .
	M1=$(cat $H/messenger.txt | grep real | awk '{print $1}')
	sleep 5
	# Pomiar zajmowanej przez aplikacje pamięci RAM i zapisanie jej w zmiennej M2.
	M2=$(procrank 2> /dev/null | grep com.facebook.orca | awk '{print $4}' | sed -e 's|K||g' | awk '{ sum += $1 } END { print sum }')
	#-------------------------------------------------------------------------------------------------------------------------------------------
}

facebook() {
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Uruchomienie oraz pomiar czasu uruchamiania aplikacji. Zapisanie wyniku do pliku facebook.txt
	(time am start -n com.facebook.katana/com.facebook.katana.activity.FbMainTabActivity) &> $H/facebook.txt
	# Pobieranie linijki z pomiarem czasu i zapisanie jej do zmiennej F1 .
	F1=$(cat $H/facebook.txt | grep real | awk '{print $1}')
	sleep 5
	# Pomiar zajmowanej przez aplikacje pamięci RAM i zapisanie jej w zmiennej F2.
	F2=$(procrank 2> /dev/null | grep com.facebook.katana | awk '{print $4}' | sed -e 's|K||g' | awk '{ sum += $1 } END { print sum }')
	#-------------------------------------------------------------------------------------------------------------------------------------------
}

chrome() {
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Uruchomienie oraz pomiar czasu uruchamiania aplikacji. Zapisanie wyniku do pliku chrome.txt
	(time am start -n com.android.chrome/com.google.android.apps.chrome.Main) &> $H/chrome.txt
	# Pobieranie linijki z pomiarem czasu i zapisanie jej do zmiennej C1 .
	C1=$(cat $H/chrome.txt | grep real | awk '{print $1}')
	sleep 5
	# Pomiar zajmowanej przez aplikacje pamięci RAM i zapisanie jej w zmiennej C2.
	C2=$(procrank 2> /dev/null | grep com.android.chrome | awk '{print $4}' | sed -e 's|K||g' | awk '{ sum += $1 } END { print sum }')
	#-------------------------------------------------------------------------------------------------------------------------------------------
}

test_ram() {
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Sprawdzanie czy wszystkie aplikacje nadal pracują 
	procrank > $H/procrand.txt 2> /dev/null
	
	T3=$(cat $H/procrand.txt | grep com.quoord.tapatalkpro.activity | awk '{print $4}' | sed -e 's|K||g' | awk '{ sum += $1 } END { print sum }')
	M3=$(cat $H/procrand.txt | grep com.facebook.orca | awk '{print $4}' | sed -e 's|K||g' | awk '{ sum += $1 } END { print sum }')
	F3=$(cat $H/procrand.txt | grep com.facebook.katana | awk '{print $4}' | sed -e 's|K||g' | awk '{ sum += $1 } END { print sum }')
	C3=$(cat $H/procrand.txt | grep com.android.chrome | awk '{print $4}' | sed -e 's|K||g' | awk '{ sum += $1 } END { print sum }')
	
	echo "$T3 $M3 $F3 $C3" > $H/testRAM.txt
	
	P=$(wc -w $H/testRAM.txt | awk '{print $1}')
	
		if [ $P == 4 ]; then
			T5="TAK"
		else
			T5="NIE"
		fi
	#-------------------------------------------------------------------------------------------------------------------------------------------
}

killer_app() {
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Zabicie aplikacji :) Tylko ją wyłącza a nie odinstalowuje .
	ps | grep com.facebook.katana | awk '{print $2}' | xargs kill 2> /dev/null
	ps | grep com.facebook.orca | awk '{print $2}' | xargs kill 2> /dev/null
	ps | grep com.android.chrome | awk '{print $2}' | xargs kill 2> /dev/null
	ps | grep com.quoord.tapatalkpro.activity | awk '{print $2}' | xargs kill 2> /dev/null
	#-------------------------------------------------------------------------------------------------------------------------------------------
}

killer_app

while (($VFS<=$VFSEnd)); do
		tapatalk
		messenger
		facebook
		chrome
		test_ram

#-------------------------------------------------------------------------------------------------------------------------------------------
# Pomiar SWAP
D9=$(free | grep Swap: | awk '{print $3}')
#-------------------------------------------------------------------------------------------------------------------------------------------


# Dodanie wyników pomiaru do pliku Wyniki.txt 
echo "$T2 $T1 $M2 $M1 $F2 $F1 $C2 $C1 $D9 $VFS $T5  " > $H/Tabela.txt
awk '{printf "%-10s|%-8s|%-10s|%-9s|%-10s|%-9s|%-10s|%-9s|%-20s|%-20s|%-20s|\n",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11}' $H/Tabela.txt >> $H/Wynik.txt
awk '{printf "%-10s|%-8s|%-10s|%-9s|%-10s|%-9s|%-10s|%-9s|%-20s|%-20s|%-15s|\n",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11}' $H/Tabela.txt > $H/Wynik1.txt
Print1=$(cat $H/Wynik1.txt)
echo "$Print1"

#-------------------------------------------------------------------------------------------------------------------------------------------
# Dodawanie wartości VFS
VFS=$(($VFSstep + $VFS))
#-------------------------------------------------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------------------------------------------
# Ustawianie /proc/sys/vm/vfs_cache_pressure do wartości VFS
echo "$VFS" > /proc/sys/vm/vfs_cache_pressure
#-------------------------------------------------------------------------------------------------------------------------------------------

		killer_app

done

	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Zabicie aplikacji :) Tylko ją wyłącza a nie odinstalowuje .
	ps | grep com.facebook.katana | awk '{print $2}' | xargs kill 2> /dev/null
	ps | grep com.facebook.orca | awk '{print $2}' | xargs kill 2> /dev/null
	ps | grep com.android.chrome | awk '{print $2}' | xargs kill 2> /dev/null
	ps | grep com.quoord.tapatalkpro.activity | awk '{print $2}' | xargs kill 2> /dev/null
	#-------------------------------------------------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------------------------------------------
# Ustawienie vfs_cache_pressure na wartość początkową VFSdefault  .
echo "$VFSdefault" > /proc/sys/vm/vfs_cache_pressure
#-------------------------------------------------------------------------------------------------------------------------------------------

# Obiczenie ile czasu zajeło przeprowaczenie testów.
Czas2=$(date +%s)
Sek=$(($Czas2 - $Czas1))
echo "--------------------------------------------------------------------------------------------------------------------------------------------------" >> $H/Wynik.txt
echo "" >> $H/Wynik.txt
echo "Czas wykonania pomiaru to: $Sek sekund/y" >> $H/Wynik.txt
