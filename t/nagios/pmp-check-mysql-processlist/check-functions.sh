#!/bin/sh

. ../../../nagios/bin/pmp-check-mysql-processlist

echo "should print 15"
max 1 5 15 11 8

echo "should print 1"
count_mysql_processlist "samples/locked-processlist-5.1-1.txt" \
   "State" "Locked"
