echo "/ip firewall filter 
 add chain=forward action=accept src-mac-address=\"20:C9:D0:DC:C3:87\" log=yes log-prefix=\"%%ADMIN-I-\" comment=\"Whitelisted MAC\" place-before=1 "
