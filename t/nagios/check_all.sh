../../nagios/bin/pmp-check-mysql-status -x Threads_connected -o / -y max_connections -T pct -w 80 -c 95
../../nagios/bin/pmp-check-mysql-status -x Threads_running -w 40 -c 100
../../nagios/bin/pmp-check-mysql-replication-delay -w 300 -c 600
../../nagios/bin/pmp-check-mysql-replication-running -c 1
../../nagios/bin/pmp-check-mysql-processlist
../../nagios/bin/pmp-check-mysql-innodb
../../nagios/bin/pmp-check-unix-memory
../../nagios/bin/pmp-check-mysql-deadlocks
../../nagios/bin/pmp-check-pt-table-checksum
../../nagios/bin/pmp-check-mysql-pidfile
../../nagios/bin/pmp-check-mysql-deleted-files
../../nagios/bin/pmp-check-mysql-file-privs
../../nagios/bin/pmp-check-lvm-snapshots
for d in `find . -maxdepth 1 -type d -name "pmp-*"`; do
    cd $d
    sh check-functions.sh
    cd ..
done
