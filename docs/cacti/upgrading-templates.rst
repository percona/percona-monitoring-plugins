.. _cacti_upgrading_templates:

Upgrading Percona Monitoring Plugins for Cacti
==============================================

Upgrading is normally a simple process.  Before you begin, find the version of
the templates and scripts that is currently installed.  You can find this as a
GPRINT item, as in the following screenshot:

.. image:: images/mysql-cacti-templates-installed-version.png

This shows that the MySQL templates installed were generated from version 1.1.4
of the templates, against version 1.1.4 of the PHP script file.

Check the installed scripts for their version::

   # grep ^.version /path/to/ss_get_mysql_stats.php
   $version = "1.1.4";

To upgrade Percona Cacti scripts simply overwrite ss_get_*.php files from a new
tarball or update the package::
  
   yum update percona-cacti-templates

or::

   apt-get install percona-cacti-templates

Afterwards, re-import templates into Cacti using the web interface or from the command line, e.g.::

   php /usr/share/cacti/cli/import_template.php --filename=/usr/share/cacti/resource/percona/templates/cacti_host_template_percona_gnu_linux_server_ht_0.8.6i-sver1.0.3.xml \
   --with-user-rras='1:2:3:4'

Then rebuild the poller cache under Cacti -> System Utilities.

If any special upgrade steps are necessary, the changelog will explain them.
