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
        BOX=$1
fi

if [ -d "$BOX" ]; then
    echo "$RED[+]$WHITE Directory Already Exists!"
else
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
fi

read -p "$YELLOW[+]$WHITE Enter Host IP for Intial Enumeration: " IP

echo "$BLUE[+]$WHITE Running Full Port Scan on $IP"

nmap $IP -p- -oA $BOX/nmap/full-port --open -Pn -vv > /dev/null &
PID=$!
i=1
sp="/-\|"
echo -n ' '
while [ -d /proc/$PID ]; do
    printf "\b${sp:i++%${#sp}:1}"
    sleep 0.2
done
printf "\b$GREEN[+]$WHITE Done!\n"

echo "$BLUE[+]$WHITE Output Saved To:$GREEN $BOX/nmap/full-port.*" 

echo "$WHITE$(cat $BOX/nmap/full-port.nmap | grep open | grep -v Nmap | cut -f 1 -d '/' > $BOX/nmap/open-ports.txt)"

if [ -s $BOX/nmap/open-ports.txt ]; then
        echo "$GREEN[+]$WHITE Ports Found Open:"
        echo "$WHITE$(cat $BOX/nmap/open-ports.txt)"
        echo ""

        echo "$BLUE[+]$WHITE Running a Service Scan on the Open Ports"
        ports=$(sed -z 's/\n/,/g' $BOX/nmap/open-ports.txt | sed '$ s/.$//')

        nmap $IP -p $ports -sC -sV -oA $BOX/nmap/service-scan -Pn > /dev/null &
        PID=$!
        i=1
        sp="/-\|"
        echo -n ' '
        while [ -d /proc/$PID ]; do
                printf "\b${sp:i++%${#sp}:1}"
                sleep 0.2
        done
        printf "\b$GREEN[+]$WHITE Done!\n"

        echo "$BLUE[+]$WHITE Output Saved To:$GREEN $BOX/nmap/service-scan.*"

        echo ""
        echo "$GREEN[+]$WHITE Services/Versions Identified:"
        echo "$WHITE$(cat $BOX/nmap/service-scan.nmap | grep tcp)"
else
        echo "$RED[+]$WHITE No Ports Open...Skipping Service Scan"
fi 

SMB=$(cat $BOX/nmap/service-scan.nmap | grep microsfot-ds)

if ! [ -z "$SMB" ]
then
    read "$YELLOW[+]$WHITE SMB Has Been Identified, Would You Like to Run SMB Enumeration?[y/n]" SMB_CON

    if [ ${SMB_CON^^} -eq 'Y']
    then
        SMBPORT1=$(cat $BOX/nmap/service-scan.nmap | grep microsoft-ssn | cut -d '/' -f 1)
        SMBPORT2=$(cat $BOX/nmap/service-scan.nmap | grep microsoft-ds | cut -d '/' -f 1)

        echo "$BLUE[+]$WHITE Running SMB Nmap Scan and Enum4Linux on $IP"

        nmap $IP -p $SMBPORT1,$SMBPORT2 --script=smb-vuln* -oA $BOX/nmap/smb-scan -Pn -vv > /dev/null &
        PID1=$!
        enum4linux -a $IP | tee -a $BOX/enumeration/enum4linux.out &
        PID2=$!
        i=1
        sp="/-\|"
        echo -n ' '
        while [ -d /proc/$PID1 || -d /proc/$PID2]; do
            printf "\b${sp:i++%${#sp}:1}"
            sleep 0.2
        done
        printf "\b$GREEN[+]$WHITE Done!\n"
    fi
fi 

echo ' '
echo $GREEN"Happy Hacking!"