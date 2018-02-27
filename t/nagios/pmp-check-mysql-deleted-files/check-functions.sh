#!/bin/sh

. ../../../nagios/bin/pmp-check-mysql-deleted-files

echo "should print nothing"
check_deleted_files samples/lsof-001.txt /tmp/

echo "should print out 5 /tmp/ib* files"
check_deleted_files samples/lsof-001.txt /foo/

# regular expression with part of the tmp directory and part of the ib* filename
echo "should print out 2 /tmp/ib* files"
check_deleted_files samples/lsof-001.txt p/ib[Vsr].+
