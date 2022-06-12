#Author: PharoSec
#Description: Automates the basic startup tasks when started a new pentest box

#!/bin/bash
# tputcolors

echo "$(tput setaf 4)[+] $(tput setaf 7)Creating Directory: $(tput setaf 2)$1"
mkdir $1

echo "$(tput setaf 4)[+] $(tput setaf 7)Creating Sub-Directory: $(tput setaf 2)$1/nmap"
mkdir $1/nmap

echo "$(tput setaf 4)[+] $(tput setaf 7)Creating Sub-Directory: $(tput setaf 2)$1/enumeration"
mkdir $1/enumeration

echo "$(tput setaf 4)[+] $(tput setaf 7)Creating Sub-Directory: $(tput setaf 2)$1/shell"
mkdir $1/shell

echo "$(tput setaf 4)[+] $(tput setaf 7)Creating Sub-Directory: $(tput setaf 2)$1/priv-esc"
mkdir $1/priv-esc

read -p "$(tput setaf 3)[+] $(tput setaf 7)Enter Host IP for Intial Enumeration: " IP

echo "$(tput setaf 4)[+] $(tput setaf 7)Running Full Port Scan on $IP"

nmap -p- -Pn $IP -oA $1/nmap/full-port --open > /dev/null 2>&1

echo "$(tput setaf 2)[+] Done!"

echo "$(tput setaf 4)[+] $(tput setaf 7)Output Saved To: $(tput setaf 2)$1/nmap/full-port.*" 

echo "$(tput setaf 7)$(cat $1/nmap/full-port.nmap | grep open | grep -v Nmap | cut -f 1 -d '/' > $1/nmap/open-ports.txt)"

echo "$(tput setaf 1)[+] $(tput setaf 7)Ports Found Open:"
echo "$(tput setaf 7)$(cat $1/nmap/open-ports.txt)"
echo ""

echo "$(tput setaf 4)[+] $(tput setaf 7)Running a Service Scan on the Open Ports"
ports=$(sed -z 's/\n/,/g' $1/nmap/open-ports.txt | sed '$ s/.$//')

nmap -p $ports -Pn -sC -sV -oA $1/nmap/service-scan $IP > /dev/null 2>&1
echo "$(tput setaf 2)[+] Done!"

echo "$(tput setaf 4)[+] $(tput setaf 7)Output Saved To: $(tput setaf 2)$1/nmap/service-scan.*"

echo ""
echo "$(tput setaf 1)[+] $(tput setaf 7)Services/Versions Identified:"
echo "$(tput setaf 7)$(cat $1/nmap/service-scan.nmap | grep tcp)"

echo "$(tput setaf 2)Happy Hacking!"

