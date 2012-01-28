#summary How to install templates downloaded from this project

<wiki:toc />

This page explains how to install and use the pre-built templates that ship with this project.  If the templates are not exactly what you need, see CustomizingTemplates.

The following instructions assume you have the necessary privileges to make changes to your Cacti server.  You probably need to become root on that server.

It is a good idea to make sure your Web browser doesn't save your password when you're using Cacti.  There are some screens in the administrative interface that have hidden password fields you can't see, but the browser will fill in, and it'll cause you a lot of confusion and grief.

=Downloading=

You can download the templates from the Downloads tab of the Google Code project, at http://code.google.com/p/mysql-cacti-templates/downloads/list.  Get the latest released version.  You will need to get a copy of the scripts on the server, and you need access to the templates locally, so you can import them through your web browser:

  # Browse to http://code.google.com/p/mysql-cacti-templates/downloads/list
  # Download the file to your local machine's hard drive.
  # Right-click on the latest release and copy the location of the file to download.
  # Either log in to your Cacti server at the command prompt and use `wget` to download the same release to the server, or copy the downloaded release there with ftp, scp, or similar.

Let's assume you have just downloaded version 1.1.4, in better-cacti-templates-1.1.4.tar.gz.  Unpack the archive with the following command at a command prompt:

{{{
root@cactiserver# tar zxf better-cacti-templates-1.1.4.tar.gz
}}}

Repeat the same process on your local computer.  You should now have a directory named better-cacti-templates-1.1.4, containing several files.  (The directory name will change with each new release).  Change into this directory:

{{{
root@cactiserver# cd better-cacti-templates-1.1.4
}}}

=Installing=

Before you install, read the specific instructions for the templates you plan to install.  These are linked in the table of contents at the left side of this page.

The general process is to copy the data-gathering scripts into place, and then to import the templates via the web interface.

Copy the PHP scripts into your Cacti installation's scripts directory, on the server that hosts Cacti.  This is usually `/usr/share/cacti/site/scripts/`, but might be different on your system.  Let's assume you want to install the MySQL templates.

{{{
root@cactiserver# cp scripts/ss_get_mysql_stats.php /usr/share/cacti/site/scripts
}}}

Now import the template files through your web browser.  In the Cacti web interface's Console tab, click on the *Import Templates* link in the left sidebar.  Browse to the directory containing the unpacked templates, select the XML file for the templates you're installing, and submit the form.  In our example, the file will be named something like `cacti_host_template_x_mysql_server_ht_0.8.6i-sver1.1.4.xml`.

Inspect the page that results.  You should see something like the following:

{{{
Cacti has imported the following items:

CDEF
[success] X Negate CDEF [new]

GPRINT Preset
[success] X MySQL Server Version t1.1.4:s1.1.4 [new]
[success] X Normal [new]

Data Input Method
[success] X Get MySQL Stats/MyISAM Indexes IM [new]
... snip ...

Data Template
[success] X MyISAM Indexes DT [new]
... snip ...

Graph Template
[success] X MyISAM Indexes GT [new]
... snip ...

Host Template
[success] X MySQL Server HT [new]
}}}

