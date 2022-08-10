# Description
AutoBox is a small bash script to create the necessary folder structure when starting a new pentest lab (i.e. Hack the Box, Proving Grounds, etc...)

# Usage
The script currently accepts two total arguments:
- The name of the machine
- The IP of the machine 

It will then run a full port scan nmap against the host, save the output, extract the open ports, run an nmap service scan, and finally save the output of all of that.
