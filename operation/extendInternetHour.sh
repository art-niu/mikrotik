#!/bin/bash
# set -x
if [ $# -lt 2 ]; then
	echo "Syntax: $0 <machine name> <extend time>"
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
extendedMinutes=$2

startTime="6h00m"
echo Schedule for $machineName
dailySchedule="6h00m-22h30m"
#if [[ $machineName =~ PN* ]]; then
#	dailySchedule="${startTime}-07h30m"
#fi
kControlNumber=4
weekDays="sun mon tue wed thu fri sat"
#weekDays=`date +%a |tr [A-Z] [a-z]`

for w in $weekDays
do
  cmdLine="/ip kid-control set ${w}=\"${dailySchedule}\"  [/ip k find where name ~ \"${machineName}\"]"
  echo ${cmdLine}
  ssh $options $ROUTERUSER@$ROUTERIP ${cmdLine}
done

currentHour=`date +%H`
currentMinutes=`date +%M`
toMinutes=`expr $currentMinutes + $extendedMinutes`
overHour=`expr $toMinutes / 60`
remainMinutes=`expr $toMinutes % 60`
toHour=`expr $currentHour + $overHour`

if [ $toHour -gt 23 ]; then
        toHour=23
        remainMinutes=59
fi

day=`date +%a`
formatedDay=`echo $day|tr [A-Z] [a-z]`

cmdLine="/ip kid-control set ${formatedDay}=\"${startTime}-${toHour}h${remainMinutes}m\" [/ip k find where name ~ \"${machineName}\"]"

echo $cmdLine

# "/ip kid-control set ="7h00m-23h00m" [/ip k find where name ~ "PN - Desktop"]

# echo "/ip firewall filter set time=${currentHour}h${currentMinutes}m-${toHour}h${remainMinutes}m,${formatedDay} [/ip firewall filter find where comment~\"Allow Discord \"]"

ssh $options $ROUTERUSER@$ROUTERIP ${cmdLine}


ssh $options $ROUTERUSER@$ROUTERIP "/ip k print"

