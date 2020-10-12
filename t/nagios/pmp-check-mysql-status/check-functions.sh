#!/bin/sh

. ../../../nagios/bin/pmp-check-mysql-status

printf "should print 1: "
compute_result samples/status-variables-001.txt Threads_running

printf "should print 0.150531: "
compute_result samples/status-variables-001.txt Bytes_received / Bytes_sent

printf "should print 15.053114: "
compute_result samples/status-variables-001.txt Bytes_received / Bytes_sent pct

printf "should exit 0: "
compare_result 15 20 30 '>='
echo $?

printf "should exit 1: "
compare_result 15 20 15 '>='
echo $?

printf "should exit 0: "
compare_result 15 20 15 '>'
echo $?

printf "should exit 2: "
compare_result 15 15 10 '>='
echo $?

printf "should exit 0: "
compare_result 15 "" "" '>='
echo $?

printf "should exit 0: "
compare_result 15 "20" "" '>='
echo $?

printf "should exit 0: "
compare_result 15 "" "20" '>='
echo $?

printf "should exit 1: "
compare_result 2 "" 4 '!='
echo $?

printf "should exit 0: "
compare_result 4 "" 4 '!='
echo $?

printf "should exit 1: "
compare_result 4 "" 4 '=='
echo $?

printf "should exit 2: "
compare_result STRICT IDEMPOTENT "" '=='
echo $?

printf "should exit 0: "
compare_result STRICT IDEMPOTENT "" '==' str
echo $?

printf "should exit 1: "
compare_result STRICT "" STRICT '==' str
echo $?

printf "should exit 0: "
compare_result STRICT STRICT "" '!=' str
echo $?

printf "should exit 0: "
compare_result 5 20 "" '>='
echo $?

printf "should exit 2: "
compare_result 5 20 "" '>=' str
echo $?

