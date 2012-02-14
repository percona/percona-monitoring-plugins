#!/bin/sh

. ../../../nagios/pmp-check-mysql-pidfile

echo "Should print /tmp/mysql.5520.pid"
get_pidfile "samples/global-variables-001.txt"
