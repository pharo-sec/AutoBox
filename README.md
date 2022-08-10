# Description
AutoBox is a small bash script to create the necessary folder structure when starting a new pentest lab (i.e. Hack the Box, Proving Grounds, etc...)

# Usage
The script currently accepts two total arguments:
- The name of the machine
- The IP of the machine 

It will create a directory within your current working directory named after the machine name given, inside this directory it creates several subdirectories:
- nmap: The nmap commands store their outputs here
- enumeration: A place to store your enumeration tools output
- shell: Files and methods required to gain a foothold on the machine
- priv-esc: Files and methods required to escalate privileges on the machine

It will then run a full port scan nmap against the host, save the output, extract the open ports, run an nmap service scan (-sV -sC), and finally save the output of that. 

```bash
$ AutoBox.sh [MACHINE]
```
