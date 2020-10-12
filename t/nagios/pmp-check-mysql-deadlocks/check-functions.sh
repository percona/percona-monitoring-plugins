#!/bin/sh

. ../../../nagios/bin/pmp-check-mysql-deadlocks

echo "should print UNK could not count deadlocks"
main
