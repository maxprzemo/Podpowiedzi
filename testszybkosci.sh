#!/system/bin/sh

#-------------------------------------------------------------------------------------------------------------------------------------------
# Gdzie ja jestem !!!
# Określa położenie skryptu i umieszcza ją w zmiennej H.
H=`pwd`
# Wszystkie pliki z wynikami zostaną zapisane w tej samej lokalizacji co plik skryptu .
#-------------------------------------------------------------------------------------------------------------------------------------------

# Pobranie czasu
Czas1=$(date +%s)

#-------------------------------------------------------------------------------------------------------------------------------------------
# Tworzenie pliku w którym będą wyniki pomiarów.
cat << EOF > $H/Wynik.txt

------------------------------------------------------------------------------------------------------------------------
Tapatalk           |Messanger           |Facebook           |Chrome              |Razem                |
------------------------------------------------------------------------------------------------------------------------
Czas                 |Czas                      |Czas                    |Czas                    |Czas                    |
------------------------------------------------------------------------------------------------------------------------
EOF

# czyszczenie starych plików
if [ -e Suma.txt ]; then
rm Suma.txt
fi
if [ -e chrome1.txt ]; then
rm chrome1.txt
fi
if [ -e tapatalkpro1.txt ]; then
rm tapatalkpro1.txt
fi
if [ -e messenger1.txt ]; then
rm messenger1.txt
fi
if [ -e facebook1.txt ]; then
rm facebook1.txt
fi

chrome() {
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Zabicie aplikacji chrome jeśli pracuje :) Tylko ją wyłącza a nie odinstalowuje .
	 am force-stop com.android.chrome
	 sleep 2
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Uruchomienie oraz pomiar czasu uruchamiania aplikacji. Zapisanie wyniku do pliku chrome.txt
	(time am start -W com.android.chrome/com.google.android.apps.chrome.Main) &> $H/chrome.txt
	# Pobieranie linijki z pomiarem czasu i zapisanie jej do zmiennej C1 .
	C1=$(cat $H/chrome.txt | grep real | awk '{print $1}')
	C2=$(echo $C1 | sed -e 's|0m||g' | sed -e 's|s||g' | awk '{print $1}')
	echo "$C2" >> chrome1.txt
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Zabicie aplikacji chrome :)
	 sleep 2
	 am force-stop com.android.chrome
	#-------------------------------------------------------------------------------------------------------------------------------------------
}

tapatalk () {
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Zabicie aplikacji tapatalk jeśli pracuje :) Tylko ją wyłącza a nie odinstalowuje .
	 am force-stop com.quoord.tapatalkpro.activity
	 sleep 2
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Uruchomienie oraz pomiar czasu uruchamiania aplikacji. Zapisanie wyniku do pliku tapatalkpro.txt
	(time am start -W com.quoord.tapatalkpro.activity/com.quoord.tapatalkpro.activity.directory.ics.AccountEntryActivity) &> $H/tapatalkpro.txt
	# Pobieranie linijki z pomiarem czasu i zapisanie jej do zmiennej T1 .
	T1=$(cat $H/tapatalkpro.txt | grep real | awk '{print $1}')
	T2=$(echo $T1 | sed -e 's|0m||g' | sed -e 's|s||g' | awk '{print $1}')
	echo "$T2" >> tapatalkpro1.txt
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Zabicie aplikacji tapatalk :) 
    sleep 2
	 am force-stop com.quoord.tapatalkpro.activity
	#-------------------------------------------------------------------------------------------------------------------------------------------
}

messenger() {
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Zabicie aplikacji messenger jeśli pracuje :) Tylko ją wyłącza a nie odinstalowuje .
	am force-stop com.facebook.orca
	sleep 2
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Uruchomienie oraz pomiar czasu uruchamiania aplikacji. Zapisanie wyniku do pliku messenger.txt
	(time am start -W com.facebook.orca/.auth.StartScreenActivity) &> $H/messenger.txt
	# Pobieranie linijki z pomiarem czasu i zapisanie jej do zmiennej M1 .
	M1=$(cat $H/messenger.txt | grep real | awk '{print $1}')
	M2=$(echo $M1 | sed -e 's|0m||g' | sed -e 's|s||g' | awk '{print $1}')
	echo "$M2" >> messenger1.txt
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Zabicie aplikacji messenger :) 
	 sleep 2
	am force-stop com.facebook.orca
	#-------------------------------------------------------------------------------------------------------------------------------------------
}

