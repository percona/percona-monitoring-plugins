#summary Changes in the templates and scripts

For instructions on upgrading templates, see UpgradingTemplates.

2011-01-22: version 1.1.8

  * The cache file names could conflict due to omitting --port (issue 171).
  * Load-average parsing did not work correctly at high load (issue 170).
  * The --mpds option to make-template.pl did not create new inputs (issue 133).
  * The url and port were reversed in the Nginx commandline (issue 149).
  * Added $nc_cmd to ss_get_by_ssh.php (issue 154, issue 152).
  * InnoDB Transactions and other graphs showed NaN instead of 0 (issue 159).
  * Added graphs for Percona Server response-time distribution (issue 158).
  * Added graphs for MongoDB (issue 136).
  * Added a minimum option to the template construction logic (issue 169).
  * Added memtotal for Memory (issue 146).
  * make-template.pl sanity checks were too strict (issue 168).

2010-04-20: version 1.1.7

  * Added graphs for Innodb_row_lock_waits and Innodb_row_lock_time (issue 118).
  * Added graphs for the MyISAM key buffer memory consumption (issue 127).
  * The loadavg/users graphs failed when only 1 user was logged in (issue 131).
  * The Apache and Nginx graphs couldn't use the --port2 option (issue 129).
  * The InnoDB Log graph's unflushed_log should be GAUGE not COUNTER (issue 10).
  * Added graphs for InnoDB semaphore waits (issue 124).
  * Added Redis graphs (issue 90).
  * Added --openvz_cmd configuration and command-line option (issue 130).
  * Added --mysql_ssl configuration and command-line option (issue 103).
  * Added JMX graphs (--type jmx) (issue 139).
  * Big-integer math printf spec was missing a % character (issue 137).
  * Partially accepted patches from Artur Kaszuba (more remaining in issue 120).

2010-01-10: version 1.1.6

  * Added OpenVZ graphs (--type openvz) (issue 95).
  * Added IO usage graphs (--type diskstats) (issue 97).
  * Added extra error-reporting (issue 110).
  * The $debug $debug_log options couldn't be set in the .cnf file (issue 110).
  * Added a --use-ssh option to ss_get_by_ssh.php (issue 66).
  * Added a debugging log to ss_get_by_ssh.php (issue 54).
  * Enabled caching of results in ss_get_by_ssh.php (issue 46).
  * Added a test suite for ss_get_by_ssh.php (issue 110).
  * The 'free' stats suffered from PHP's issues with big numbers (issue 102).
  * There was ambiguity (but no error) in SHOW STATUS overrides (issue 106).
  * It was hard to debug failures caused by missing ext/mysql (issue 105).
  * Code to make ss_get_mysql_stats.php testable was broken (issue 108).

2009-12-13: version 1.1.5

  * Support for getting slave lag via mk-heartbeat was broken (issue 87).
  * The memcached stats command hung because it lacked "quit" (issue 65).
  * The COUNTER data type caused spikes; switched to DERIVE instead (issue41).
  * LOCK WAIT in an InnoDB transaction could cause an error (issue 91).
  * The cache file name didn't include the MySQL port (issue 82).
  * Added the -q option to the SSH command to quell missing homedir warnings.
  * The --port option to the MySQL templates could not be null.
  * The log_bytes_flushed and log_bytes_written were renamed (issue 81).

2009-10-25: version 1.1.4

  * Changed SSH options so host keys are accepted automatically (issue 68).
  * Parsing of the pending_ibuf_aio_reads property was broken.
  * Parsing of the pending_aio_log_ios property was broken.
  * Parsing of the pending_aio_sync_ios property was broken.
  * Added a debugging log for ss_get_mysql_stats.php (issue 54).
  * Added the --lint_check option to make-template.pl (issue 80).
  * Removed the use of GET_LOCK() and changed to flock() instead (issue 78).
  * The template and script version is now recorded in a GPRINT (issue 79).
  * Restored unflushed_log, which was accidentally deleted in 1.1.3.
  * Added the InnoDB Internal Hash Memory Usage graph (issue 75).
  * Added the InnoDB Checkpoint Age graph (issue 73).
  * Added the InnoDB Insert Buffer Usage graph (issue 74).
  * Added the InnoDB Active/Locked Transactions graph.
  * Added the InnoDB Memory Allocation graph.
  * Added the InnoDB Adaptive Hash Index graph.
  * Added the InnoDB Tables In Use graph (issue 32).
  * Added the InnoDB Current Lock Waits graph.
  * Added the InnoDB Lock Structures graph (issue 32).

