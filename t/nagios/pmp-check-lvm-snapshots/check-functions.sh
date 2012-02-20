#!/bin/sh

. ../../../nagios/bin/pmp-check-lvm-snapshots

echo "should print nothing"
check_lvm_snapshot_fullness "samples/lvs-001.txt" 20

echo "should print nothing"
check_lvm_snapshot_fullness "samples/lvs-002.txt" 20

echo "should print nothing"
check_lvm_snapshot_fullness "samples/lvs-003.txt" 30

echo "should print vg2/lv2[lv1]=20.57%"
check_lvm_snapshot_fullness "samples/lvs-003.txt" 20

echo "should print nothing"
check_lvm_snapshot_fullness "samples/lvs-004.txt" 30

echo "should print CRIT LVM snapshot volumes over 20% full: vg2/lv2[lv1]=20.57%"
main -c 20 "samples/lvs-003.txt"
