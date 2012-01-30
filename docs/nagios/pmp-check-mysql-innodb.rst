.. highlight:: perl


****
NAME
****


pmp-check-mysql-innodb - Alert on problems inside InnoDB.


********
SYNOPSIS
********



.. code-block:: perl

   Usage: pmp-check-mysql-innodb [OPTIONS]
   Options:
     -C CHECK        What to alert on; default idle_blocker_duration.
     -c CRIT         Critical threshold; default varies.
     --defaults-file FILE Only read default options from the given file.
     -H HOST         MySQL hostname.
     -l USER         MySQL username.
     -p PASS         MySQL password.
     -P PORT         MySQL port.
     -S SOCKET       MySQL socket file.
     -w WARN         Warning threshold; default varies.
     --help          Print help and exit.
     --version       Print version and exit.
   Use perldoc to read embedded documentation with more details.



***********
DESCRIPTION
***********


This Nagios plugin alerts on various aspects of InnoDB status in several ways,
depending on the value of the -C option:


idle_blocker_duration
 
 This is the default behavior.  It alerts when a long-running transaction is
 blocking another, and the blocker is idle (Sleep).  The threshold is based on
 how long the transaction has been idle.  Long-running idle transactions that
 have acquired locks but not released them are a frequent cause of application
 downtime due to lock wait timeouts and rollbacks, especially because
 applications are often not designed to handle such errors correctly.  The
 problem is usually due to another error that causes a transaction not to be
 committed, such as performing very long tasks in the application while holding
 the transaction open.
 
 This check examines the INFORMATION_SCHEMA tables included with InnoDB version
 1.0 and newer. The default critical level is 600, and warning is 60.
 


waiter_count
 
 Alerts if too many transactions are in LOCK WAIT status. Uses information from
 SHOW ENGINE INNODB STATUS if the INFORMATION_SCHEMA tables are not available.
 The default critical level is 25, and warning is 10.
 


max_duration
 
 Alerts if any transaction is too old.  Uses information from SHOW ENGINE INNODB
 STATUS if the INFORMATION_SCHEMA tables are not available. The default critical
 level is 600, and warning is 60.
 



***********
DOWNLOADING
***********


Visit `http://www.percona.com/software/percona-monitoring-plugins/ <http://www.percona.com/software/percona-monitoring-plugins/>`_ to download
the latest release of Percona Monitoring Plugins.


*******
AUTHORS
*******


Baron Schwartz


********************************
COPYRIGHT, LICENSE, AND WARRANTY
********************************


This program is copyright 2012 Baron Schwartz, 2012 Percona Inc.
Feedback and improvements are welcome.

THIS PROGRAM IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, version 2; OR the Perl Artistic License.  On UNIX and similar
systems, you can issue \`man perlgpl' or \`man perlartistic' to read these
licenses.

You should have received a copy of the GNU General Public License along with
this program; if not, write to the Free Software Foundation, Inc., 59 Temple
Place, Suite 330, Boston, MA  02111-1307  USA.


*******
VERSION
*******


Percona Monitoring Plugins pmp-check-mysql-innodb 1.0.0

