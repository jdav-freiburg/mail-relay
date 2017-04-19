# How to set the target address:

Create file "saslpass" with contents:
```
smtprelaypool.ispgateway.de support@jdav-freiburg.de:insertpasswordhere
```

Execute `postmap saslpass`.
See main.cf for `relayhost`.
