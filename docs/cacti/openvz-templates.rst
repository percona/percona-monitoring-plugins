.. _cacti_openvz_templates:

Percona OpenVZ Monitoring Template for Cacti
============================================

These templates use ``ss_get_by_ssh.php`` to connect to a server via SSH and
extract statistics from the OpenVZ container, by concatenating the contents of
``/proc/user_beancounters`` to standard output.

Installation
------------

Once the SSH connection is working, import the OpenVZ template and apply
it to your host, then add the graphs.

Depending on your version of OpenVZ or Virtuozzo, the file
``/proc/user_beancounters`` might not be accessible to ordinary users.  This
means you either need to SSH as root, or use a program such as `beanc
<http://www.labradordata.ca/home/35>`_ to read the file.  If you choose the
latter approach, you should change the ``$openvz_cmd`` configuration variable.

You can test one of your hosts like this.  You may need to change some of the
example values below, such as the cacti username and the hostname you're
connecting to::

   sudo -u cacti php /usr/share/cacti/scripts/ss_get_by_ssh.php --type openvz --host 127.0.0.1 --items jn,jo

Sample Graphs
-------------

No sample graphs are available yet.
