#!/bin/env bash

#print usage help and exit
usage() { echo "Usage: $0 [-f file_path] [-a algorithm] [-d digest to compare]" 1>&2;
	  echo "Preferred algorithms are MD5, SHA3-256, and SHA3-512";
 	exit 1;
}

#gather command line args
while getopts :f:d:a: flag;
do
	case "${flag}" in
		f) filename=${OPTARG};;
		d) digest=${OPTARG};;
		a) algorithm=${OPTARG};;
		h|?) usage exit 0;;
		*) usage exit 1;;
	esac
done

#check that command line args exist
if [ -z "$1" ] || [ -z "$algorithm" ]
then
	usage;
fi

#get hash of file provided by user
hash=$(openssl dgst -$algorithm $filename | awk '{print $2}');

#return hash of file if no digest is provided by user
if [ -n "$algorithm" ] && [ -z "$digest" ]
then
	echo ""; echo "";
	echo "The hash of this file is: $hash";
	echo "";
	echo "Supply a digest with -d [digest] to validate file.";
	echo "";
	exit 0;
fi

#compare file hash with digest provided by user
if [ "$hash" = "$digest" ]
then
	echo "";
	echo "The hashes match! Data valid!";
	echo "";
	exit 0;
else
	echo "";
	echo "The hashes do NOT match, data corrupted or modified!";
	echo "";
	exit 0;
fi


#Debug and test output
echo "$filename";
echo "$digest";
echo "$algorithm";
echo "$hash";
