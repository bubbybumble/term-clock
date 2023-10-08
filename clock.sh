#!/bin/bash

function cleanup() {
  tput cnorm
}

trap cleanup EXIT

tput civis

# Get weather data every 4 hours
TIMER=240 
DURATION=240

MINUTE=-1

DIVIDER="\n--------------------------------------------------------------------------------\n" # Divider between displayed info, 80 chars


while true 
do 
  CURRENT_MINUTE=$(date +"%M")
  if [ "$CURRENT_MINUTE" != "$MINUTE" ]
  then
    MINUTE=$CURRENT_MINUTE
    HOUR=$(date +"%H")
    M="am"
    if [ "$((HOUR))" -gt 12 ]
    then
      M="pm"
      HOUR=$((HOUR - 12))
    fi
    tput clear
    date +"$HOUR : $MINUTE $M" | figlet
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
    echo -e "$TEMPERATURE F\n"
    echo $FORECAST

  fi

  sleep 1
done

