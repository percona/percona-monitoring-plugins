#summary Cacti templates for graphing JMX

<wiki:toc max_depth="1" />

= Overview =

These templates use ss_get_by_ssh.php to connect to a server via SSH and extract
statistics from the JMX server.  These templates were added in version 1.1.7 of the graphs.

This document should be correct and complete as of version 1.1.8 of the graphs.
Please use the issue tracker or the mailing list to report any errors or
omissions.

= Installation =

Once the [SSHBasedTemplates SSH setup] is working, you should make the Java
runtime information available through JMX by adding the JMX system properties
when you start the program you want to monitor. For a normal Java program, you
can learn more about this from
[http://java.sun.com/j2se/1.5.0/docs/guide/management/agent.html Monitoring and
Management Using JMX]. If you are using Tomcat, you can read
[http://tomcat.apache.org/tomcat-6.0-doc/monitoring.html Monitoring and Managing
Tomcat]. A simple example of how to start Notepad.jar with JMX instrumentation
follows:

{{{
$ java -jar -Dcom.sun.management.jmxremote \
-Dcom.sun.management.jmxremote.port=9012 \
-Dcom.sun.management.jmxremote.ssl=false \
-Dcom.sun.magement.jmxremote.authenticate=false \
/path/to/Notepad.jar
}}}

Note: There should be a way to export JMX information only to localhost;
currently you need to configure the firewall to block visits from outside.  If
you know how to do this better, please contribute your knowledge!

Then you need to install ant and the XML file with the JMX definitions. Copy
misc/jmx-monitor.xml (or download
[http://mysql-cacti-templates.googlecode.com/svn/trunk/misc/jmx-monitor.xml
jmx-monitor.xml]) to the monitoring user's `$HOME` directory on the server you
want to monitor. Then download catalina-ant-jmx.jar (this file is part of
[http://tomcat.apache.org/download-60.cgi tomcat]) to the `$HOME/.ant/lib`
directory.

Before you test the Cacti script's functionality, test that the instrumentation
is available to JMX, by running the following command on the host you want to
monitor, from the Cacti user's home directory.  Replace any values as needed:

{{{
ant -Djmx.server.port=9012 -e -q -f jmx-monitor.xml
}}}

Now on the Cacti host, test a command similar to the following, replacing any
values necessary with ones appropriate for your environment:

{{{
# su - cacti -c 'env -i php /var/www/cacti/scripts/ss_get_by_ssh.php --type jmx --host 127.0.0.1 --items d4,d5'
}}}

= JMX File Descriptor =
This graph shows the file descriptor used by this process.

http://mysql-cacti-templates.googlecode.com/svn/data/jmx-file-descriptor.png


= JMX Heap Memory Usage =
This graph shows the heap memory usage used by this process.

http://mysql-cacti-templates.googlecode.com/svn/data/jmx-heap-memory-usage.png


= JMX Non-Heap Memory Usage =
This graph shows the non-heap memory usage used by this process.

http://mysql-cacti-templates.googlecode.com/svn/data/jmx-nonheap-memory-usage.png