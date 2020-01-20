#!/bin/sh

OLD=`stat -f %m $1`
REBU="-- rebuilding ------------------------------------------------------------------"
while true
do
	NEW=`stat -f %m $1`
	[ $NEW -gt $OLD ] && echo "" && echo $REBU && echo "" && $2
	sleep 1
	OLD=$NEW
done