The above is an abbreviated list.  Every line should show "success" at the beginning, and "new" (or "update" if you're upgrading) at the end.

=Configuring=

The templates themselves don't need to be configured, but you might need to configure the scripts that they execute to gather their data.  For example, you might need to specify a username and password to connect to MySQL and gather statistics.  There are several ways to do this.

==Embedding Configuration==

The simplest way is to embed the configuration options in the script file itself.  Open up the script file (such as scripts/ss_get_mysql_stats.php) with your favorite text editor, and look for a section like the following:

{{{
# ============================================================================
# CONFIGURATION
# ============================================================================
# Define MySQL connection constants in config.php.  Arguments explicitly passed
# in from Cacti will override these.  However, if you leave them blank in Cacti
# and set them here, you can make life easier.  Instead of defining parameters
# here, you can define them in another file named the same as this file, with a
# .cnf extension.
# ============================================================================
$mysql_user = 'cactiuser';
$mysql_pass = 'cactiuser';
$mysql_port = 3306;
... [snip]...
}}}

Each PHP file has its own configuration options, and there should be comments that explain them.  In the above example, the options are MySQL connection options.  Change them as desired, and save and close the PHP file.

This method this has some disadvantages.  If you upgrade the PHP script file, you'll lose your configuration.  And this only works if all of your monitored resources need the same configuration parameters.

==A Configuration File==

If you don't want to store the configuration options directly into the PHP script file, you can create another file with the same name and the filename extension `.cnf`.  Place this in the same directory as the PHP script file, and ensure it is valid PHP.  This file will be included by the PHP script file, so you can define the same configuration options there that you might define in the PHP script file.  For example, you might create scripts/ss_get_mysql_stats.php.cnf with the following contents:

{{{
<?php
$mysql_user = "root";
$mysql_pass = "s3cret";
?>
}}}

Notice the opening and closing PHP tags.  Be careful not to add any extra lines or whitespace at the beginning or end of the configuration file, because [http://groups.google.com/group/better-cacti-templates/browse_thread/thread/3955c36bdcf45786 that will conflict with the output from the script] and can cause problems.

This method still has the disadvantage that it works only if you use the same global configuration for every monitored resource.  If you need to specify a username and password for each host or each graph, it won't work.

==Passing Command-Line Arguments==

The above configuration methods make configuration available to the scripts as PHP variables, but it is also possible to pass command-line arguments to the scripts.  If you execute the script without any options, you'll see the available options.  For example,

{{{
php ss_get_mysql_stats.php
Required option --host is missing
Usage: php ss_get_mysql_stats.php --host <host> --items <item,...> [OPTION]

   --host      Hostname to connect to; use host:port syntax to specify a port
               Use :/path/to/socket if you want to connect via a UNIX socket
   --items     Comma-separated list of the items whose data you want
   --user      MySQL username; defaults to cactiuser if not given
   --pass      MySQL password; defaults to cactiuser if not given
   --heartbeat MySQL heartbeat table; defaults to '' (see mk-heartbeat)
   --nocache   Do not cache results in a file
   --port      MySQL port; defaults to 3306 if not given
}}}

You can make Cacti pass configuration options to the script with these command-line options when it executes the script.  To do this, you will need to do one of two things.  You can customize specific graphs that require configuration options, or you can generate your own templates so every graph requires you to fill in values for the options.

Generating custom graphs is covered in CustomizingTemplates.

Here's how to make specific graphs accept command-line arguments.  From the Console tab, click into Data Templates.  Find the desired Data Template and click it so you can edit it.  I'll use 'X MySQL Binary/Relay Logs DT' as an example.  Now, check the checkboxes so the desired command-line options use per-data-source values.  This means that the global template's value doesn't override the individual graph's values; the individual graphs must specify their own values.  For example, I've attached a screenshot here of setting the checkboxes so that username and password are per-data-source:

http://mysql-cacti-templates.googlecode.com/svn/data/use-per-data-source-value.png

Next find the data source by clicking into Data Sources.  Now that you've specified that this data source should use per-data-source values for the username and password, there are text boxes to fill in.  Here's a screenshot:

http://mysql-cacti-templates.googlecode.com/svn/data/fill-in-data-source-values.png

Cacti will now pass the given arguments to the PHP script when it executes.  Here's a snippet from the Cacti log, showing this in action:

{{{
10/26/2009 03:00:09 PM - CMDPHP: Poller[0] Host[1] DS[18] CMD:
   /usr/bin/php -q /usr/share/cacti/site/scripts/ss_get_mysql_stats.php
   --host 127.0.0.1 --items cv,cx,cy,cz --user root --pass s3cret --port 3306
}}}

=Creating Graphs=

Creating graphs is the easiest step of the process.

  # In Cacti's Console tab, browse to the "Devices" link in the sidebar and click on the device you'd like to graph.
  # The third item from the top of the screen should say *Host Template*.  Change this to the name of the template you imported, such as "X MySQL Server HT."
  # Scroll to the bottom of the page and click the Save button.
  # After the page loads, click on the "Create Graphs for this Host" link at the top of the page.
  # Tick the checkbox at the top right of the list of graph templates.  This should select every graph template that applies to this host but doesn't exist yet.
  # Scroll to the bottom of the page and click the Create button.

If you're upgrading from an earlier version of the template, you might need to change the Host Template to None, submit the change, and then change it back to the desired template after the page reloads.

After you create the graphs, wait until the poller runs once, and then check to make sure your new graphs render as images.
