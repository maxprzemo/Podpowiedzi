#!/bin/bash
#  test11.sh
#  
#  Copyright 2016 maxprzemo <maxprzemo@maxprzemoPC>
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  
#  


#-------------------------------------------------------------------------------------------------------------------------------------------
# Gdzie ja jestem !!!
# Określa położenie skryptu i umieszcza ją w zmiennej H oraz HO.
H=`pwd`
HO=`pwd`/out

# Czyszczenie starych plików
# Tworzenie folderu z wynikami tymczasowymi
if [ -d out ]; then
rm -rf out
mkdir out
fi

# Pobranie nazwy modelu telefonu i umieszczenie jej w zmiennej Model.
Model=$(adb devices -l | grep "model"| awk '{print $5}' | sed 's/model://g')


# Tworzenie pliku w którym będą wyniki pomiarów.
cat << EOF > $HO/Wynik.txt
-------------------------------------------------------------------------------------------------------
|Telefon : $Model                                                                                       
-------------------------------------------------------------------------------------------------------
|Chrome             |Keep                |Tapatalk           |Gmail               |Razem               |
-------------------------------------------------------------------------------------------------------
|Czas               |Czas                |Czas               |Czas                |Czas                |
-------------------------------------------------------------------------------------------------------
EOF

keep='com.google.android.keep keep1 keep2 com.google.android.keep/.activities.BrowseActivity'
chrome='com.android.chrome chrome1 chrome2 com.android.chrome/com.google.android.apps.chrome.Main'
tapatalk='com.quoord.tapatalkpro.activity tapatalk1 tapatalk2 com.quoord.tapatalkpro.activity/com.quoord.tapatalkpro.activity.directory.ics.AccountEntryActivity'
gmail='com.google.android.gm gm1 gm2 com.google.android.gm/.ConversationListActivityGmail'

pomiar() {
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Zabicie aplikacji jeśli pracuje :) Tylko ją wyłącza a nie odinstalowuje .
	adb -d shell su -c "am force-stop $1"
	sleep 1
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Uruchomienie oraz pomiar czasu uruchamiania aplikacji. Zapisanie wyniku do pliku $2.txt
	adb -d shell su -c "time am start -W $4" > $HO/$2.txt
	# Pobieranie linijki z pomiarem czasu i zapisanie jej do zmiennej C1 .
	C1=$(cat $HO/$2.txt | grep real | awk '{print $1}')
	C2=$(echo $C1 | sed -e 's|0m||g' | sed -e 's|s||g' | awk '{print $1}')
	echo $C2 >> $HO/$3.txt
	#-------------------------------------------------------------------------------------------------------------------------------------------
	# Zabicie aplikacji :)
	sleep 1
	adb -d shell su -c "am force-stop $1"
	#-------------------------------------------------------------------------------------------------------------------------------------------
}

Pstart=1
#-------------------------------------------------------------------------------------------------------------------------------------------
Pkoniec=10  # <<<<<<<<<<<<<<< Tu wpisz wartość końcową. Wykona się tyle pomiarów dla każdej aplikacji ile jest w tej wartości
#-------------------------------------------------------------------------------------------------------------------------------------------


while (($Pstart<=$Pkoniec)); do
    #-------------------------------------------------------------------------------------------------------------------------------------------
	pomiar $chrome
	Chr=$(echo $C2)
	pomiar $keep
	Kee=$(echo $C2)
	pomiar $tapatalk
	Tap=$(echo $C2)
	pomiar $gmail
	Gma=$(echo $C2)
	#-------------------------------------------------------------------------------------------------------------------------------------------
    ## Dodanie wyników pomiaru do pliku Wyniki.txt 
    W1=$(awk "BEGIN {print $Chr+$Kee+$Tap+$Gma}")
    echo "$W1" >> $HO/Suma.txt
    echo "$Chr $Kee $Tap $Gma $W1" > $HO/Tabela.txt
    awk '{printf "|%-19s|%-20s|%-19s|%-20s|%-20s|\n",$1,$2,$3,$4,$5}' $HO/Tabela.txt >> $HO/Wynik.txt
    ##-------------------------------------------------------------------------------------------------------------------------------------------
    ## Dodawanie wartości VFS
    Pstart=$(($Pstart + 1))
    ##-------------------------------------------------------------------------------------------------------------------------------------------

done

cat << EOF >> $HO/Wynik.txt
-------------------------------------------------------------------------------------------------------
|Średnio            |Średnio             |Średnio            |Średnio             |Średnio             |
-------------------------------------------------------------------------------------------------------
EOF

Srednia() {
	# Obliczanie średnich
	T3=$(cat $HO/$1.txt | awk '{ sum += $1 } END { print sum }')
	T4=$(echo "scale = 2; ${T3} / ${Pkoniec}" | bc)
	echo $T4 > $HO/Sr$1.txt
	}

Srednia chrome2
SrChr=$(echo $T4)
Srednia keep2
SrKee=$(echo $T4)
Srednia tapatalk2
Srtap=$(echo $T4)
Srednia gm2
SrGma=$(echo $T4)
Srednia Suma
SrSum=$(echo $T4)

    echo "$SrChr $SrKee $Srtap $SrGma $SrSum" > $HO/Tabela.txt
    awk '{printf "|%-19s|%-20s|%-19s|%-20s|%-20s|\n",$1,$2,$3,$4,$5}' $HO/Tabela.txt >> $HO/Wynik.txt

# ps | grep com.android.google.keep | awk '{print $2}' | xargs kill
