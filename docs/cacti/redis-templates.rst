#summary Cacti templates for graphing Redis

<wiki:toc max_depth="1" />

= Overview =

These templates use ss_get_by_ssh.php to connect to a server and extract statistics from the Redis server with the [http://code.google.com/p/redis/wiki/InfoCommand INFO command].  The templates *do not use SSH*, but connect directly with TCP sockets to gather the information.  It is possible that the configuration or code involved in this functionality will change in the future.  If it does, UpgradingTemplates will have full instructions.

These graphs were added in version 1.1.7.  This document should be correct and complete as of version 1.1.8.  Please use the issue tracker or the mailing list to report any errors or omissions.  If you have any sample graphs that are better than those shown, please contribute!

= Installation =

Import the Redis template and apply it to your host, then add the graphs.

You can test one of your hosts like this.  You may need to change some of the example values below, such as the cacti username and the hostname you're connecting to.

{{{
# su - cacti -c 'env -i php /var/www/cacti/scripts/ss_get_by_ssh.php --type redis --host 127.0.0.1 --items d3'
}}}

= Redis Commands =

http://mysql-cacti-templates.googlecode.com/svn/data/Redis_Commands.png

= Redis Connections =

The top two items are *current* connections at the time the poller sampled the data; the bottom line, Total Connections, is the number of new connections created per second during the polling interval.  That's the important number to watch, and despite the name it should not be equal to the sum of the first two lines!

http://mysql-cacti-templates.googlecode.com/svn/data/Redis_Connections.png

= Redis Memory =

http://mysql-cacti-templates.googlecode.com/svn/data/Redis_Memory.png

= Redis Unsaved Changes =

http://mysql-cacti-templates.googlecode.com/svn/data/Redis_Unsaved_Changes.png