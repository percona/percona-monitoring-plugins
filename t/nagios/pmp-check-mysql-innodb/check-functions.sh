#!/bin/sh

. ../../../nagios/bin/pmp-check-mysql-innodb

echo "should print 40"
get_longest_trx "samples/innodb-status-001.txt"

echo "should print 0"
get_waiter_count "samples/innodb-status-001.txt"

echo "should print 1"
get_waiter_count "samples/innodb-status-002.txt"
