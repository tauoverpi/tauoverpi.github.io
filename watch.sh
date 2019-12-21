#!/bin/sh

OLD=`stat -f %m $1`
while true
do
	NEW=`stat -f %m $1`
	[ $NEW -gt $OLD ] && echo "rebuilding" && $2
	sleep 1
	OLD=$NEW
done

