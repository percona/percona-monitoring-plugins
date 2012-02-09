#!/bin/sh

. ../../../nagios/pmp-check-unix-memory

echo "Should print 16046"
get_total_memory     samples/free-001.txt

echo "Should print 23"
get_used_memory_pct  samples/free-001.txt

echo "Should print 16675 133149.54 mysqld"
get_largest_process  samples/ps-004.txt

echo "Should print 70"
pct_of               50 71

echo "Should print 0"
pct_of               50 0
