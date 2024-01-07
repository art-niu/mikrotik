# Restore Time Zone

source ../env.sh

options=""

if [ -z "$ROUTERIP" ] || [ -z "$ROUTERUSER" ]; then
  echo "Either ROUTERIP or ROUTERUSER not defined, or both not defined."
  exit $LINENO
fi

if [ ! -z "$ROUTERPUBLICKEY" ]; then
  options="-i $ROUTERPUBLICKEY "
fi

echo "
/system clock set time-zone-name=America/Toronto
"
printClockCMD="/system clock print"
resetTimeZoneCMD="/system clock set time-zone-name=America/Toronto"

echo $printClockCMD
echo $resetTimeZoneCMD

ssh $options $ROUTERUSER@$ROUTERIP ${printClockCMD}
ssh $options $ROUTERUSER@$ROUTERIP ${resetTimeZoneCMD}
ssh $options $ROUTERUSER@$ROUTERIP ${printClockCMD}
