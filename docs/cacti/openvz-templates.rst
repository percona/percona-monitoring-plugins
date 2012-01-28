#summary Cacti templates for graphing OpenVZ

<wiki:toc max_depth="1" />

= Overview =

These templates use ss_get_by_ssh.php to connect to a server via SSH and extract statistics from the OpenVZ container, by concatenating the contents of /proc/user_beancounters to standard output.  This means you don't need to install any special tools.  Standard Unix command-line tools are all you need.

This document should be correct and complete as of version 1.1.8 of the graphs.  Please use the issue tracker or the mailing list to report any errors or omissions.  If you have any sample graphs that are better than those shown, please contribute!

= Installation =

Once the [SSHBasedTemplates SSH setup] is working, import the OpenVZ template and apply it to your host, then add the graphs.

Depending on your version of OpenVZ or Virtuozzo, the file /proc/user_beancounters might not be accessible to ordinary users.  This means you either need to SSH as root, or use a program such as [http://www.labradordata.ca/home/35 beanc] to read the file.  If you choose the latter approach, you should change the $openvz_cmd configuration variable, which was added in version 1.1.7 of the graphs.

You can test one of your hosts like this.  You may need to change some of the example values below, such as the cacti username and the hostname you're connecting to.

{{{
# su - cacti -c 'env -i php /var/www/cacti/scripts/ss_get_by_ssh.php --type openvz --host 127.0.0.1 --items c0,c1'
}}}

= OpenVZ Kernel Memory =

Graph example is TODO.

= OpenVZ Pages =

Graph example is TODO.

= OpenVZ Sockets =

Graph example is TODO.

= OpenVZ Processes =

Graph example is TODO.

= OpenVZ Files =

Graph example is TODO.

= OpenVZ Signals =

Graph example is TODO.

= OpenVZ Buffers =

Graph example is TODO.

= OpenVZ Dentry/Inode Cache =

Graph example is TODO.

= OpenVZ NETFILTER Entries =


Graph example is TODO.