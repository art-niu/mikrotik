
echo Schedule for Dell Laptop
dailySchedule="6h00m-22h30m"
kControlNumber=4
# weekDays="sun mon tue wed thu fri sat"
weekDays=`date +%a |tr [A-Z] [a-z]`

for w in $weekDays
do
  echo "/ip kid-control set ${w}=\"${dailySchedule}\" number=${kControlNumber}"
done

echo Schedule for P Desktop
dailySchedule="6h00m-06h30m"
kControlNumber=0
weekDays="sun mon tue wed thu fri sat"

for w in $weekDays
do
  echo "/ip kid-control set ${w}=\"${dailySchedule}\" number=${kControlNumber}"
done

echo Schedule for MacBook Pro
dailySchedule="6h00m-22h30m"
kControlNumber=6
weekDays="sun mon tue wed thu fri sat"

for w in $weekDays
do
  echo "/ip kid-control set ${w}=\"${dailySchedule}\" number=${kControlNumber}"
done

echo Schedule for Bing iPhone
dailySchedule="6h00m-22h30m"
kControlNumber=5
weekDays="sun mon tue wed thu fri sat"

for w in $weekDays
do
  echo "/ip kid-control set ${w}=\"${dailySchedule}\" number=${kControlNumber}"
done

dailySchedule="6h00m-22h30m"
kControlNumber=2
weekDays="sun mon tue wed thu fri sat"

echo Schedule for iPad
for w in $weekDays
do
  echo "/ip kid-control set ${w}=\"${dailySchedule}\" number=${kControlNumber}"
done