2009-10-24: version 1.1.3

  * This is a bug-fix release only, and contains no template changes.
  * To upgrade from the previous release, upgrade ss_get_mysql_stats.php.
  * MySQL 5.1 broke backwards compatibility with table_cache (issue 63).
  * Added a version number to the script (partial fix for issue 79).
  * Added a test suite (issue 76, issue 59).
  * Math operations were done in MySQL instead of PHP (issue 25).
  * SHOW STATUS values didn't override SHOW INNODB STATUS parsing (issue 24).
  * Long error messages were not appearing in the Cacti log.
  * SHOW INNODB STATUS parsing for unpurged_txns was broken.
  * SHOW INNODB STATUS parsing for innodb_lock_structs was broken.
  * SHOW INNODB STATUS parsing for pending_log_flushes was broken (issue 62).
  * SHOW INNODB STATUS parsing for pending_buf_pool_flushes was broken.
  * SHOW INNODB STATUS parsing for pending_ibuf_aio_reads was broken.
  * SHOW INNODB STATUS parsing for pending_aio_log_ios was broken.
  * SHOW INNODB STATUS parsing for pending_aio_sync_ios was broken.
  * Made SHOW INNODB STATUS parsing less sensitive to false positive matches.

2009-05-07: version 1.1.2

  * The parsing code did not handle InnoDB plugin / XtraDB (issue 52).
  * The servername was hardcoded in ss_get_by_ssh.php (issue 57).
  * Added Handler_ graphs (issue 47).
  * Config files can be used instead of editing the .php file (issue 39).
  * binary log space is now calculated without a MySQL query (issue 48).
  * There was no easy way to force inputs to be filled (issue 45).
  * Some graphs were partially hidden without --lower-limit (issue 43).
  * Flipped some elements across the Y axis (issue 42).
  * Added Apache, Nginx, and GNU/Linux templates.
  * Unknown output is now -1 instead of 0 to prevent spikes in graphs.
  * If you want to use a script server, you must now explicitly configure it.
  * UNIX sockets weren't permitted for MySQL (issue 38).

2008-10-15: version 1.1.1

  * The tarball didn't have make-template.pl mysql_definitions.pl (issue 34)

2008-10-14: version 1.1.0

  * Graphs fetched too much data, causing errors (incompatible; issue 28, 23).
  * Output of the poller script is compressed with short value names.
  * Checks can be disabled; no need to fetch INNODB STATUS if unwanted.
  * Queries could cause a MySQL thread stack overflow (issue 19).
  * Older PHP didn't have array_change_key_case function (issue 21).
  * The PROCESS privilege is required for MySQL 5.1.29 with InnoDB (issue 22).
  * Added an aggregated view of SHOW PROCESSLIST; requires PROCESS privilege.
  * The text on the graph could overflow the right-hand edge.
  * Truncated SHOW INNODB STATUS could cause an SQL error (issue 27).
  * The poller script requires proper cmdline options (incompatible change).

2008-06-01: version 1.0.0

  * Fixed when SHOW MASTER LOGS has no File_size column.
  * Fixed Cacti-version-specific problems with include files.
  * Fixed when binary log is not enabled.
  * Fixed some caching issues.
  * Fixed make-template.pl issues when downloaded from SVN.
  * Replication graph shows only slave_lag instead of Seconds_behind_master
  * Generate a version for Cacti 0.8.6i.
  * Support generating custom versions with make-template.pl.

2008-04-27:

  * Initial release.