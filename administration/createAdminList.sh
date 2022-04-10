#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Syntax: $0 <admin ip list>"
  exit $LINENO
fi

adminIpListFile=$1
if [ ! -f $adminIpListFile ]; then
  echo "Cannot find file $adminIpListFile"
  exit $LINENO
fi

source ../env.sh

options=""

cmdLine="/ip firewall address-list "

for line in $(grep -v "^#" $adminIpListFile)
do
  cmdLine="$cmdLine 
add list=admin_ips address=$line"
done

echo "$cmdLine"
ssh $options $ROUTERUSER@$ROUTERIP ${cmdLine}
