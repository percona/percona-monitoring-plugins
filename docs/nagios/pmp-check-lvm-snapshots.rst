.. highlight:: perl


****
NAME
****


pmp-check-lvm-snapshots - Alert when LVM snapshots are running out of copy-on-write space.


********
SYNOPSIS
********



.. code-block:: perl

   Usage: pmp-check-lvm-snapshots [OPTIONS]
   Options:
     -c CRIT     Critical threshold; default 95%.
     -w WARN     Warning threshold; default 90%.
     --help      Print help and exit.
     --version   Print version and exit.
    Use perldoc to read embedded documentation with more details.



***********
DESCRIPTION
***********


This Nagios plugin looks at the output of the 'lvs' command to find LVM snapshot volumes
that are beginning to run out of copy-on-write space. If a snapshot fills up its
copy-on-write space, it will fail.  This is also a useful way to detect whether
some process, such as a backup, failed to release a snapshot volume after
finishing with it.


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


Percona Monitoring Plugins pmp-check-lvm-snapshots 1.0.0

