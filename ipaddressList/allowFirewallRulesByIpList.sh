#!/bin/bash
#This script is to create Mikrotik firewall rules to allow ${application} traffic with schedule, if you can customize the rules based on your own needs.

if [ $# -lt 1 ]; then
  echo "Usage: $0 <application ip list name>"
  echo "Example: $0 ${application_ips}"
  exit $LINENO
fi

application_ips=$1

application=${application_ips%_*}
APPLICATION=`echo $application | tr [a-z] [A-Z]`

# The first Hour to allow ${application} traffic
allowStartingHour=8
# The Minutes to start
allowStartingMinutes=0

# How many minitues allowed.
allowedDuration=10

if [ $allowStartingMinutes -lt 10 ]; then
  allowStartingMinutesString="0${allowStartingMinutes}"
fi

onlyOneRule=`expr $allowStartingHour + 1`

echo '
:global inputRules [/ip f f find chain="input"]
:global firstRule [:pick $inputRules 0]
:global sequenceOfFirstRule [:pick $firstRule 1 5 ]
'

while [ $allowStartingHour -lt $onlyOneRule ]
do
  # Calculate the ending hour and minutes of the allow duration.
  tmpMinutes=`expr $allowStartingMinutes + $allowedDuration`

  deltaHour=`expr $tmpMinutes / 60`
  endingMinuteNumber=`expr $tmpMinutes % 60`

  endingHour=`expr $allowStartingHour + $deltaHour`
  endingHour=`expr $endingHour % 24`
     
  if [ $endingMinuteNumber -lt 10 ]; then
    endingMinutes="0${endingMinuteNumber}"
  else
    endingMinutes="${endingMinuteNumber}"
  fi

  if [ $allowStartingHour -lt 10 ]; then
    hour="0${allowStartingHour}"
    echo "/ip firewall filter add action=accept chain=forward comment=\"Allow ${application} - ${hour}h${allowStartingMinutesString}m-${endingHour}h${endingMinutes}m\" time=${hour}h${allowStartingMinutesString}m-${endingHour}h${endingMinutes}m,sun,mon,tue,wed,thu,fri,sat log-prefix=${APPLICATION} src-address-list=${application_ips} place-before=\$sequenceOfFirstRule"
    echo "/ip firewall filter add action=accept chain=forward comment=\"Allow ${application} - ${hour}h${allowStartingMinutesString}m-${endingHour}h${endingMinutes}m\" time=${hour}h${allowStartingMinutesString}m-${endingHour}h${endingMinutes}m,sun,mon,tue,wed,thu,fri,sat log-prefix=${APPLICATION} dst-address-list=${application_ips} place-before=\$sequenceOfFirstRule"
  else
    if [ $endingHour -eq 0 ]; then
      # Create the rules from ${allowStartingHour}:${allowStartingMinutesString} to 23:59
      echo "/ip firewall filter add action=accept chain=forward comment=\"Allow ${application} - ${allowStartingHour}h${allowStartingMinutesString}m-23h59m\" time=${allowStartingHour}h${allowStartingMinutesString}m-23h59m,sun,mon,tue,wed,thu,fri,sat log-prefix=${APPLICATION} src-address-list=${application_ips} place-before=\$sequenceOfFirstRule"
      echo "/ip firewall filter add action=accept chain=forward comment=\"Allow ${application} - ${allowStartingHour}h${allowStartingMinutesString}m-23h59m\" time=${allowStartingHour}h${allowStartingMinutesString}m-23h59m,sun,mon,tue,wed,thu,fri,sat log-prefix=${APPLICATION} dst-address-list=${application_ips} place-before=\$sequenceOfFirstRule"
      # Create the rules from 00:00 to 00:$endingMinutes. If endingMinutes equals 0, then do nothing.
      if [ ${endingMinutes} -ne 0 ]; then
        echo "/ip firewall filter add action=accept chain=forward comment=\"Allow ${application} - 00h00m-${endingHour}h${endingMinutes}m\" time=00h00m-${endingHour}h${endingMinutes}m,sun,mon,tue,wed,thu,fri,sat log-prefix=${APPLICATION} src-address-list=${application_ips} place-before=\$sequenceOfFirstRule"
        echo "/ip firewall filter add action=accept chain=forward comment=\"Allow ${application} - 00h00m-${endingHour}h${endingMinutes}m\" time=00h00m-${endingHour}h${endingMinutes}m,sun,mon,tue,wed,thu,fri,sat log-prefix=${APPLICATION} dst-address-list=${application_ips} place-before=\$sequenceOfFirstRule"
      fi
    else
      echo "/ip firewall filter add action=accept chain=forward comment=\"Allow ${application} - ${allowStartingHour}h${allowStartingMinutesString}m-${endingHour}h${endingMinutes}m\" time=${allowStartingHour}h${allowStartingMinutesString}m-${endingHour}h${endingMinutes}m,sun,mon,tue,wed,thu,fri,sat log-prefix=${APPLICATION} src-address-list=${application_ips} place-before=\$sequenceOfFirstRule"
      echo "/ip firewall filter add action=accept chain=forward comment=\"Allow ${application} - ${allowStartingHour}h${allowStartingMinutesString}m-${endingHour}h${endingMinutes}m\" time=${allowStartingHour}h${allowStartingMinutesString}m-${endingHour}h${endingMinutes}m,sun,mon,tue,wed,thu,fri,sat log-prefix=${APPLICATION} dst-address-list=${application_ips} place-before=\$sequenceOfFirstRule"

    fi
  fi
  allowStartingHour=`expr $allowStartingHour + 1`
done

# The rules to accept application traffic

echo "
/ip firewall filter add action=accept chain=forward comment=\"Allow ${application} ingress traffic\" src-address-list=${application_ips} in-interface=bridge time= 0s-1d,sun,mon,tue,wed,thu,fri,sat  place-before=\$sequenceOfFirstRule
/ip firewall filter add action=accept chain=forward comment=\"Allow ${application} egress traffic\" dst-address-list=${application_ips} in-interface=bridge time= 0s-1d,sun,mon,tue,wed,thu,fri,sat place-before=\$sequenceOfFirstRule"

