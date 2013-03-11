#!/bin/sh

. ../../../nagios/bin/pmp-check-mysql-replication-delay

echo "should print OK 10 seconds of replication delay"
main samples/show-slave-status-001.txt 

echo "should print WARN 10 seconds of replication delay"
main -w 9 samples/show-slave-status-001.txt 

echo "should print CRIT 10 seconds of replication delay"
main -c 9 samples/show-slave-status-001.txt 

echo "should print UNK if the slave is not running"
main samples/show-slave-status-002.txt
