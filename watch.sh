#!/bin/sh

OLD=`stat -f %m $1`
REBU="-- rebuilding ------------------------------------------------------------------"
DONE="-- done ------------------------------------------------------------------------"
while true
do
	NEW=`stat -f %m $1`
	[ $NEW -gt $OLD ] && clear && date && echo "" && echo $REBU && echo "" && $2
	[ $NEW -gt $OLD ] && echo "" && echo $DONE
	sleep 1
	OLD=$NEW
done

