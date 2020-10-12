#!/bin/sh

. ../../../nagios/bin/pmp-check-mysql-replication-running

echo "should print OK Slave_IO_Running: Yes Slave_SQL_Running: Yes Last_Error:"
main samples/show-slave-status-001.txt 

echo "should print WARN Slave_IO_Running: Connecting Slave_SQL_Running: Yes Last_Error:"
main samples/show-slave-status-002.txt

echo "should print WARN Slave_IO_Running: Yes Slave_SQL_Running: No Last_Error:"
main samples/show-slave-status-003.txt

echo "should print CRIT Slave_IO_Running: Yes Slave_SQL_Running: No Last_Error:"
main -c 1 samples/show-slave-status-003.txt

echo "should print OK This server is not configured as a replica."
main samples/empty

echo "should print WARN This server is not configured as a replica."
main -w 100 samples/empty

echo "should print UNK could not determine replication status"
main samples/doesnt-exist

echo "should print OK (delayed slave) Slave_IO_Running: Yes Slave_SQL_Running: No Last_Error:"
main -d 1 samples/show-slave-status-003.txt

echo "should print CRIT Slave_IO_Running: No Slave_SQL_Running: No Last_Error:"
main -d 1 samples/show-slave-status-004.txt

echo "should print CRIT Slave_IO_Running: Yes Slave_SQL_Running: No Last_Error: Error 'Table 'mydb.mytable' doesn't exist' on query. Default database:"
main -d 1 samples/show-slave-status-005.txt
