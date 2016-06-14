#!/system/bin/sh

#-------------------------------------------------------------------------------------------------------------------------------------------
# Gdzie ja jestem !!!
# Określa położenie skryptu i umieszcza ją w zmiennej H.
H=`pwd -P`
# Wszystkie pliki z wynikami zostaną zapisane w tej samej lokalizacji co lokalizacja uruchomienia skryptu .
#-------------------------------------------------------------------------------------------------------------------------------------------
# Zamknięcie wszystkich procesów działających w tle
am kill-all
#-------------------------------------------------------------------------------------------------------------------------------------------
# Pobranie czasu
Czas1=$(date +%s)
#-------------------------------------------------------------------------------------------------------------------------------------------
# Tworzenie pliku w którym będą wyniki pomiarów.
cat << EOF > $H/Wynik.html
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>Tabela Wyników</title>
<style>
      body{
        background-color:#ADD8E6;
        font-family:Helvetica, sans-serif;
        font-size:1.3em;
      }
      table{
        background-color:#1E90FF;
      }
      td{
        text-align:center;
      }
</style>
</head>
<body>
<table cellpadding="15" border="border" align="center" width="90%">
<tr>
<td>Tapatalk</td>
<td>Messanger</td>
<td>Facebook</td>
<td>Chrome</td>
<td>Razem</td>
</tr>
EOF

# czyszczenie starych plików jeśli istnieją
if [ -e Suma.txt ]; then rm $H/Suma.txt ; fi
if [ -e chrome1.txt ]; then rm $H/chrome1.txt ; fi
if [ -e tapatalkpro1.txt ]; then rm $H/tapatalkpro1.txt ; fi
if [ -e messenger1.txt ]; then rm $H/messenger1.txt ; fi
if [ -e facebook1.txt ]; then rm $H/facebook1.txt ; fi



chrome() {
    # Wybudzenie ekranu telefonu
    input swipe 400 500 350 900 100
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Zabicie aplikacji chrome jeśli pracuje :) Tylko ją wyłącza a nie odinstalowuje .
	 am force-stop com.android.chrome
	 sleep 1
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Uruchomienie oraz pomiar czasu uruchamiania aplikacji. Zapisanie wyniku do pliku chrome.txt
	(time am start -W com.android.chrome/com.google.android.apps.chrome.Main) &> $H/chrome.txt
	# Pobieranie linijki z pomiarem czasu i zapisanie jej do zmiennej C1 .
	C1=$(cat $H/chrome.txt | grep real | awk '{print $1}')
	C2=$(echo $C1 | sed -e 's|0m||g' | sed -e 's|s||g' | awk '{print $1}')
	echo "$C2" >> $H/chrome1.txt
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Zabicie aplikacji chrome :)
	 sleep 2
	 am force-stop com.android.chrome
	#-------------------------------------------------------------------------------------------------------------------------------------------
}

tapatalk () {
    # Wybudzenie ekranu telefonu
    input swipe 400 500 350 900 100
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Zabicie aplikacji tapatalk jeśli pracuje :) Tylko ją wyłącza a nie odinstalowuje .
	 am force-stop com.quoord.tapatalkpro.activity
	 sleep 1
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Uruchomienie oraz pomiar czasu uruchamiania aplikacji. Zapisanie wyniku do pliku tapatalkpro.txt
	(time am start -W com.quoord.tapatalkpro.activity/com.quoord.tapatalkpro.activity.directory.ics.AccountEntryActivity) &> $H/tapatalkpro.txt
	# Pobieranie linijki z pomiarem czasu i zapisanie jej do zmiennej T1 .
	T1=$(cat $H/tapatalkpro.txt | grep real | awk '{print $1}')
	T2=$(echo $T1 | sed -e 's|0m||g' | sed -e 's|s||g' | awk '{print $1}')
	echo "$T2" >> $H/tapatalkpro1.txt
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Zabicie aplikacji tapatalk :) 
    sleep 2
	 am force-stop com.quoord.tapatalkpro.activity
	#-------------------------------------------------------------------------------------------------------------------------------------------
}

messenger() {
	 # Wybudzenie ekranu telefonu
    input swipe 400 500 350 900 100
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Zabicie aplikacji messenger jeśli pracuje :) Tylko ją wyłącza a nie odinstalowuje .
	am force-stop com.facebook.orca
	sleep 1
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Uruchomienie oraz pomiar czasu uruchamiania aplikacji. Zapisanie wyniku do pliku messenger.txt
	(time am start -W com.facebook.orca/.auth.StartScreenActivity) &> $H/messenger.txt
	# Pobieranie linijki z pomiarem czasu i zapisanie jej do zmiennej M1 .
	M1=$(cat $H/messenger.txt | grep real | awk '{print $1}')
	M2=$(echo $M1 | sed -e 's|0m||g' | sed -e 's|s||g' | awk '{print $1}')
	echo "$M2" >> $H/messenger1.txt
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Zabicie aplikacji messenger :) 
	 sleep 2
	am force-stop com.facebook.orca
	#-------------------------------------------------------------------------------------------------------------------------------------------
}

