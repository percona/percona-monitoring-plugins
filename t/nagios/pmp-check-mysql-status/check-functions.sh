#!/bin/sh

. ../../../nagios/pmp-check-mysql-status

echo "should print 1"
compute_result samples/status-variables-001.txt Threads_running

echo "should print 0.150531"
compute_result samples/status-variables-001.txt Bytes_received / Bytes_sent

echo "should print 15.053114"
compute_result samples/status-variables-001.txt Bytes_received / Bytes_sent pct

echo "should exit 0"
compare_result 15 20 30 '>='
echo $?

echo "should exit 1"
compare_result 15 20 15 '>='
echo $?

echo "should exit 0"
compare_result 15 20 15 '>'
echo $?

echo "should exit 2"
compare_result 15 15 10 '>='
echo $?

echo "should exit 0"
compare_result 15 "" "" '>='
echo $?

echo "should exit 0"
compare_result 15 "20" "" '>='
echo $?

echo "should exit 0"
compare_result 15 "" "20" '>='
echo $?
