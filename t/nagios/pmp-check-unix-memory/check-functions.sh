#!/bin/sh

. ../../../nagios/bin/pmp-check-unix-memory

echo "Should print 23"
get_used_memory_linux  samples/free-001.txt

echo "Should print 53"
get_used_memory_bsd  samples/sysctl-001.txt

