#!/bin/sh

. ../../../nagios/bin/pmp-check-mysql-processlist

echo "should print 15"
max 1 5 15 11 8

echo "should print 1"
count_mysql_processlist "samples/locked-processlist-5.1-1.txt" \
   "State" "Locked"

echo "should print 2"
count_mysql_processlist "samples/locked-processlist-5.5-1.txt" \
   "State" "Waiting for table level lock"

echo "should print 4"
count_mysql_processlist "samples/copy-processlist-1.txt" \
   "State" ".*opy.* to.* table.*"
