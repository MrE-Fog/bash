# bash

This listing contains multiple bash scripts.
Some are for testing purposes, others are for convenience.

#error_report.sh 

This script does nothing but collect error messages from syslog and syslog.1 into a single file.

#ping_sweep.sh

Ping sweep looks for active nodes on a subnet.
It is currently configured to 192.168.1.x but could easily be modified to use any other.

#checksum.sh

checksum.sh is a wrapper around the OpenSSL utility.
If given a file and an algorithm it will return the hash of the file.
If given a file, algorithm, and digest it will generate a new hash from the given file and compare it to the digest using the selected algorithm.