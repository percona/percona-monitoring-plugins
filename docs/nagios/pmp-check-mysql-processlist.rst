.. highlight:: perl


****
NAME
****


pmp-check-mysql-processlist - Alert when MySQL processlist has dangerous patterns.


********
SYNOPSIS
********



.. code-block:: perl

   Usage: pmp-check-mysql-processlist [OPTIONS]
   Options:
     -c CRIT         Critical threshold; default 32.
     --defaults-file FILE Only read default options from the given file.
     -H HOST         MySQL hostname.
     -l USER         MySQL username.
     -p PASS         MySQL password.
     -P PORT         MySQL port.
     -S SOCKET       MySQL socket file.
     -w WARN         Warning threshold; default 16.
     --help          Print help and exit.
     --version       Print version and exit.
   Use perldoc to read embedded documentation with more details.



***********
DESCRIPTION
***********


This Nagios plugin examines MySQL's processlist and alerts when there are too
many processes in various states.  The list of checks is as follows:


Unauthenticated users
 
 Unauthenticated users appear when DNS resolution is slow, and can be a warning
 sign of DNS performance problems that could cause a sudden denial of service to
 the server.
 


Locked processes
 
 Locked processes are the signature of MyISAM tables, but can also appear for
 other reasons.
 


Copying to temporary tables
 
 Too many processes copying to various kinds of temporary tables at one time is a
 typical symptom of a storm of poorly optimized queries.
 


Statistics
 
 Too many processes in the "statistics" state is a signature of InnoDB
 concurrency problems causing query execution plan generation to take too long.
 



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


Percona Monitoring Plugins pmp-check-mysql-processlist 1.0.0

