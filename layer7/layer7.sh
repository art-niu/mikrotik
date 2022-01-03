if [ $# -lt 1 ]; then
  echo "$0 <dns file name>"
  exit $LINENO
fi

dnsFile=$1 
if [ ! -f $dnsFile ]; then
  echo "Cannot find file $dnsFile"
  exit $LINENO
fi


layer7Re="^.+("
dnsNames=`cat $dnsFile`
for d in $dnsNames
do
  if [ ! -z "$d" ]; then
    layer7Re="${layer7Re}${d}|"
  fi
done


layer7Re="${layer7Re%|}"
layer7Re="${layer7Re}).*\\$"


shortFileName=${dnsFile%.*}
shortName=${shortFileName##*/}
# echo $layer7Re

layer7Name="Layer 7 Regexp: ${shortName}"
echo "/ip firewall layer7-protocol add name=\"${layer7Name}\" regexp=\"${layer7Re}\""
# echo "/ip firewall filter add action=reject chain=forward layer7-protocol=\"${layer7Name}\" comment=\"${layer7Name}\"  place-before=3"
echo "/ip firewall filter add action=reject chain=forward layer7-protocol=\"${layer7Name}\" comment=\"${layer7Name}\"  "
