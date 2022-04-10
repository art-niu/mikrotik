#!/bin/bash
# set -x
if [ $# -lt 2 ]; then
	echo "Syntax: $0 <device tag> <extend minutes | specified time>"
	echo "$0 HOME 270"
	echo "$0 GAME 23:30"
	exit $LINENO
fi

source ../env.sh

options=""

if [ -z "$ROUTERIP" ] || [ -z "$ROUTERUSER" ]; then
  echo "Either ROUTERIP or ROUTERUSER not defined, or both not defined."
  exit $LINENO
fi

if [ ! -z "$ROUTERPUBLICKEY" ]; then
  options="-i $ROUTERPUBLICKEY "
fi

machineName=$1
extendedTo=$2

startTime="6h00m"
echo Schedule for $machineName
dailySchedule="6h00m-22h30m"
kControlNumber=4
weekDays="sun mon tue wed thu fri sat"

currentHour=`date +%H`
currentMinutes=`date +%M`

timeFormat="([0-9]*):([0-9]*)"
if [[ $extendedTo =~ $timeFormat ]]; then
  toHour=${BASH_REMATCH[1]}
  remainMinutes=${BASH_REMATCH[2]}
else
  toMinutes=`expr $currentMinutes + $extendedTo`
  overHour=`expr $toMinutes / 60`
  remainMinutes=`expr $toMinutes % 60`
  toHour=`expr $currentHour + $overHour`
fi
if [ $toHour -gt 23 ]; then
        toHour=23
        remainMinutes=59
fi

ssh $options $ROUTERUSER@$ROUTERIP "/ip k print"

day=`date +%a`
formatedDay=`echo $day|tr [A-Z] [a-z]`

cmdLine="/ip kid-control set ${formatedDay}=\"${currentHour}h${currentMinutes}m-${toHour}h${remainMinutes}m\" [/ip k find where name ~ \"${machineName}\"]"

echo $cmdLine

# echo "/ip firewall filter set time=${currentHour}h${currentMinutes}m-${toHour}h${remainMinutes}m,${formatedDay} [/ip firewall filter find where comment~\"Allow Discord \"]"

ssh $options $ROUTERUSER@$ROUTERIP ${cmdLine}

weekDays=`echo $weekDays | sed -e s/${formatedDay}//g`

for w in $weekDays
do
  cmdLine="/ip kid-control set ${w}=\"${dailySchedule}\"  [/ip k find where name ~ \"${machineName}\"]"
  echo ${cmdLine}
  ssh $options $ROUTERUSER@$ROUTERIP ${cmdLine}
done

ssh $options $ROUTERUSER@$ROUTERIP "/ip k print"

