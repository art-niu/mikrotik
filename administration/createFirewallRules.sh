echo "/ip firewall filter 
add chain=input action=accept src-address-list=admins_ips log=yes log-prefix=\"%%ADMIN-I-\" place-before=1 comment=\"Allow admin_ips\" 
add chain=input action=accept dst-address-list=admins_ips log=yes log-prefix=\"%%ADMIN-I-\" place-before=1 comment=\"Allow admin_ips\" "
