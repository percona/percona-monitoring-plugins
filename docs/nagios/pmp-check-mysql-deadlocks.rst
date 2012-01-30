.. highlight:: perl


****
NAME
****


pmp-check-mysql-deadlocks - Alert when pt-deadlock-logger has recorded too many recent deadlocks.


********
SYNOPSIS
********



.. code-block:: perl

   Usage: pmp-check-mysql-deadlocks [OPTIONS]
   Options:
     -c CRIT         Critical threshold; default 60.
     --defaults-file FILE Only read default options from the given file.
     -H HOST         MySQL hostname.
     -i INTERVAL     Interval over which to count, in minutes; default 1.
     -l USER         MySQL username.
     -p PASS         MySQL password.
     -P PORT         MySQL port.
     -S SOCKET       MySQL socket file.
     -T TABLE        The database.table that pt-deadlock-logger uses; default percona.deadlocks.
     -w WARN         Warning threshold; default 12.
     --help          Print help and exit.
     --version       Print version and exit.
   Use perldoc to read embedded documentation with more details.



***********
DESCRIPTION
***********


This Nagios plugin looks at the table that pt-deadlock-logger (part of Percona
Toolkit) maintains, and when there have been too many recent deadlocks, it
alerts.


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


Percona Monitoring Plugins pmp-check-mysql-deadlocks 1.0.0

