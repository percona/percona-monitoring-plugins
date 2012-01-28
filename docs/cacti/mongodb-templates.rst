#summary Cacti templates for graphing MongoDB

= Overview =

These templates were added in version 1.1.8.  They use ss_get_by_ssh.php to connect to a server via SSH and extract statistics from the MongoDB server running there, by executing the "serverStatus" admin command from the MongoDB shell. This means that the mongo CLI needs to be in $PATH and you must be running version 1.2+ of MongoDB.

This document should be correct and complete as of version 1.1.8 of the graphs. Please use the issue tracker or the mailing list to report any errors or omissions. If you have any sample graphs that are better than those shown, please contribute!

= Installation =

Once the [SSHBasedTemplates SSH setup] is working, confirm that you can login to MongoDB from with the "mongo" cli tool. From this tool, confirm that serverStatus command is present by running:

{{{
db._adminCommand({serverStatus : 1});
}}}

This should produce quite a bit of output. With all of this confirmed, test one of your hosts with the command below. You may need to change some of the example values below, such as the cacti username and the hostname you're connecting to.

{{{
su - cacti -c 'env -i php /var/www/cacti/scripts/ss_get_by_ssh.php --type mongodb --host 127.0.0.1 --items dc,dd'
}}}

= Background Flushes =

http://mysql-cacti-templates.googlecode.com/svn/data/mongodb_background_flushes.png

= Commands =

http://mysql-cacti-templates.googlecode.com/svn/data/mongodb_commands.png

= Connections =

http://mysql-cacti-templates.googlecode.com/svn/data/mongodb_connections.png

= Index Operations =

http://mysql-cacti-templates.googlecode.com/svn/data/mongodb_index_ops.png

= Memory =

http://mysql-cacti-templates.googlecode.com/svn/data/mongodb_memory.png