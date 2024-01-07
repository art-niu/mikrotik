# Filter - disablement
if [ $# -lt 1 ]; then
  echo "Syntax: $0 <service keywords case senstive>"
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

serviceName=$1
echo "
/ip firewall filter print where comment~\"Allow ${serviceName}\"]
/ip firewall filter disable [/ip firewall filter find where comment~\"Allow ${serviceName}\"]
"
printFilterCMD="/ip firewall filter print where comment~\"Allow ${serviceName}\"]"
disableAllowFilterCMD="/ip firewall filter disable [/ip firewall filter find where comment~\"Allow ${serviceName}\"]"
enableDropFilterCMD="/ip firewall filter enable [/ip firewall filter find where comment~\"Block ${serviceName}\"]"

echo $enableDropFilterCMD
echo $disableAllowFilterCMD
echo $printFilterCMD

ssh $options $ROUTERUSER@$ROUTERIP ${printFilterCMD}
ssh $options $ROUTERUSER@$ROUTERIP ${disableAllowFilterCMD}
ssh $options $ROUTERUSER@$ROUTERIP ${enableDropFilterCMD}
ssh $options $ROUTERUSER@$ROUTERIP ${printFilterCMD}
