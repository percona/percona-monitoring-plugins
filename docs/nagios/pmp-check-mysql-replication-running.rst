.. highlight:: perl


****
NAME
****


pmp-check-mysql-replication-running - Alert when MySQL replication stops.


********
SYNOPSIS
********



.. code-block:: perl

   Usage: pmp-check-mysql-replication-running [OPTIONS]
   Options:
     -c CRIT         Critical threshold; makes non-error failures critical.
     --defaults-file FILE Only read default options from the given file.
     -H HOST         MySQL hostname.
     -l USER         MySQL username.
     -p PASS         MySQL password.
     -P PORT         MySQL port.
     -S SOCKET       MySQL socket file.
     -w WARN         Warning threshold; ignored.
     --help          Print help and exit.
     --version       Print version and exit.
   Use perldoc to read embedded documentation with more details.



***********
DESCRIPTION
***********


This Nagios plugin examines whether replication is running. It is separate from
the check for delay because it is confusing or impossible to handle all of the
combinations of replication errors and delays correctly, and provide an
appropriate type of alert, in a single program.

By default, this plugin treats it as critical when the either thread stops with
an error, and a warning when threads are stopped with no error.  You can provide
critical and warning thresholds with the -c and -w options, for compatibility
with Nagios plugin conventions, but they don't work as thresholds.  Instead, if
you specify a critical threshold, this plugin will treat it as critical if
either thread is stopped with or without an error. The warning threshold is
entirely ignored.

If SHOW SLAVE STATUS produces no output, then this plugin will report that
replication is healthy.


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


Percona Monitoring Plugins pmp-check-mysql-replication-running 1.0.0

