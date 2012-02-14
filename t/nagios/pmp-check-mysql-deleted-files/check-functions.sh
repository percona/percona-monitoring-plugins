#!/bin/sh

. ../../../nagios/pmp-check-mysql-deleted-files

echo "should print nothing"
check_deleted_files samples/lsof-001.txt /tmp/

echo "should print out 5 /tmp/ib* files"
check_deleted_files samples/lsof-001.txt /foo/
