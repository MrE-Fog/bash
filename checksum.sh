#!/bin/env bash

#list of digest algorithms supported by OpenSSL
algorithms=(
	"blake2b512"
	"blake2s256"
	"gost"
	"md4"
	"md5"
	"rmd160"
	"sha1"
	"sha224"
	"sha256"
	"sha3-224"
	"sha3-256"
	"sha3-384"
	"sha3-512"
	"sha384"
	"sha512"
	"sha512-224"
	"sha512-256"
	"shake128"
	"shake256"
	"sm3"
)

#match input algorithm to those listed from OpenSSL help
matchAglorithm() {
	local e match="$1"
	shift
	for e; do [[ "$e" == "$match" ]] && return 0; done
	return 1
}

#print list of supported algorithms
printAlgorithms() {
	echo "";
	echo "The following algorithms are supported by OpenSSL:";
	for algo in "${algorithms[@]}"
	do
		echo "$algo";
	done
	echo "";
}

#print usage help and exit
usage() { echo "Usage: $0 [-f file_path] [-a algorithm] [-d digest to compare]" 1>&2;
	  echo "Preferred algorithms are MD5, SHA3-256, and SHA3-512" 1>&2;
	  echo "";
	  printAlgorithms;
 	exit 1;
}

#gather command line args
while getopts :f:d:a: flag;
do
	case "${flag}" in
		f) filename=${OPTARG};;
		d) digest=${OPTARG};;
		a) algorithm=${OPTARG};;
		h|?) usage;;
		*) usage;;
	esac
done

#check that command line args exist
if [[ -z $1 ]] || [[ -z $algorithm ]]
then
	usage;
fi

#see if supplied algorithm is on the OpenSSL supported digest list from openssl help
found=false

for i in "${algorithms[@]}"
do
	if [ "${i}" == "${algorithm,,}" ]
	then
		found=true;
		break;
	else
		found=false;
	fi
done
#if the algorithm choice wasn't found show help
if [ ! $found ]
then
	usage;
fi

#check that input is a valid file. If not a file call usage function.
if [[ ! -f $filename ]]
then
	usage;
fi

#get hash of file provided by user
hash=$(openssl dgst -$algorithm $filename | awk '{print $2}');

#return hash of file if no digest is provided by user
if [[ -n $algorithm ]] && [[ -z $digest ]]
then
	echo ""; echo "";
	echo "The hash of this file is: $hash";
	echo "";
	echo "Supply a digest with -d [digest] to validate file.";
	echo "";
	exit 0;
fi

#compare file hash with digest provided by user
if [[ $hash = $digest ]]
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