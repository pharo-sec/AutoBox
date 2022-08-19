# AutoBox Bash Script
I got tired of running the same commands over and over again and decided to automate first few steps when starting on a new pentest lab machine. I create Autobox to create a directory named after the machine I'm attacking as well create several sub-driectories to help organize my files while working.

The script currently accepts two total arguments:

- The name of the machine
- The IP of the machine

It will then run a full port scan nmap against the host, save the output, extract the open ports, run an nmap service scan (-sV -sC), and finally save the output of the commands to loca files and generate markdown files to help organize note-taking.

I also added a little scp command that prints after the script completes to help move the files to another machine if need be (I take my notes on my Windows machine, but work in a Kali VM, so this is really helpful for me)

# Usage
```shell
$ ./AutoBox.sh [MACHINE]
```
It will then prompt for the IP of the machine

![Script Running](/.src/script-running.png "Running the Script")

It will create a directory within your current working directory named after the machine name given, inside this directory it creates several subdirectories:

- nmap: The nmap commands store their outputs here
- enumeration: A place to store your enumeration tools output
- shell: Files and methods required to gain a foothold on the machine
- priv-esc: Files and methods required to escalate privileges on the machine

![Created Directories](/.src/created-directory.png "Created Directories")

The script also creates template markdown files for each step of in the attack chain

![Example Markdown File](/.src/created-markdown-file.png "Sample Markdown File")

Rendered Example

![Rendered Markdown File](/.src/rendered-output.png "Rendered File")

# Future Upgrades
I want to add more logic to the script to run more enumeration commands depending on the services identified, specifically:

- SMB
    - enum4linux
    - nmap SMB vuln scan
    - smbmap
- HTTP
    - Directory Bruteforce
    - Nikto
