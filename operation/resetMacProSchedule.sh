#!/bin/bash

source ../env.sh

options=""

if [ -z "$ROUTERIP" ] || [ -z "$ROUTERUSER" ]; then
  echo "Either ROUTERIP or ROUTERUSER not defined, or both not defined."
  exit $LINENO
fi

if [ ! -z "$ROUTERPUBLICKEY" ]; then
  options="-i $ROUTERPUBLICKEY "
fi

echo "Schedule for Phelan's Laptop"
dailySchedule="7h00m-22h30m"
# weekDays=`date +%a |tr [A-Z] [a-z]`
name="MacPro"
weekDays="sun mon tue wed thu fri sat"
for w in $weekDays
do
  ssh $options $ROUTERUSER@$ROUTERIP "/ip kid-control set ${w}=\"${dailySchedule}\" [/ip k find where name~\"${name}\"]"
done


echo "Schedule for Bing's iPhone"
dailySchedule="7h00m-22h30m"
# weekDays=`date +%a |tr [A-Z] [a-z]`
name="Bing's iPhone"
weekDays="sun mon tue wed thu fri sat"
for w in $weekDays
do
  ssh $options $ROUTERUSER@$ROUTERIP "/ip kid-control set ${w}=\"${dailySchedule}\" [/ip k find where name~\"${name}\"]"
done

ssh $options $ROUTERUSER@$ROUTERIP "/ip kid-control print"
