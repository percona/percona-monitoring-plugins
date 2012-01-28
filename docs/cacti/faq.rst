.. _cacti_faq:

Frequently Asked Questions on Cacti Templates
=============================================

My graphs have NaN on them.  What is wrong?

  Please read and follow the directions at http://www.cacti.net/downloads/docs/html/debugging.html.

My Cacti error log has many lines like "WARNING: Result from CMD not valid. Partial Result: U"  What's wrong?

  Please read and follow the directions at http://www.cacti.net/downloads/docs/html/debugging.html.

Running ``poller.php`` or the PHP script shows the correct output, but I see nothing in the graphs in Cacti.  Why?

  If you ran either of those commands before Cacti did, then the cache file that
  the PHP script uses may have the wrong ownership. Check that the Cacti user
  has access to this cache file.  Also check the ownership on the PHP script
  itself; does the Cacti user have permission to execute it?  Sometimes the
  problem is due to installing or running as root from the command line, not
  realizing that Cacti runs as a different user.

How do I install?

  Please read :ref:`_cacti_installing_templates` for instructions.

The output is truncated when I use Spine.  Why?

  This is a Cacti bug.  Use cmd.php for now.

I get a blank page when I try to import the templates.  Why?

  Check your webserver log.  PHP might have run out of memory.  If you see
  something like "Allowed memory size of 8388608 bytes exhausted (tried to
  allocate 10 bytes)" then you should increase ``memory_limit`` in your
  ``php.ini`` file and restart the webserver.  Check that you've changed the
  correct ``php.ini`` file.  If the problem persists, you might be changing the
  wrong one or doing it wrong.  Some users have reported that they need to add
  ``ini_set('memory_limit', '64M');`` to the top of include/global.php.

When I try to import the templates, my browser asks me if I want to download templates_import.php.  Why?

  This might be the same problem as the blank page just mentioned.  Check your web server's error logs.

If I have a host that is both an Apache and MySQL server, should I be creating two separate devices in cacti, each with the appropriate Host Template?

  You don't need to. You can simply make it a MySQL server, create the
  appropriate graphs, and then switch to an Apache server and create the
  appropriate graphs.

How do I graph a MySQL server that uses a non-standard port?

  See :ref:`_cacti_customizing_templates`.
