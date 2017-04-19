#!/bin/bash
service syslog-ng start
service postfix start
tail -F /var/log/mail.log
