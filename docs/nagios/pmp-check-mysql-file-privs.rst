.. highlight:: perl


****
NAME
****


pmp-check-mysql-file-privs - Alert if MySQL data directory privileges are wrong.


********
SYNOPSIS
********



.. code-block:: perl

   Usage: pmp-check-mysql-file-privs [OPTIONS]
   Options:
     -c CRIT         Critical threshold; makes a missing PID file critical.
     --defaults-file FILE Only read default options from the given file.
     -g GROUP        The Unix group who should own the files; default mysql.
     -H HOST         MySQL hostname.
     -l USER         MySQL username.
     -p PASS         MySQL password.
     -P PORT         MySQL port.
     -S SOCKET       MySQL socket file.
     -u USER         The Unix user who should own the files; default mysql.
     -w WARN         Warning threshold; ignored.
     --help          Print help and exit.
     --version       Print version and exit.
   Use perldoc to read embedded documentation with more details.



***********
DESCRIPTION
***********


This Nagios plugin checks to make sure that the MySQL data directory, and its
contents, is owned by the correct Unix user and group. If the ownership is
incorrect, then the server might fail due to lack of permission to modify its
data.  For example, suppose a system administrator enters a database directory
and creates a file that is owned by root.  Now a database administrator issues a
DROP TABLE command, which fails because it is unable to remove the file and thus
the non-empty directory cannot be removed either.

The plugin accepts the -g and -u options to specify which Unix user and group
should own the data directory and its contents. This is usually the user account
under which MySQL runs, which is mysql by default on most systems.  The plugin
assumes that user and group by default, too.

The plugin accepts the -w and -c options for compatibility with standard Nagios
plugin conventions, but they are not based on a threshold. Instead, the plugin
raises a warning by default, and if the -c option is given, it raises an error
instead, regardless of the option's value.

By default, this plugin will attempt to detect all running instances of MySQL,
and verify the data directory ownership for each one.  It does this purely by
examining the Unix process table with the \ ``ps``\  tool.  However, in some cases
the process's command line does not list the path to the data directory.  If the
tool fails to detect the MySQL server process, or if you wish to limit the check
to a single instance in the event that there are multiple instances on a single
server, then you can specify MySQL authentication options.  This will cause the
plugin to skip examining the Unix processlist, log into MySQL, and examine the
datadir variable from SHOW VARIABLES to find the location of the data directory.


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


Percona Monitoring Plugins pmp-check-mysql-file-privs 1.0.0

