#!/bin/bash
if [ $# -lt 1 ]; then
  echo "Syntax: $0 <svc name one word>"
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

cmdLine="/ip firewall filter disable [/ip firewall filter find where comment~\"Block ${svckeyword}\"]"

echo $cmdLine

ssh $options $ROUTERUSER@$ROUTERIP ${cmdLine}
