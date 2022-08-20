# BOX-NAME Enumeration

## Full Port Scan

I ran the following command:

```bash
FULL-PORT
```

Which resulted in the following:

|Port|Service|
|---|---|
|22|ssh|
|80|http|
|110|pop3|
|139|netbios-ssn|
|143|imap|
|445|microsoft-ds|
|993|imaps|
|995|pop3s|

## Service Scan

```bash
SERVICE-SCAN
```

And found the following:

|Port|Service|Version|
|---|---|--|
|22|ssh|OpenSSH 4.6p1 Debian 5build1 (protocol 2.0)|
|80|http|Apache httpd 2.2.4 ((Ubuntu) PHP/5.2.3-1ubuntu6)|
|110|pop3|Dovecot pop3d|
|139|netbios-ssn|Samba smbd 3.X - 4.X (workgroup: MSHOME)|
|143|imap|Dovecot imapd|
|445|netbios-ssn|Samba smbd 3.0.26a (workgroup: MSHOME)|
|993|ssl/imap|Dovecot imapd|
|995|ssl/pop3|Dovecot pop3d|

## Key Findings
