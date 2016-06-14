#!/bin/bash

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
else
mkdir out
fi

clear
echo "-------------------------------------------------------------------------------------------------------"
echo ""
echo ""
echo ""
echo " >>>>>>>>>>>> Podłącz telefon do komputera <<<<<<<<<<<<"
echo ""
echo ""
echo ""
read -p "Naciśnij [Enter] żeby kontynuować..."
clear

ADBdevices=`adb devices | sed '/./!d' | wc -l`

    if [[ ${ADBdevices} -le 1 ]]; then
        clear
        echo "-------------------------------------------------------------------------------------------------------"
        echo ""
        echo ""
        echo ""
        echo "Nie znaleziono połączenia adb !"
        echo ""
        echo ""
        echo ""
        echo "Program zostanie zamknięty"
        read -p "Naciśnij [Enter] żeby kontynuować..."
        exit 1
        clear ;
    elif [[ ${ADBdevices} -ge 3 ]] ; then 
        clear
        echo "-------------------------------------------------------------------------------------------------------"
        echo ""
        echo ""
        echo ""
        echo "Wykryto więcej niż jedno urządzenie podpięte do komputera"
        echo "Odłącz zbędne urządzenia"
        echo ""
        echo ""
        echo ""
        echo "Program zostanie zamknięty"
        read -p "Naciśnij [Enter] żeby kontynuować..."
        exit 1
        clear
    else
        echo "-------------------------------------------------------------------------------------------------------"
        echo ""
        echo ""
        echo ""
        echo " >>>>>>>> Znaleziono połączenia adb <<<<<<<<<"
        echo ""
        echo ""
        # Pobranie nazwy modelu telefonu i umieszczenie jej w zmiennej Model.
        Model=$(adb devices -l | grep "model"| awk '{print $5}' | sed 's/model://g')
        echo "$Model" > $HO/Model.txt
        echo ""
        echo ""
        echo "Twój model telefonu to : ${Model}"
        echo "-------------------------------------------------------------------------------------------------------"
        read -p "Naciśnij [Enter] żeby kontynuować..."
        echo ""
        clear
    fi;

clear
Manufacturer=$(adb -d shell su -c 'getprop ro.product.manufacturer')
read ileRAM < <(adb -d shell su -c 'cat proc/meminfo' | grep MemTotal | awk '{print $2}')
Sram=$(echo "scale=3; $ileRAM / 1024" | bc)
read ileZRAM < <(adb -d shell su -c 'cat proc/meminfo' | grep SwapTotal | awk '{print $2}')
Szram=$(echo "scale=3; $ileZRAM / 1024" | bc)
# Tworzenie pliku w którym będą wyniki pomiarów.
cat << EOF > $HO/Wynik.txt
-------------------------------------------------------------------------------------------------------
|Producent : $Manufacturer
|Model : $Model
|Ilość pamięci RAM : $Sram Mb
|Ilość pamięci ZRAM : $Szram Mb
-------------------------------------------------------------------------------------------------------
|Chrome             |Keep                |Tapatalk           |Gmail               |Razem               |
-------------------------------------------------------------------------------------------------------
|Czas               |Czas                |Czas               |Czas                |Czas                |
-------------------------------------------------------------------------------------------------------
EOF

cat << EOF
-------------------------------------------------------------------------------------------------------
|Producent : $Manufacturer
|Model : $Model
|Ilość pamięci RAM : $Sram Mb
|Ilość pamięci ZRAM : $Szram Mb
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
    awk '{printf "|%-19s|%-20s|%-19s|%-20s|%-20s|\n",$1,$2,$3,$4,$5}' $HO/Tabela.txt > $HO/WynikE.txt
    Term=$(cat $HO/WynikE.txt)
    echo "$Term"
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

cat << EOF
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
	awk '{printf "|%-19s|%-20s|%-19s|%-20s|%-20s|\n",$1,$2,$3,$4,$5}' $HO/Tabela.txt > $HO/WynikE.txt
    Term=$(cat $HO/WynikE.txt)
    echo "$Term"
# ps | grep com.android.google.keep | awk '{print $2}' | xargs kill
data=`date +"%d-%m-%Y-%H:%M"`
# model=$(adb devices -l | grep "model"| awk '{print $5}' | sed 's/model://g')

echo "-------------------------------------------------------------------------------------------------------"
echo ""
echo "-------------------------------------------------------------------------------------------------------"
echo "Koniec pomiaru !"
echo "Wykonano : ${Pkoniec} pomiarów"
if [ -d Wyniki ]; then
echo "Plik z wynikami został zapisany w folderze Wyniki/Wynik_${Model}_${data}.txt"
else
mkdir Wyniki
echo "Plik z wynikami został zapisany w folderze Wyniki/Wynik_${Model}_${data}.txt"
fi
echo "-------------------------------------------------------------------------------------------------------"
cp $HO/Wynik.txt Wyniki/Wynik_${Model}_${data}.txt

