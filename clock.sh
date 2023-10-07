#!/bin/bash

function cleanup() {
  tput cnorm
}

trap cleanup EXIT

tput civis

TIMER=240
DURATION=240
DIVIDER="\n\n"

tput smkx  # Enable mouse tracking

while true 
do 
  tput clear
  date +"%H : %M : %S" | figlet
  echo -e $DIVIDER
  date +"%A, %D"
  echo -e $DIVIDER
  if [ "$TIMER" -ge "$DURATION" ]
  then
    TIMER=0
    URL=$(curl -s "https://api.weather.gov/points/35.227,-80.8431" | jq -r '.properties.forecast')
    DATA=$(curl -s "$URL" | jq -r '.properties.periods[0]')
    FORECAST=$(echo $DATA | jq -r '.detailedForecast')
    TEMPERATURE=$(echo $DATA | jq -r '.temperature')
  else
    ((TIMER++))
  fi
  echo"$TEMPERATURE F"
  echo -e $DIVIDER
  echo $FORECAST
  sleep 1
done

tput rmkx  # Disable mouse tracking