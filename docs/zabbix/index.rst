.. _zabbix_overview:

Percona Monitoring Plugins for Zabbix 
=====================================

These templates are mainly adopted from the existing :ref:`Cacti ones <templates_for_cacti>`.
Currently, only MySQL template is available.

There are a few major differences between Cacti and Zabbix templates:

* Zabbix does not support negative Y axis, that's why you can see the negative
  values on some graphs to work out that - consider them the same as positive ones.
* Zabbix does not support stacked graph items with mixed draw styles, that's why
  some graphs may not look so nice like in Cacti as the stacks are replaced with lines.

Other Zabbix specific points:

* The items are populated by polling Zabbix agent.
* There are predefined triggers available to use.
* There is a screen as a placeholder for all graphs. 
* 300 sec. polling interval - like with Cacti, the existing PHP script is used to
  retrive and cache MySQL metrics except some trigger-specific items. Due to the
  caching of results, PHP script runs only once per period.

System Requirements
===================

* Zabbix version 2.0.x. The actual testing has been done on the version 2.0.9.
* Zabbix agent, php, php-mysql packages on monitored node.

Installation Instructions
=========================

Configure Zabbix Agent
----------------------

1. Install the package from `Percona Software Repositories
   <http://www.percona.com/software/repositories>`_::

      yum install percona-zabbix-templates

   or::

      apt-get install percona-zabbix-templates

   It will place files under ``/var/lib/zabbix/percona/``. Alternatively, you can
   grab the tarball and copy folders ``zabbix/scripts/`` and ``zabbix/templates/``
   into ``/var/lib/zabbix/percona/``. See below for the URL.

2. Copy Zabbix Agent config::

      mkdir -p /etc/zabbix_agentd.conf.d/
      cp /var/lib/zabbix/percona/userparameter_percona_mysql.conf /etc/zabbix_agentd.conf.d/userparameter_percona_mysql.conf
     
3. Ensure /etc/zabbix_agentd.conf contains the line: ``Include=/etc/zabbix_agentd.conf.d/``

4. Restart Agent::

      service zabbix-agent restart

Configure MySQL connectivity on Agent
-------------------------------------
On this step we need to configure and verify MySQL connectivity with localhost on
the Agent node.

1. Create .cnf file ``/var/lib/zabbix/percona/scripts/ss_get_mysql_stats.php.cnf`` 
   as described at :ref:`configuration file <cacti_php_config_file>`

   Example::
 
     <?php
     $mysql_user = 'root';
     $mysql_pass = 's3cret';

2. Test the script::

     [root@centos6 main]# /var/lib/zabbix/percona/scripts/get_mysql_stats_wrapper.sh gg           
     405647

   Should return any number. If the password is wrong in .cnf file, you will get
   something like::

     [root@centos6 ~]# /var/lib/zabbix/percona/scripts/get_mysql_stats_wrapper.sh gg
     ERROR: run the command manually to investigate the problem: /usr/bin/php -q /var/lib/zabbix/percona/scripts/ss_get_mysql_stats.php --host localhost --items gg
     [root@centos6 ~]# /usr/bin/php -q /var/lib/zabbix/percona/scripts/ss_get_mysql_stats.php --host localhost --items gg
     ERROR: Can't connect to local MySQL server through socket '/var/lib/mysql/mysql.sock' (2)[root@centos6 ~]# 

3. Configure ~zabbix/.my.cnf

   Example::

     [client]
     user = root
     password = s3cret

4. Test the script::

     [root@centos6 ~]# sudo -u zabbix -H /var/lib/zabbix/percona/scripts/get_mysql_stats_wrapper.sh running-slave
     0

   Should return 0 or 1 but not the "Access denied" error.

Configure Zabbix Server
-----------------------

1. Grab the latest tarball from the `Percona Software Downloads
   <http://www.percona.com/downloads/percona-monitoring-plugins/>`_
   directory to your desktop.
 
2. Unpack it to get ``zabbix/templates/`` folder.

3. Import the XML template using Zabbix UI (Configuration -> Templates -> Import)
   by additionally choosing "Screens".

4. Edit hosts to assign them "Percona Templates" group and link the template. 

You are done.

Support Options
===============

If you have questions, comments, or need help with the plugins, there are
several options to consider.

You can get self-service help via `Percona's forums
<http://forum.percona.com>`_, or the `Percona mailing list
<https://groups.google.com/group/percona-discussion/>`_.

You can report bugs and submit patches to the `Launchpad project
<https://launchpad.net/percona-monitoring-plugins>`_.

