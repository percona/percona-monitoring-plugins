#summary Cacti templates for graphing Nginx

<wiki:toc max_depth="1" />

= Overview =

These templates use ss_get_by_ssh.php to connect to a server via SSH and extract statistics from the Nginx server running there, by executing the "wget" program with the url "/server-status".  This means you don't need to install any special tools.  Standard Unix command-line tools are all you need.

This document should be correct and complete as of version 1.1.8 of the graphs.  Please use the issue tracker or the mailing list to report any errors or omissions.  If you have any sample graphs that are better than those shown, please contribute!

= Installation =

Once the [SSHBasedTemplates SSH setup] is working, configure Nginx to report its status.  You can add the following to any server context and restart Nginx:

{{{
location /server-status {
   stub_status on;
   allow 127.0.0.1
   # deny all;
}
}}}

If you decide to use a different URL, you'll have to configure that in the script configuration (covered in the general install guide) or pass a command-line option (also covered in the general install guide).

Finally, test one of your hosts like this.  You may need to change some of the example values below, such as the cacti username and the hostname you're connecting to.

{{{
# su - cacti -c 'env -i php /var/www/cacti/scripts/ss_get_by_ssh.php --type nginx --host 127.0.0.1 --items az,b0'

}}}

= Accepts and Handled =

This graph shows how many connections the server accepted and handled.

http://mysql-cacti-templates.googlecode.com/svn/data/nginx_accepts_handled.png

= Requests =

This graph shows how many requests the Nginx server received.

http://mysql-cacti-templates.googlecode.com/svn/data/nginx_requests.png

= Scoreboard =

This graph shows how many connections to the Nginx servers are in various states.

http://mysql-cacti-templates.googlecode.com/svn/data/nginx_scoreboard.png