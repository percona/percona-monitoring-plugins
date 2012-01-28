#summary How to generate your own versions of the templates

<wiki:toc />

The templates that are included in the release packages are generic, designed to be suitable for default installations.  However, if they don't meet your needs, you can generate your own easily.

It is important to note that these templates are designed to avoid the problems caused by modifying templates within Cacti and then exporting them.  Instead of doing this, you should use the provided command-line tools to modify the templates before you import them. If you want to, you can modify them over and over again and keep re-importing them.  Cacti will update its database to match the changes that you import.

You can customize many aspects of the templates.  The following sections will explain the possible customizations.  All of these are possible simply by passing the correct options to the `make-template.pl` command-line tool.

=Generating Templates=

The process of generating a template is very simple.  You simply execute the make-template.pl program and give it the associated script and template definition file.  For example, to create MySQL templates identical to the ones in the release file:

{{{
$ perl tools/make-template.pl \
  --script scripts/ss_get_mysql_stats.php \
  definitions/mysql_definitions.pl > mysql-template.xml
}}}

=Generate Templates for a Specific Cacti Version=

Cacti templates are version-specific, because the hash identifiers that are used as GUIDs have a version number embedded in them.  This can prevent templates exported from one version of Cacti from being imported to another, even if there is no real incompatibility.  The --cactiver option to the make-template.pl script will control this.

The version numbers it understands are embedded in the program, and if you specify an illegal value, it'll let you know.  If you want to generate templates for a version it doesn't know about, bring it up on the mailing list.  The versions are forwards-compatible, so templates generated for an earlier version of Cacti should work on a newer version too.

=Accept Input in Each Data Source=

If you want to specify command-line options to data sources, you can easily make certain command-line options for the script required per-graph.  For example, let's suppose that you want to ensure the ss_get_mysql_stats.php script is executed with the --port command-line option, perhaps for the reasons outlined in InstallingTemplates under the Configuration section.  You can generate templates that require this.

The option to use is --mpds, which is short for "make per data source".  You give it a comma-separated list of options.  Here's an example with --port.

{{{
perl tools/make-template.pl \
  --script scripts/ss_get_mysql_stats.php definitions/mysql_definitions.pl \
  --mpds port > templates_requiring_port.xml
}}}

Be aware that the SSH-based templates use --port to specify the SSH port, and --port2 to connect to the resource you're graphing, so you might need to customize --port2, not --port.

If you import the resulting XML file, and then edit a host to bind it to the "X MySQL Server HT" host template, when you create the graphs you'll be prompted to fill in a value for the port, as in the following screenshot:

http://mysql-cacti-templates.googlecode.com/svn/data/create-graphs-input-port.png

=Specify a Different Graph Width or Height=

The default size of the Cacti graphs is 120 pixels high by 500 pixels wide.  If you would like to specify a different size, you can use the --graph_height and --graph_width options.  For example,

{{{
perl tools/make-template.pl \
  --script scripts/ss_get_mysql_stats.php definitions/mysql_definitions.pl \
  --graph_height 240 --graph_width 1000 > templates_240x1000.xml
}}}

=Specify a Different Name Prefix=

The default naming convention for every item created by the templates starts with "X", the name of the item, and an abbreviation at the end, such as "DT" for Data Templates.  This makes all the items sort together, and makes them distinctive so you don't confuse them with others that might be named similarly.  If you want to specify a different prefix, you can use the --name_prefix option.  For example, you might specify "Big" for templates that you want to generate at a larger size, as in the previous example.  Then you'll have templates named like "Big MySQL Select Types GT".

=Specify a Different Polling Interval=

The default polling interval for most Cacti installations is 5 minutes, or 300 seconds.  The templates need to match the polling interval, because the RRD files are created for a specific polling interval.  If you have configured Cacti to use a different interval, you can generate matching templates with the --poll_interval option, which accepts the number of seconds.

=Change the Default Maximum Permitted Value in RRD Files=

The default maximum value that the RRD files will recognize as valid is used to detect garbage input and prevent spikes in graphs.  By default, it is set to the size of a 64-bit unsigned integer.  If you want rollover and out-of-bounds detection for 32-bit integer values, use the --smallint option.
