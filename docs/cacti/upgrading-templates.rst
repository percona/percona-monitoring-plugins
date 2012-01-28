.. _cacti_upgrading_templates:

Upgrading Percona Monitoring Plugins for Cacti
==============================================

Upgrading is normally a simple process.  Before you begin, find the version of
the templates and scripts that is currently installed.  You can find this as a
GPRINT item, as in the following screenshot:

.. figure:: images/mysql-cacti-templates-installed-version.png

This shows that the MySQL templates installed were generated from version 1.1.4
of the templates, against version 1.1.4 of the PHP script file.

Check the installed scripts for their version::

   # grep ^.version /path/to/ss_get_mysql_stats.php
   $version = "1.1.4";

The following sections explain how to upgrade from each version to the next:

Version 1.0.0
=============

Version 1.0.0 of these templates may not be backwards compatible with the
*Better Cacti Templates** project from which they are derived, because the short
names of the data items have changed to work around a bug in Cacti.
