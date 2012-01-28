#summary Cacti templates for Unix system statistics

<wiki:toc max_depth="1" />

= Overview =

These templates use ss_get_by_ssh.php to connect to a server via SSH and extract standard metrics (memory usage, number of users, CPU usage, etc) from it.  This is a good substitute for the standard kinds of system metrics one might graph via SNMP, when SNMP is not available or not desired.  For example, I've used this technique when SELinux was preventing SNMP and the company's security policy forbade modifications; or when they didn't want to pay for the time it'd take; or when monitoring servers exposed all over the Internet, and only SSH access was desired.

Right now the scripts are written and tested for GNU/Linux, but it is possible that they will work on other Unix-like operating systems.  It should certainly be easy to modify them if not, so if you find any problems, please submit bug reports or discuss on the mailing list.

This document should be correct and complete as of version 1.1.8 of the graphs.  Please use the issue tracker or the mailing list to report any errors or omissions.  If you have any sample graphs that are better than those shown, please contribute!

= Installation =

No special installation is necessary for most of the graphs.  Once the [SSHBasedTemplates SSH setup] is working, everything should just work.

*The disk I/O graphs are special*.  Each graph requires that you specify the device you want to graph.  For /dev/sda, for example, you should specify "sda".  Do not create the graphs through the normal host template method.  Rather, add the graphs to the host manually, one at a time, by clicking "Create Graph" and selecting the desired graph template.  Edit not only the device name in the command line, but the name of the graph and data input.  Append the name of the device.  This will make the items visually distinctive.

See the following screenshot for an example:

http://mysql-cacti-templates.googlecode.com/svn/data/add_unix_disk_graph.png

You should append "sda" in every textbox shown in that screenshot, if you want to monitor /dev/sda.  Use the device name as it appears in /proc/diskstats.

= Context Switches =

This graph shows the number of context switches performed by the server.

http://mysql-cacti-templates.googlecode.com/svn/data/unix_context_switches.png

= CPU Usage =

This graph shows CPU usage as derived from the /proc filesystem.  The example shows a server with two CPUs.  The values will increase by 100 with each added CPU.

http://mysql-cacti-templates.googlecode.com/svn/data/unix_cpu_usage.png

= Forks =

This graph shows the number of new processes created by the system.

http://mysql-cacti-templates.googlecode.com/svn/data/unix_forks.png

= Interrupts =

This graph shows how many interrupts the system handles.

http://mysql-cacti-templates.googlecode.com/svn/data/unix_interrupts.png

= Load Average =

This graph shows system load average.  If you're used to looking at a "pretty" load average graph, you might think this one has less information.  Not so!  The standard graph that comes with Cacti is very silly: it shows the same information averaged over three time intervals, which is useless and redundant.  RRDtool can average the number for you just fine.

http://mysql-cacti-templates.googlecode.com/svn/data/unix_load_average.png

= Memory =

This graph shows the system's memory usage, as reported by the "free" command.

http://mysql-cacti-templates.googlecode.com/svn/data/unix_memory.png

= Number of Users =

This graph shows how many users were logged into the system, as reported by the "w" command.

http://mysql-cacti-templates.googlecode.com/svn/data/unix_number_of_users.png

= Disk Operations =

This graph shows how many read and write operations were completed, and how many reads and writes were merged.

http://mysql-cacti-templates.googlecode.com/svn/data/disk_operations.png

= Disk Sectors Read/Written =

This graph shows how many disk sectors were read and written.

http://mysql-cacti-templates.googlecode.com/svn/data/disk_sectors_read_written.png

= Disk Read/Write Time (ms) =

This graph shows how much time was spent reading and writing.

http://mysql-cacti-templates.googlecode.com/svn/data/disk_read_write_time.png

= Disk Elapsed IO Time (ms) =

This graph shows how much time was spent in disk I/O overall (busy time), and how much weighted time was spent doing disk I/O.  The latter is a useful indication of I/O backlog.  The weighted time is the number of requests multiplied by the busy time, so if there are 5 requests that take 1 second, it is 5 seconds.  (If they all happen at the same time, the busy time is only 1 second.)

http://mysql-cacti-templates.googlecode.com/svn/data/disk_elapsed_io_time.png