facebook() {
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Zabicie aplikacji facebook jeśli pracuje :) Tylko ją wyłącza a nie odinstalowuje .
	am force-stop com.facebook.katana
	sleep 2
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Uruchomienie oraz pomiar czasu uruchamiania aplikacji. Zapisanie wyniku do pliku facebook.txt
	(time am start -W com.facebook.katana/com.facebook.katana.activity.FbMainTabActivity) &> $H/facebook.txt
	# Pobieranie linijki z pomiarem czasu i zapisanie jej do zmiennej F1 .
	F1=$(cat $H/facebook.txt | grep real | awk '{print $1}')
	F2=$(echo $F1 | sed -e 's|0m||g' | sed -e 's|s||g' | awk '{print $1}')
	echo "$F2" >> facebook1.txt
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Zabicie aplikacji facebook :)
	sleep 2
	am force-stop com.facebook.katana
	#-------------------------------------------------------------------------------------------------------------------------------------------
}

#-------------------------------------------------------------------------------------------------------------------------------------------
VFS=1      # <<<<<<<<<<<<<<< Tu wpisz wartość początkową vfs_cache_pressure
#-------------------------------------------------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------------------------------------------
VFSEnd=10  # <<<<<<<<<<<<<<< Tu wpisz wartość końcową vfs_cache_pressure
#-------------------------------------------------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------------------------------------------
VFSstep=1  # <<<<<<<<<<<<<<< Tu wpisz wartość o jaką będzie zmieniane vfs_cache_pressure
#-------------------------------------------------------------------------------------------------------------------------------------------


while (($VFS<=$VFSEnd)); do
    #-------------------------------------------------------------------------------------------------------------------------------------------
		tapatalk
		messenger
		facebook
		chrome
	#-------------------------------------------------------------------------------------------------------------------------------------------
    # Dodanie wyników pomiaru do pliku Wyniki.txt 
    W1=$(awk "BEGIN {print $T2+$M2+$F2+$C2}")
    echo "$W1" >> Suma.txt
    echo "$T1 $M1 $F1 $C1 $W1" > $H/Tabela.txt
    awk '{printf "%-17s|%-22s|%-20s|%-21s|%-21s\n",$1,$2,$3,$4,$5}' $H/Tabela.txt >> $H/Wynik.txt
    #-------------------------------------------------------------------------------------------------------------------------------------------
    # Dodawanie wartości VFS
    VFS=$(($VFSstep + $VFS))
    #-------------------------------------------------------------------------------------------------------------------------------------------

done

# Obliczanie średnich
T3=$(cat tapatalkpro1.txt | awk '{ sum += $1 } END { print sum }' | awk "BEGIN {print $1/$VFSEnd}")
M3=$(cat messenger1.txt | awk '{ sum += $1 } END { print sum }' | awk "BEGIN {print $1/$VFSEnd}")
C3=$(cat chrome1.txt | awk '{ sum += $1 } END { print sum }' | awk '{printf "%.2f \n", $1/2}')
F3=$(cat facebook1.txt | awk '{ sum += $1 } END { print sum }' | awk "BEGIN {print $1/$VFSEnd}")
W2=$(cat Suma.txt | awk '{ sum += $1 } END { print sum }' | awk "BEGIN {print $1/$VFSEnd}")

# Obiczenie ile czasu zajeło przeprowaczenie testów.
Czas2=$(date +%s)
Sek=$(($Czas2 - $Czas1))
echo "------------------------------------------------------------------------------------------------------------------------" >> $H/Wynik.txt
echo "" >> $H/Wynik.txt
echo "Czas wykonania pomiaru to: $Sek sekund/y" >> $H/Wynik.txt


#input keyevent 138
#text/html
#am start -d "file:///sdcard/Download/test.html" -t "*/*" -a android.intent.action.VIEW




