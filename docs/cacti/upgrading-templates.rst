#summary How to upgrade between template versions

<wiki:toc />

Upgrading is normally a simple process.

= Finding The Installed Version =

Before you begin, find the version of the templates and scripts that is currently installed.  In releases 1.1.4 and higher, you can find this as a GPRINT item, as in the following screenshot:

http://mysql-cacti-templates.googlecode.com/svn/data/mysql-cacti-templates-installed-version.png

This shows that the MySQL templates installed were generated from version 1.1.4 of the templates, against version 1.1.4 of the PHP script file.  If you don't see this, the templates installed were from version 1.1.3 or earlier.

Check the installed scripts for their version:

{{{
# grep ^.version /path/to/ss_get_mysql_stats.php
$version = "1.1.4";
}}}

Each step in the following list assumes that you have upgraded to the previous version already.

= Version 1.1.8 =

To upgrade from version 1.1.7, you need to

  * Copy the new ss_get_mysql_stats.php and ss_get_by_ssh.php files into your Cacti scripts directory.  There were changes to both of them.
  * Re-import the new versions of the templates.
  * Optionally add new graphs for MySQL, by refreshing the host template for all MySQL servers.

{{{
e4eaa620a60b8d19427afb2fc47707c9  ss_get_by_ssh.php
5b8aba21ae03f968320a7c9582fa9935  ss_get_mysql_stats.php
}}}

= Version 1.1.7 =

To upgrade from version 1.1.6, you need to

  * Copy the new ss_get_mysql_stats.php and ss_get_by_ssh.php files into your Cacti scripts directory.  There were changes to both of them.
  * Re-import the new versions of the templates.
  * Rebuild all of your InnoDB Log Activity RRD files to change the unflushed_log data item to a GAUGE, to fix issue 10.  Follow a similar process as that described in the upgrade instructions for version 1.1.5.
  * Optionally add new graphs for MySQL, by refreshing the host template for all MySQL servers.

{{{
86967f01941bf25880dc1158d2f0098c  ss_get_by_ssh.php
52088284dece40cbcc39b8146a7e4912  ss_get_mysql_stats.php
}}}

= Version 1.1.6 =

To upgrade from version 1.1.5, you need to copy the new ss_get_mysql_stats.php and ss_get_by_ssh.php files into your Cacti scripts directory.  No graphs or templates were changed, but there are new templates for OpenVZ and new graphs for disk I/O statistics.  If you want these, you need to re-import the templates and update the attached templates for your hosts.

{{{
2397324deb74d0d55149ac4f61497ab0  ss_get_by_ssh.php
3c120329848bc69d59dd0de687d2fd16  ss_get_mysql_stats.php
}}}

= Version 1.1.5 =

To upgrade from version 1.1.4, you need to copy the new ss_get_mysql_stats.php and ss_get_by_ssh.php files into your Cacti scripts directory, and re-import the new version of the templates.  All of the templates were changed.  You do not need to re-edit devices, because there are no new graphs.  However, the RRA definitions are changed to use DERIVE instead of COUNTER, and the RRA files need to be rebuilt for that to take effect.  This is optional, but is a nice improvement because it will prevent spikes from making the graphs unreadable.  To rebuild the RRA files with DERIVE, run the following code in your RRA directory, which is probably something like `/var/lib/cacti/rra/`:

{{{
for file in *.rrd; do
  if rrdtool info $file | grep -q COUNTER; then
    mv $file $file.bak;
    rrdtool dump $file.bak > $file.xml;
    perl -pi -e 's/COUNTER/DERIVE/' $file.xml;
    rrdtool restore $file.xml $file;
    rm $file.xml;
  fi
done
}}}

You should then test that everything is OK.  If needed, the original files are still there with a .bak filename extension.  These can be deleted after you determine everything's all right.

{{{
f666d8cdf38a0b75b0f5d96e3057a4c1  ss_get_by_ssh.php
a660786e8075fe27961be6b34049d7be  ss_get_mysql_stats.php
}}}

= Version 1.1.4 =

To upgrade from version 1.1.3, you need to copy the new ss_get_mysql_stats.php and ss_get_by_ssh.php files into your Cacti scripts directory, and re-import the MySQL templates.  (Only the MySQL templates were changed.)  You should then edit all devices that have the MySQL template attached.  You probably need to change their host template to None, then back to X MySQL Server HT, and then create new graphs.

{{{
a820c1ccda0a61ffdbe0c53d39bffd40  ss_get_by_ssh.php
d0b1e9f3d36e57c5795448db2501cb2b  ss_get_mysql_stats.php
}}}

= Version 1.1.3 =

To upgrade from version 1.1.2, you need to copy the new ss_get_mysql_stats.php file into your Cacti scripts directory.

{{{
628fe229721d1792792fad8f9383660c  ss_get_by_ssh.php
e0301606e55e5a7a890dcfac9a9851be  ss_get_mysql_stats.php
}}}

= Version 1.1.2 =

Upgrade instructions from versions prior to 1.1.2 might be more complicated, because there were some incompatible changes.  (This is not likely to happen again.)  You might find this article useful: http://www.xaprb.com/blog/2009/10/15/a-tip-when-upgrading-mysql-cacti-templates/

MD5 checksums of script files:

{{{
628fe229721d1792792fad8f9383660c  ss_get_by_ssh.php
0e80f085f1a5136214608ad584a01da5  ss_get_mysql_stats.php
}}}