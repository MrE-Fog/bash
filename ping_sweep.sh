#!/bin/bash

for i in {1..254}
do
	ping -c 1 192.168.1.$i | grep ^64 | awk '{print $4}' | cut -d ":" -f 1 &
done
