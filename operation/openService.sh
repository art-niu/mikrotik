#!/bin/bash
if [ $# -lt 2 ]; then
  echo "Syntax: $0 <svc name one word> <minutes>"
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

svcKeyWord=$1
svckeyword=`echo $svcKeyWord | tr [A-Z] [a-z]`
SVCKEYWORD=`echo $svcKeyWord | tr [a-z] [A-Z]`

currentHour=`date +%H`
currentMinutes=`date +%M`
extendedMinutes=$2
toMinutes=`expr $currentMinutes + $extendedMinutes`
overHour=`expr $toMinutes / 60`
remainMinutes=`expr $toMinutes % 60`
toHour=`expr $currentHour + $overHour`

if [ $toHour -gt 23 ]; then
	toHour=23
	remainMinutes=59
fi

cmdLine="/ip firewall filter set time=${currentHour}h${currentMinutes}m-${toHour}h${remainMinutes}m,sun,mon,tue,wed,thu,fri,sat [/ip firewall filter find where comment~\"Allow ${svckeyword}\"]"

echo $cmdLine

ssh $options $ROUTERUSER@$ROUTERIP ${cmdLine}
