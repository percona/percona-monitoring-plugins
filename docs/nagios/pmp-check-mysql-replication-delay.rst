.. highlight:: perl


****
NAME
****


pmp-check-mysql-replication-delay - Alert when MySQL replication becomes delayed.


********
SYNOPSIS
********



.. code-block:: perl

   Usage: pmp-check-mysql-replication-delay [OPTIONS]
   Options:
     -c CRIT         Critical threshold; default 600.
     --defaults-file FILE Only read default options from the given file.
     -H HOST         MySQL hostname.
     -l USER         MySQL username.
     -p PASS         MySQL password.
     -P PORT         MySQL port.
     -S SOCKET       MySQL socket file.
     -s SERVERID     MySQL server ID of master, if using pt-heartbeat table.
     -T TABLE        Heartbeat table used by pt-heartbeat.
     -w WARN         Warning threshold; default 300.
     --help          Print help and exit.
     --version       Print version and exit.
   Use perldoc to read embedded documentation with more details.



***********
DESCRIPTION
***********


This Nagios plugin examines whether MySQL replication is delayed too much.  By
default it uses SHOW SLAVE STATUS, but the output of the Seconds_behind_master
column from this command is unreliable, so it is better to use pt-heartbeat from
Percona Toolkit instead.  Use the -T option to specify which table pt-heartbeat
updates.  Use the -s option to specify the master's server_id to compare
against; otherwise the plugin reports the maximum delay from any server. This
plugin does not support the legacy mk-heartbeat table format without the
server_id column.


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


Percona Monitoring Plugins pmp-check-mysql-replication-delay 1.0.0

