.. highlight:: perl


****
NAME
****


pmp-check-mysql-status - Check MySQL SHOW GLOBAL STATUS output.


********
SYNOPSIS
********



.. code-block:: perl

   Usage: pmp-check-mysql-status [OPTIONS]
   Options:
     -c CRIT         Critical threshold.
     --defaults-file FILE Only read default options from the given file.
     -C COMPARE      Comparison operator to apply to -c and -w; default >=.
     -H HOST         MySQL hostname.
     -I INCR         Make SHOW STATUS incremental over this delay.
     -k DIRECTORY    Make SHOW STATUS incremental since last check. Keep last
                     check's sample in DIRECTORY (default /var/lib/pmp/). May be
                     given without an argument.
     -l USER         MySQL username.
     -o OPERATOR     The operator to apply to -x and -y.
     -p PASS         MySQL password.
     -P PORT         MySQL port.
     -S SOCKET       MySQL socket file.
     -T TRANS        Transformation to apply before comparing to -c and -w.
     -w WARN         Warning threshold.
     -x VAR1         Required first status or configuration variable.
     -y VAR2         Optional second status or configuration variable.
     --help          Print help and exit.
     --version       Print version and exit.
   Use perldoc to read embedded documentation with more details.



***********
DESCRIPTION
***********


This Nagios plugin captures SHOW GLOBAL STATUS and SHOW GLOBAL VARIABLES from
MySQL and evaluates expressions against them.  The general syntax is as follows:


.. code-block:: perl

   VAR1 [ OPERATOR VAR2 [ TRANSFORM ] ]


The result of evaluating this is compared against the -w and -c options as usual
to determine whether to raise a warning or critical alert.

Note that all of the examples provided below are simply for illustrative
purposes and are not supposed to be recommendations for what to monitor. You
should get advice from a professional if you are not sure what you should be
monitoring.

For our first example, we will raise a warning if Threads_running is 20 or over,
and a critical alert if it is 40 or over:


.. code-block:: perl

   -x Threads_running -w 20 -c 40


The threshold is implemented as greater-or-equals by default, not strictly
greater-than, so a value of 20 is a warning and a value of 40 is critical.  You
can switch this to less-or-equals or other operators with the -C option, which
accepts the arithmetic comparison operators ==, >, >=, <, and <=.

You can use any variable that is present in SHOW VARIABLES or SHOW STATUS. If
the variable is not found, there is an error.  To warn if Threads_connected
exceeds 80% of max_connections:


.. code-block:: perl

   -x Threads_connected -o / -y max_connections -T pct -w 80


The -T option only works when you specify both -x and -y.  Currently the only
transformation implemented for -T is \ ``pct``\ .  The plugin uses awk to do its
computations and comparisons, so you can use floating-point math; you are not
restricted to integers for comparisons.  The -o option accepts the arithmetic
operators /, \*, +, and -.  A division by zero results in zero, not an error.

If you specify the -I option with an integer argument, the SHOW STATUS values
become incremental instead of absolute.  The argument is used as a delay in
seconds, and instead of capturing a single sample of SHOW STATUS and using it
for computations, the plugin captures two samples at the specified interval and
subtracts the second from the first.  This lets you evaluate expressions over a
range of time.  For example, to warn when there are 10 disk-based temporary
tables per second, over a 5-second sampling period:


.. code-block:: perl

   -x Created_tmp_disk_tables -o / -y Uptime -I 5 -w 10


That is somewhat contrived, because it could also be written as follows:


.. code-block:: perl

   -x Created_tmp_disk_tables -I 5 -w 50


The -I option has the side effect of removing any non-numeric SHOW STATUS
variables.  Be careful not to set the -I option too large, or Nagios will simply
time the plugin out, usually after about 10 seconds.

This plugin does not support arbitrarily complex expressions, such as computing
the query cache hit ratio and alerting if it is less than some percentage.  If
you are trying to do that, you might be doing it wrong.  A dubious example for
the query cache might be to alert if the hit-to-insert ratio falls below 2:1, as
follows:


.. code-block:: perl

   -x Qcache_hits -o / -y Qcache_inserts -C '<' -w 2


Some people might suggest that the following is a more useful alert for the
query cache:


.. code-block:: perl

   -x query_cache_size -c 1



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


Percona Monitoring Plugins pmp-check-mysql-status 1.0.0

