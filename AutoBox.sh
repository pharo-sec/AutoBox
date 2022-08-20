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

cp -r ~/md-templates ./$BOX-md
mv ./$BOX-md/"05 - Enumeration.md" ./$BOX-md/"05 - $BOX Enumeration.md"
##### Creating Overview File #####

sed -i "s/BOX-NAME/$BOX/g" ./$BOX-md/"00 - Overview.md"
sed -i "s/BOX-IP/$IP/g" ./$BOX-md/"00 - Overview.md"

##### Creating the Enumeration File #####
echo "# $BOX Enumeration" > ./$BOX-md/"05 - $BOX Enumeration.md"
echo '' >> ./$BOX-md/"05 - $BOX Enumeration.md"

echo "## Full Port Scan" >> ./$BOX-md/"05 - $BOX Enumeration.md"
echo '' >> ./$BOX-md/"05 - $BOX Enumeration.md"

echo '```bash' >> ./$BOX-md/"05 - $BOX Enumeration.md"
echo "nmap ${IP} -p- -oA $BOX/nmap/full-port --open -Pn -vv" >> ./$BOX-md/"05 - $BOX Enumeration.md"
echo '```' >> ./$BOX-md/"05 - $BOX Enumeration.md"
echo '' >> ./$BOX-md/"05 - $BOX Enumeration.md"

echo "Which Resulted In:" >> ./$BOX-md/"05 - $BOX Enumeration.md"
echo '' >> ./$BOX-md/"05 - $BOX Enumeration.md"

echo "|PORT|SERVICE|" >> ./$BOX-md/"05 - $BOX Enumeration.md" 
echo "|----|-------|" >> ./$BOX-md/"05 - $BOX Enumeration.md"
cat $BOX/nmap/full-port.nmap | grep /tcp | awk '{print $1,$3}' | sed 's/\/tcp /|/g' | sed 's/^/|/' | sed 's/$/|/g' >> ./$BOX-md/"05 - $BOX Enumeration.md"
echo '' >> ./$BOX-md/"05 - $BOX Enumeration.md"

echo "## Service Scan" >> ./$BOX-md/"05 - $BOX Enumeration.md"
echo '' >> ./$BOX-md/"05 - $BOX Enumeration.md"

echo '```bash' >> ./$BOX-md/"05 - $BOX Enumeration.md"
echo "nmap $IP -p $ports -sC -sV -oA $BOX/nmap/service-scan -Pn" >> ./$BOX-md/"05 - $BOX Enumeration.md"
echo '```' >> ./$BOX-md/"05 - $BOX Enumeration.md"
echo '' >> ./$BOX-md/"05 - $BOX Enumeration.md"

echo "Which Resulting In:" >> ./$BOX-md/"05 - $BOX Enumeration.md"
echo '' >> ./$BOX-md/"05 - $BOX Enumeration.md"

echo "|PORT|SERVICE|VERSION|" >> ./$BOX-md/"05 - $BOX Enumeration.md" 
echo "|----|-------|-------|">> ./$BOX-md/"05 - $BOX Enumeration.md"
cat $BOX/nmap/service-scan.nmap | grep /tcp | awk '{$2=$4=""; print}' | sed 's/\/tcp  /|/g' | sed 's/^/|/' | sed 's/$/|/g' | sed -e 's/\s\+/|/' >> ./$BOX-md/"05 - $BOX Enumeration.md"

##### Transferring Files to Windows #####
echo "$GREEN[+]$WHITE Run the Following Command to Copy Files to Your Machine:" 
echo "scp -r ~/$BOX-md/ user@host:'\"Path\\to\\tagert\\files\"'"

echo ''
echo $GREEN"Happy Hacking!"
