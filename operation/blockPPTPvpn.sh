#!/bin/bash
# The script is to block VPNs
source ../env.sh

options=""

if [ -z "$ROUTERIP" ] || [ -z "$ROUTERUSER" ]; then
  echo "Either ROUTERIP or ROUTERUSER not defined, or both not defined."
  exit $LINENO
fi

if [ ! -z "$ROUTERPUBLICKEY" ]; then
  options="-i $ROUTERPUBLICKEY "
fi

cmdLine="/ip firewall filter add chain=forward protocol=gre action=reject reject-with=icmp-protocol-unreachable log=yes log-prefix=\"%%VPN-I-\" comment=\"Block vpn\""

ssh $options $ROUTERUSER@$ROUTERIP ${cmdLine}

# Allow vpn L2TP, usually not needed.
cmdLine='/ip firewall filter
add action=accept chain=input in-interface=ether1 protocol=ipsec-esp \
    comment="allow L2TP VPN (ipsec-esp)" place-before=1
add action=accept chain=input dst-port=500,1701,4500 in-interface=ether1 protocol=udp \
    comment="allow L2TP VPN (500,4500,1701/udp)"  place-before=1'

# Block vpn L2TP
cmdLine="/ip firewall filter add action=drop chain=input in-interface=ether1 protocol=ipsec-esp comment=\"Block vpn L2TP (ipsec-esp)\"  place-before=1"
ssh $options $ROUTERUSER@$ROUTERIP ${cmdLine}

cmdLine="/ip firewall filter add action=drop chain=input dst-port=500,1701,4500 in-interface=ether1 protocol=udp comment=\"Block vpn L2TP (500,4500,1701/udp)\" place-before=1"

ssh $options $ROUTERUSER@$ROUTERIP ${cmdLine}
