#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Syntax: $0 <dns name file>"
  exit $LINENO
fi

dnsFile=$1
action=$2

addressListTimeout="30d"

addressListName=${dnsFile%.*}_ips
addressListName=${addressListName##*/}
tgtDomains=`cat ${dnsFile}`

if [ ! -z "$action" ]; then

  case $action in
    run|RUN|-e|-r|exec|execute|execution)
      exec="run"
      ;;
    *)
      echo "Unknown parameter $action"
      ;;
  esac
fi

echo '
:global inputRules [/ip f f find chain="input"]
:global firstRule [:pick $inputRules 0]
:global sequenceOfFirstRule [:pick $firstRule 1 5 ]
'

sequenceOfFirstRule=20

# Create Dynamic IP List
for i in $tgtDomains
do 
  tgtHostName=`echo $i | tr [A-Z] [a-z]`
  TGTHOSTNAME=`echo $i | tr [a-z] [A-Z]`
  cmdLine="/ip firewall filter add chain=forward action=add-dst-to-address-list protocol=tcp address-list=${addressListName} address-list-timeout=$addressListTimeout dst-port=443 log=yes log-prefix=\"%%IPLIST-I-\" tls-host=*${tgtHostName}* comment=\"Dynamically create ip list: ${addressListName} - ${tgtHostName}\" place-before=$sequenceOfFirstRule"
  echo $cmdLine

#  if [ ! -z "$ROUTERIP" ] && [ ! -z "$ROUTERUSER" ]; then
#    ssh ${ROUTERUSER}@${ROUTERIP} $cmdLine
#  fi
done