facebook() {
    # Wybudzenie ekranu telefonu
    input swipe 400 500 350 900 100
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Zabicie aplikacji facebook jeśli pracuje :) Tylko ją wyłącza a nie odinstalowuje .
	am force-stop com.facebook.katana
	sleep 1
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Uruchomienie oraz pomiar czasu uruchamiania aplikacji. Zapisanie wyniku do pliku facebook.txt
	(time am start -W com.facebook.katana/com.facebook.katana.activity.FbMainTabActivity) &> $H/facebook.txt
	# Pobieranie linijki z pomiarem czasu i zapisanie jej do zmiennej F1 .
	F1=$(cat $H/facebook.txt | grep real | awk '{print $1}')
	F2=$(echo $F1 | sed -e 's|0m||g' | sed -e 's|s||g' | awk '{print $1}')
	echo "$F2" >> $H/facebook1.txt
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Zabicie aplikacji facebook :)
	sleep 2
	am force-stop com.facebook.katana
	#-------------------------------------------------------------------------------------------------------------------------------------------
}

#-------------------------------------------------------------------------------------------------------------------------------------------
VFS=1      # <<<<<<<<<<<<<<< Tu wpisz wartość początkową 
#-------------------------------------------------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------------------------------------------
VFSEnd=20  # <<<<<<<<<<<<<<< Tu wpisz wartość końcową, czyli ile pomiarów ma się wykonać
#-------------------------------------------------------------------------------------------------------------------------------------------
# Pętla while wykona się tyle razy ile jest w wartości VFSEnd 

while (($VFS<=$VFSEnd)); do
    #-------------------------------------------------------------------------------------------------------------------------------------------
		tapatalk
		messenger
		facebook
		chrome
	#-------------------------------------------------------------------------------------------------------------------------------------------
    # Dodanie wyników pomiaru do pliku Wyniki.html 
	W1=$(awk "BEGIN {print $T2+$M2+$F2+$C2}")
    echo "$W1" >> Suma.txt
    echo "<tr>" >> $H/Wynik.html
    echo "<td>$T2 s</td>" >> $H/Wynik.html
    echo "<td>$M2 s</td>" >> $H/Wynik.html
    echo "<td>$F2 s</td>" >> $H/Wynik.html
    echo "<td>$C2 s</td>" >> $H/Wynik.html
    echo "<td>$W1 s</td>" >> $H/Wynik.html
    echo "</tr>" >> $H/Wynik.html
    
    # Dodawanie wartości VFS o 1
    echo "Wykonał się pomiar numer $VFS "
    VFS=$(($VFS + 1))
    # Wybudzenie ekranu telefonu
    input swipe 400 500 350 900 100
done

# Obliczanie średnich
#	Oblicz=$(cat $1| awk '{ sum += $1 } END { print sum }' )
#	cat oblicz.txt |awk '{printf "%.2f \n", $1/$2}' > $1
#	}

T3=$(cat tapatalkpro1.txt | awk '{ sum += $1 } END { print sum }' | awk '{printf "%.2f \n", $1/20}')
M3=$(cat messenger1.txt | awk '{ sum += $1 } END { print sum }' | awk '{printf "%.2f \n", $1/20}')
C3=$(cat chrome1.txt | awk '{ sum += $1 } END { print sum }' | awk '{printf "%.2f \n", $1/20}')
F3=$(cat facebook1.txt | awk '{ sum += $1 } END { print sum }' | awk '{printf "%.2f \n", $1/20}')
W2=$(cat Suma.txt | awk '{ sum += $1 } END { print sum }' | awk '{printf "%.2f \n", $1/20}')

# Dodawanie średnich na końcu tabeli
    echo "<tr>" >> $H/Wynik.html
    echo "<td>Średnio</td>" >> $H/Wynik.html
    echo "<td>Średnio</td>" >> $H/Wynik.html
    echo "<td>Średnio</td>" >> $H/Wynik.html
    echo "<td>Średnio</td>" >> $H/Wynik.html
    echo "<td>Średnio</td>" >> $H/Wynik.html
    echo "</tr>" >> $H/Wynik.html
    echo "<tr>" >> $H/Wynik.html
    echo "<td>$T3 s</td>" >> $H/Wynik.html
    echo "<td>$M3 s</td>" >> $H/Wynik.html
    echo "<td>$F3 s</td>" >> $H/Wynik.html
    echo "<td>$C3 s</td>" >> $H/Wynik.html
    echo "<td>$W2 s</td>" >> $H/Wynik.html
    echo "</tr>" >> $H/Wynik.html
    echo "</table>" >> $H/Wynik.html
    
# Obiczenie ile czasu zajeło przeprowaczenie testów.
Czas2=$(date +%s)
Sek=$(($Czas2 - $Czas1))
echo "<br>" >> $H/Wynik.html
echo "<br>" >> $H/Wynik.html
echo "<hr>" >> $H/Wynik.html
echo "<h4>Czas wykonania pomiaru to: $Sek sekund/y</h4>" >> $H/Wynik.html
echo "<hr>" >> $H/Wynik.html
echo "</body>" >> $H/Wynik.html
echo "</html>" >> $H/Wynik.html


    # Wybudzenie ekranu telefonu
    input swipe 400 500 350 900 100
    
am start -d "file:///$H/Wynik.html" -t "text/html" -a android.intent.action.VIEW

