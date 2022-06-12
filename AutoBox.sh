#Author: PharoSec
#Description: Automates the basic startup tasks when started a new pentest box

#!/bin/bash
# tputcolors

RED=$(tput setaf 1)
YELLOW=$(tput setaf 3)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
WHITE=$(tput setaf 7)

if [ $# -eq 0 ]; then
    echo "$RED[+]$WHITE No Name Provided"
    read -p "$YELLOW[+]$WHITE Please Provide the Machine Name: " BOX
else
	BOX = $1
fi

echo "$BLUE[+]$WHITE Creating Directory:$GREEN $BOX"
mkdir $BOX

echo "$BLUE[+]$WHITE Creating Sub-Directory:$GREEN $BOX/nmap"
mkdir $BOX/nmap

echo "$BLUE[+]$WHITE Creating Sub-Directory:$GREEN $BOX/enumeration"
mkdir $BOX/enumeration

echo "$BLUE[+]$WHITE Creating Sub-Directory:$GREEN $BOX/shell"
mkdir $BOX/shell

echo "$BLUE[+]$WHITE Creating Sub-Directory:$GREEN $BOX/priv-esc"
mkdir $BOX/priv-esc

read -p "$YELLOW[+]$WHITE Enter Host IP for Intial Enumeration: " IP

echo "$BLUE[+]$WHITE Running Full Port Scan on $IP"

nmap -p- -Pn $IP -oA $BOX/nmap/full-port --open > /dev/null 2>&1

echo "$GREEN[+] Done!"

echo "$BLUE[+]$WHITE Output Saved To:$GREEN $BOX/nmap/full-port.*" 

echo "$WHITE$(cat $BOX/nmap/full-port.nmap | grep open | grep -v Nmap | cut -f 1 -d '/' > $BOX/nmap/open-ports.txt)"

echo "$GREEN[+]$WHITE Ports Found Open:"
echo "$WHITE$(cat $BOX/nmap/open-ports.txt)"
echo ""

echo "$BLUE[+]$WHITE Running a Service Scan on the Open Ports"
ports=$(sed -z 's/\n/,/g' $BOX/nmap/open-ports.txt | sed '$ s/.$//')

nmap -p $ports -Pn -sC -sV -oA $BOX/nmap/service-scan $IP > /dev/null 2>&1
echo "$GREEN[+] Done!"

echo "$BLUE[+]$WHITE Output Saved To:$GREEN $BOX/nmap/service-scan.*"

echo ""
echo "$GREEN[+]$WHITE Services/Versions Identified:"
echo "$WHITE$(cat $BOX/nmap/service-scan.nmap | grep tcp)"

echo $GREEN"Happy Hacking!"

