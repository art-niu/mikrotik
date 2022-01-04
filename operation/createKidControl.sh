#!/bin/bash
# set -x
if [ $# -lt 1 ]; then
	echo "Syntax: $0 <kid control name>"
	exit $LINENO
fi

kidControlName=$1

source ../env.sh

options=""

if [ -z "$ROUTERIP" ] || [ -z "$ROUTERUSER" ]; then
  echo "Either ROUTERIP or ROUTERUSER not defined, or both not defined."
  exit $LINENO
fi

if [ ! -z "$ROUTERPUBLICKEY" ]; then
  options="-i $ROUTERPUBLICKEY "
fi

startTime="6h00m"
echo Schedule for $kidControlName

if [ -z "$KIDCONTROLSCHEDULE" ]; then
  KIDCONTROLSCHEDULE="6h00m-22h30m"
fi

schedule=""
weekDays="sun mon tue wed thu fri sat"
for w in $weekDays
do
  schedule="$schedule ${w}=\"${KIDCONTROLSCHEDULE}\""
  #schedule="$schedule tur-${w}=\"${KIDCONTROLSCHEDULE}\""
done

cmdLine="/ip kid-control add name=\"$kidControlName\" $schedule rate-limit=300M"
echo ${cmdLine}
ssh $options $ROUTERUSER@$ROUTERIP ${cmdLine}
ssh $options $ROUTERUSER@$ROUTERIP "/ip k print"

