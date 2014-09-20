.. _hardening_cacti_setup:

Hardening Cacti setup
=====================

By default, the Cacti setup is closed from accessing from Web. Here is an excerpt from ``/etc/httpd/conf.d/cacti.conf``::

   <Directory /usr/share/cacti/>
	<IfModule mod_authz_core.c>
		# httpd 2.4
		Require host localhost
	</IfModule>
	<IfModule !mod_authz_core.c>
		# httpd 2.2
		Order deny,allow
		Deny from all
		Allow from localhost
	</IfModule>
   </Directory>

In order, to access the Cacti web interface, most likely, you will be changing this configuration. Commenting out Deny/Require statements will open the Cacti to the local network or Internet. This will create **a potential vulnerability to disclose MySQL password** contained in scripts under the directory ``/usr/share/cacti/scripts/``, in particular ``/usr/share/cacti/scripts/ss_get_mysql_stats.php`` and ``/usr/share/cacti/scripts/ss_get_mysql_stats.php.cnf``, when trying to access them from Web.

Unfortunately, the folder ``/usr/share/cacti/scripts/`` is not closed by default as it is done with ``/usr/share/cacti/log/`` and ``/usr/share/cacti/rra/`` directories.

We strongly recommend to close any access from the web for these additional directories or files:

* /usr/share/cacti/scripts/
* /usr/share/cacti/site/scripts/ (for Debian systems)
* /usr/share/cacti/cli/
* /usr/share/cacti/.boto

Here is an example of httpd configuration that can harden your setup (goes to ``/etc/httpd/conf.d/cacti.conf``)::

   <Directory ~ "/usr/share/cacti/(log/|rra/|scripts/|site/scripts/|cli/|\.ssh/|\.boto|.*\.cnf)">
	<IfModule mod_rewrite.c>
		Redirect 404 /
	</IfModule>
        <IfModule !mod_rewrite.c>
        	<IfModule mod_authz_core.c>
                	Require all denied
        	</IfModule>
        	<IfModule !mod_authz_core.c>
                	Order deny,allow
                	Deny from all
        	</IfModule>
        </IfModule>
   </Directory>

Even if you fully password-protected your Cacti installation using HTTP authentication, it is still recommended to double-secure the directories and files listed above.

Outlining the basic rules:

* keep your PHP config files ``ss_get_mysql_stats.php.cnf`` and ``ss_get_by_ssh.php.cnf`` outside the web directory ``/usr/share/cacti/scripts/``. The recommended location is ``/etc/cacti/``.
* do not put any SSH keys under cacti user home directory which is still the web directory.
* avoid placing ``.boto`` file under ``~cacti/``, use ``/etc/boto.cfg`` instead (that's for RDS plugins).
