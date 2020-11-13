#!/bin/bash

cat /var/log/syslog | grep -E '[E|e]rror|ERROR' > err_rep.log
cat /var/log/syslog.1 | grep -E '[E|e]rror|ERROR' >> err_rep.log
