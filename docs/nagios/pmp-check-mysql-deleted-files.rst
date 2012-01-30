.. highlight:: perl


****
NAME
****


pmp-check-mysql-deleted-files - Alert when MySQL's files are deleted.


********
SYNOPSIS
********



.. code-block:: perl

   Usage: pmp-check-mysql-deleted-files [OPTIONS]
   Options:
     -c CRIT         Critical threshold; ignored.
     --defaults-file FILE Only read default options from the given file.
     -H HOST         MySQL hostname.
     -l USER         MySQL username.
     -p PASS         MySQL password.
     -P PORT         MySQL port.
     -S SOCKET       MySQL socket file.
     -w WARN         Warning threshold; changes the alert to WARN instead of CRIT.
     --help          Print help and exit.
     --version       Print version and exit.
    Use perldoc to read embedded documentation with more details.



***********
DESCRIPTION
***********


This Nagios plugin looks at the files that the mysqld process has open, and
warns if any of them are deleted that shouldn't be.  This typically happens when
there is a poorly written logrotate script or when a human makes a mistake at
the command line.  This can cause several bad effects. If a table has been
deleted, of course, it is a serious matter.  Such a file can also potentially
fill up the disk invisibly.  If the file is the server's log, it might mean that
logging is effectively broken and any problems the server experiences could be
undiagnosable.

The plugin accepts the -w and -c options for compatibility with standard Nagios
plugin conventions, but they are not based on a threshold. Instead, the plugin
raises a critical alert by default, and if the -w option is given, it raises a
warning instead, regardless of the option's value.

This plugin doesn't alert about deleted temporary files, which are not a
problem.  By default, this plugin assumes that the server's temporary directory
is either the TMPDIR environment variable, or if that is not set, then /tmp/.
If you specify MySQL authentication options, the value will log into the
specified MySQL instance and look at the \ ``tmpdir``\  variable to find the
temporary directory.

This plugin looks at the first running instance of MySQL, as found in the
system process table, so it will not work on systems that have multiple
instances running. It probably works best on Linux, though it might work on
other operating systems. It relies on either lsof or the ability to list the
files in the process's /proc/pid/fd directory.


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


Percona Monitoring Plugins pmp-check-mysql-deleted-files 1.0.0

