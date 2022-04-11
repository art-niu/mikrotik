source ../env.sh

options=""

cmdLine="/ip k print"
ssh $options $ROUTERUSER@$ROUTERIP ${cmdLine}
