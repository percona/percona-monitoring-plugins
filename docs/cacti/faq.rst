#summary Frequently Asked Questions

Q. My graphs have NaN on them.  What is wrong?

  # A. Please read and follow the directions at http://www.cacti.net/downloads/docs/html/debugging.html.

Q. My Cacti error log has a bunch of lines like "WARNING: Result from CMD not valid. Partial Result: U"  What's wrong?

  # A. Please read and follow the directions at http://www.cacti.net/downloads/docs/html/debugging.html.

Q. Running poller.php or ss_get_mysql_stats.php shows the correct output, but I see nothing in the graphs for MySQL in Cacti.  Why?

  # A. If you ran either of those commands before Cacti had a chance to, the cache_file ss_get_mysql_stats.php uses may have the wrong ownership, check the Cacti owner has access to $cache_dir/$host-mysql_cacti_stats.txt (/tmp/$host-mysql_cacti_stats.txt).  Also check the ownership on the PHP script itself; does the Cacti user have permission to execute it?  Quite a few issues have turned out to be due to people installing/running as root from the command line, not realizing that Cacti runs as a different user.

Q. How do I install?

  # A. Please read InstallingTemplates for instructions on installation, etc.

Q. The output is truncated when I use Spine.  Why?

  # A. This is a Cacti bug (see Issue 2).  Use cmd.php for now.

Q. When I run the PHP script on the command line, there is an extra blank line that makes the Cacti poller fail.  Where does the extra newline come from?

  # A. Probably from some whitespace in your configuration file, before or after the PHP tags.  See the configuration file section on InstallingTemplates.

Q. I get a blank page when I try to import the templates.  Why?

  # A. Check your webserver log.  PHP might have run out of memory.  If you see something like "Allowed memory size of 8388608 bytes exhausted (tried to allocate 10 bytes)" then you should increase memory_limit in your php.ini file and restart the webserver.  Check that you've changed the correct php.ini file.  If the problem persists, you might be changing the wrong one or doing it wrong.  Some users have reported that they need to add `ini_set('memory_limit', '64M');` to the top of include/global.php.

Q. When I try to import the templates, my browser asks me if I want to download templates_import.php.  Why?

  # A. This might be the same problem as the blank page, above.  Check your web server's error logs.

Q. I see an error on some huge SQL like SELECT CONCAT(0+104857683+104857795+104857873.....

  # A. You must have a lot of binary log files!  Set expire_logs_days or purge old binlogs with PURGE MASTER LOGS.  (You also have an old version of the templates.  New versions don't do this at all anymore.)

Q. After I import the templates, the angle brackets around hostname, etc are gone.  What's wrong?

  # A. See http://code.google.com/p/mysql-cacti-templates/issues/detail?id=49#c20

Q. If I have a host that is both an Apache and MySQL server should I be creating two separate Devices in cacti, each with the appropriate Host Template?

  # A. You don't need to. You can simply make it a MySQL server, create the appropriate graphs, and then switch to an Apache server and create the appropriate graphs.

Q. How do I graph a MySQL server that uses a non-standard port?

  # A. See http://code.google.com/p/mysql-cacti-templates/wiki/CustomizingTemplates#Accept_Input_in_Each_Data_Source