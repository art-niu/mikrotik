#!/bin/bash
# set -x
if [ $# -lt 2 ]; then
	echo "Syntax: $0 <device tag> <extend minutes | specified time>"
	echo "$0 HOME 270"
	echo "$0 GAME 22:00"
	exit $LINENO
fi

./setTimeZone.sh

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

startTime="5h30m"
echo Schedule for $machineName
dailySchedule="5h30m-22h30m"
kControlNumber=4
weekDays="sun mon tue wed thu fri sat"

currentHour=`date +%H`
currentMinutes=`date +%M`

rangeFormat="([0-9]*):([0-9]*)-([0-9]*):([0-9]*)"
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
        toHour1=23
        remainMinutes1=59
else
  toHour1=$toHour
  remainMinutes1=$remainMinutes
fi

ssh $options $ROUTERUSER@$ROUTERIP "/ip k print"

day=`date +%a`
formatedDay=`echo $day|tr [A-Z] [a-z]`

currentHour=0
currentMinutes=0
cmdLine="/ip kid-control set ${formatedDay}=\"${currentHour}h${currentMinutes}m-${toHour1}h${remainMinutes1}m\" [/ip k find where name ~ \"${machineName}\"]"

echo $cmdLine

# echo "/ip firewall filter set time=${currentHour}h${currentMinutes}m-${toHour1}h${remainMinutes1}m,${formatedDay} [/ip firewall filter find where comment~\"Allow Discord \"]"

ssh $options $ROUTERUSER@$ROUTERIP ${cmdLine}

weekDays=`echo $weekDays | sed -e s/${formatedDay}//g`

for w in $weekDays
do
  cmdLine="/ip kid-control set ${w}=\"${dailySchedule}\"  [/ip k find where name ~ \"${machineName}\"]"
  echo ${cmdLine}
  ssh $options $ROUTERUSER@$ROUTERIP ${cmdLine}
done

if [ $toHour -gt 23 ]; then
  toHour2=`expr $toHour - 24`
  day=`date -v +1d +%a`
  formatedDay=`echo $day|tr [A-Z] [a-z]` 
  cmdLine="/ip kid-control set ${formatedDay}=\"${currentHour}h${currentMinutes}m-${toHour2}h${remainMinutes}m\" [/ip k find where name ~ \"${machineName}\"]"

  echo $cmdLine
  ssh $options $ROUTERUSER@$ROUTERIP ${cmdLine}
fi

ssh $options $ROUTERUSER@$ROUTERIP "/ip k print"

