# mikrotik
Scripts and tools to administrate Mikrotik Router.
# Basic Configuration
# Authentication

brew install inetutils

$ ftp 192.168.66.1
Connected to 192.168.66.1.
220 MikroTik FTP server (MikroTik 7.1.1) ready
Name (192.168.66.1:arthurniu): admin
331 Password required for admin
Password: 
230 User admin logged in
ftp> put id_rsa.pub
200 PORT command successful
150 Opening ASCII mode data connection for 'id_rsa.pub'
226 ASCII transfer complete
419 bytes sent in 0.000172 seconds (2.32 Mbytes/s)
ftp> quit
221 Closing

Testing P 
Testing P 
Testing P 

[admin@MikroTik] > user ssh-keys import public-key-file=id_rsa.pub 

# Create IP List
# Create Layer 7 protocol reg expression
# Create firewall filters
# Use OpenDNS
# Define Schedule
# Network Flos Control

Tested by A
Tested by B