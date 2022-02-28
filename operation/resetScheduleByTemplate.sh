#!/bin/bash
if [ $# -lt 1 ]; then
  echo "Syntax: $0 <template file>"
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

templateFile=template/$1
if [ ! -f ${templateFile} ]; then
  echo "Cannot find file: template/${templateFile}"
  exit $LINENO
fi

svcKeyWord=$1
svcKeyWord=${svcKeyWord%%.*}
svckeyword=`echo $svcKeyWord | tr [A-Z] [a-z]`
SVCKEYWORD=`echo $svcKeyWord | tr [a-z] [A-Z]`

daySchedules=`cat ${templateFile}`
for line in $daySchedules
do
  ssh $options $ROUTERUSER@$ROUTERIP "/ip kid-control set ${line} [/ip k find where name~\"${SVCKEYWORD}\"]"
  echo $line
done
cmdLine="/ip k print"
echo $cmdLine

ssh $options $ROUTERUSER@$ROUTERIP ${cmdLine}
