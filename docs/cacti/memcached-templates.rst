#summary Cacti templates for graphing memcached statistics

<wiki:toc max_depth="1" />

= Overview =

These templates use ss_get_by_ssh.php to connect to a server via SSH and extract statistics from the memcached server running there, by executing the "nc" (netcat) program with the command "STAT".  This means you don't need any memcached APIs installed.  Standard Unix command-line tools are all you need.

This document should be correct and complete as of version 1.1.8 of the graphs.  Please use the issue tracker or the mailing list to report any errors or omissions.  If you have any sample graphs that are better than those shown, please contribute!

= Installation =

Once the [SSHBasedTemplates SSH setup] is working, test one of your hosts like this.  You may need to change some of the example values below, such as the cacti username and the hostname you're connecting to.

{{{
# su - cacti -c 'env -i php /var/www/cacti/scripts/ss_get_by_ssh.php --type memcached --host 127.0.0.1 --items b6,b7'
}}}

you must install `nc` on the memcache server, and on Debian/Ubuntu, you need install `netcat-traditional` package, and switch `nc` to `/bin/nc.traditional` with following command (`netcat-openbsd` does not work)

{{{
# update-alternatives --config nc
}}}


= Additions and Evictions =

This graph shows how many items were added and evicted.

http://mysql-cacti-templates.googlecode.com/svn/data/memcached_additions_and_evictions.png

= Connections =

This graph shows how many connections have been made.

http://mysql-cacti-templates.googlecode.com/svn/data/memcached_connections.png

= Current Items =

This graph shows how many items are stored in the server.

http://mysql-cacti-templates.googlecode.com/svn/data/memcached_current_items.png

= Memory =

This graph shows how much memory the server is using.

http://mysql-cacti-templates.googlecode.com/svn/data/memcached_memory.png

= Requests =

This graph shows how many gets and sets have happened, as well as how many of the gets were misses (there was no item in the cache).

http://mysql-cacti-templates.googlecode.com/svn/data/memcached_requests.png

= Rusage =

This graph shows the resource usage statistics reported by memcached, in system and user CPU time.

http://mysql-cacti-templates.googlecode.com/svn/data/memcached_rusage.png

= Traffic =

This graph shows the network traffic in and out of the memcached server.

http://mysql-cacti-templates.googlecode.com/svn/data/memcached_traffic.png