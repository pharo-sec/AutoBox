# Test Enumeration

## Full Port Scan

```bash
nmap 127.0.0.1 -p- -oA Test/nmap/full-port --open -Pn -vv
```

Which Resulted In:

|PORT|SERVICE|
|----|-------|
|8080|http-proxy|
|41037|unknown|

## Service Scan

```bash
nmap 127.0.0.1 -p 8080,41037 -sC -sV -oA Test/nmap/service-scan -Pn
```

Which Resulting In:

|PORT|SERVICE|VERSION|
|----|-------|-------|
|8080|http-proxy||
|41037|unknown||
