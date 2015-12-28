#!/bin/sh

. ../../../nagios/bin/pmp-check-unix-memory

echo "Should print 29"
get_used_memory_linux  samples/meminfo-001.txt

echo "Should print 89"
get_used_memory_linux  samples/meminfo-002.txt

echo "Should print 53"
get_used_memory_bsd  samples/sysctl-001.txt

