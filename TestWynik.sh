#!/bin/bash


FILE=Wynik.txt
while read line; do
     
     pak=$(echo $line | sed -e 's/|//g' | awk '{print $1}')
     echo $pak
     echo $line | awk '{ print $3, $5, $7, $9, $11, $13}' | awk '{ for(i=1; i<=NF;i++) j+=$i; print j; j=0 }' > suma.txt
     sums=$(cat suma.txt)
     echo $sums
     Pkoniec=6
     T4=$(echo "scale = 2; ${sums} / ${Pkoniec}" | bc | awk '{printf "%.2f \n", $1}')
     sed -i "/$pak/ s/$/ Średnio : $T4 /" Wynik.txt
     

done < $FILE

     T18=$(cat Wynik.txt | awk '{ sum += $17 } END { print sum }')
     T20=$(cat Wynik.txt | wc -l)
     T35=$(echo "scale = 2; ${T18} / ${T20}" | bc | awk '{printf "%.2f \n", $1}')
     echo "-----------------------------------------------------------------------------------------------------------" >> Wynik.txt
     echo "                                                                            Średnia całkowita    |  $T35" >> Wynik.txt
     echo "-----------------------------------------------------------------------------------------------------------" >> Wynik.txt
