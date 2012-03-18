<?php

# ============================================================================
# This program is part of $PROJECT_NAME$
# License: GPL License (see COPYING)
# Copyright 2008-$CURRENT_YEAR$ Baron Schwartz, 2012-$CURRENT_YEAR$ Percona Inc.
# Authors:
#  Baron Schwartz
# ============================================================================

# ============================================================================
# To make this code testable, we need to prevent code from running when it is
# included from the test script.  The test script and this file have different
# filenames, so we can compare them.  In some cases $_SERVER['SCRIPT_FILENAME']
# seems not to be defined, so we skip the check -- this check should certainly
# pass in the test environment.
# ============================================================================
if ( !array_key_exists('SCRIPT_FILENAME', $_SERVER)
   || basename(__FILE__) == basename($_SERVER['SCRIPT_FILENAME']) ) {

# ============================================================================
# CONFIGURATION
# ============================================================================
# Define parameters.  Instead of defining parameters here, you can define them
# in another file named the same as this file, with a .cnf extension.
# ============================================================================
$ssh_user   = 'cacti';                          # SSH username
$ssh_port   = 22;                               # SSH port
$ssh_iden   = '-i /var/www/cacti/.ssh/id_rsa';  # SSH identity
$ssh_tout   = 10;                               # SSH connect timeout
$nc_cmd     = 'nc -C -q1';                      # How to invoke netcat
$cache_dir  = '/tmp';  # If set, this uses caching to avoid multiple calls.
$poll_time  = 300; # Adjust to match your polling interval.
$timezone   = null;    # If not set, uses the system default.  Example: "UTC"
$use_ss     = FALSE; # Whether to use the script server or not
$use_ssh    = TRUE;  # Whether to connect via SSH or not (default yes).
$debug      = FALSE; # Define whether you want debugging behavior.
$debug_log  = FALSE; # If $debug_log is a filename, it'll be used.

# Parameters for specific graphs can be specified here, or in the .cnf file.
$status_server = 'localhost';             # Where to query for HTTP status
$status_url    = '/server-status';        # The URL path to HTTP status
$http_user     = '';                      # HTTP authentication
$http_pass     = '';                      # HTTP authentication
$http_port     = 80;                      # Which port Apache listens on
$memcache_port = 11211;                   # Which port memcached listens on
$redis_port    = 6379;                    # Which port redis listens on
                                          # How to get openvz stats
$openvz_cmd    = 'cat /proc/user_beancounters';

# ============================================================================
# You should not need to change anything below this line.
# ============================================================================
$version = '$VERSION$';

# ============================================================================
# Include settings from an external config file.
# ============================================================================
if ( file_exists(__FILE__ . '.cnf' ) ) {
   debug("Found configuration file " . __FILE__ . ".cnf");
   require(__FILE__ . '.cnf');
}

# Make this a happy little script even when there are errors.
$no_http_headers = true;
ini_set('implicit_flush', false); # No output, ever.
if ( $debug ) {
   ini_set('display_errors', true);
   ini_set('display_startup_errors', true);
   ini_set('error_reporting', 2147483647);
}
else {
   ini_set('error_reporting', E_ERROR);
}
ob_start(); # Catch all output such as notices of undefined array indexes.
function error_handler($errno, $errstr, $errfile, $errline) {
   print("$errstr at $errfile line $errline\n");
   debug("$errstr at $errfile line $errline");
}
# ============================================================================
# Set up the stuff we need to be called by the script server.
# ============================================================================
if ( $use_ss ) {
   if ( file_exists( dirname(__FILE__) . "/../include/global.php") ) {
      # See issue 5 for the reasoning behind this.
      debug("including " . dirname(__FILE__) . "/../include/global.php");
      include_once(dirname(__FILE__) . "/../include/global.php");
   }
   elseif ( file_exists( dirname(__FILE__) . "/../include/config.php" ) ) {
      # Some Cacti installations don't have global.php.
      debug("including " . dirname(__FILE__) . "/../include/config.php");
      include_once(dirname(__FILE__) . "/../include/config.php");
   }
}

# ============================================================================
# Set the default timezone either to the configured, system timezone, or the
# default set above in the script.
# ============================================================================
if ( function_exists("date_default_timezone_set")
   && function_exists("date_default_timezone_get") ) {
   $tz = ($timezone ? $timezone : @date_default_timezone_get());
   if ( $tz ) {
      @date_default_timezone_set($tz);
   }
}

# ============================================================================
# Make sure we can also be called as a script.
# ============================================================================
if (!isset($called_by_script_server)) {
   debug($_SERVER["argv"]);
   array_shift($_SERVER["argv"]); # Strip off this script's filename
   $options = parse_cmdline($_SERVER["argv"]);
   validate_options($options);
   $result = ss_get_by_ssh($options);
   debug($result);
   if ( !$debug ) {
      # Throw away the buffer, which ought to contain only errors.
      ob_end_clean();
   }
   else {
      ob_end_flush(); # In debugging mode, print out the errors.
   }
   print($result);
}

# ============================================================================
# End "if file was not included" section.
# ============================================================================
}

# ============================================================================
# Work around the lack of array_change_key_case in older PHP.
# ============================================================================
if ( !function_exists('array_change_key_case') ) {
   function array_change_key_case($arr) {
      $res = array();
      foreach ( $arr as $key => $val ) {
         $res[strtolower($key)] = $val;
      }
      return $res;
   }
}

# ============================================================================
# Extracts the desired bits from a string and returns them.
# ============================================================================
function extract_desired ( $options, $text ) {
   debug($text);
   # Split the result up and extract only the desired parts of it.
   $wanted = explode(',', $options['items']);
   $output = array();
   foreach ( explode(' ', $text) as $item ) {
      if ( in_array(substr($item, 0, 2), $wanted) ) {
         $output[] = $item;
      }
   }
   $result = implode(' ', $output);
   debug($result);
   return $result;
}

# ============================================================================
# Validate that the command-line options are here and correct
# ============================================================================
function validate_options($options) {
   debug($options);
   $opts = array('host', 'port', 'items', 'nocache', 'type', 'url', 'http-user',
                 'file', 'http-password', 'server', 'port2', 'use-ssh', 
                 'device', 'volume', 'threadpool');
   # Required command-line options
   foreach ( array('host', 'items', 'type') as $option ) {
      if ( !isset($options[$option]) || !$options[$option] ) {
         usage("Required option --$option is missing");
      }
   }
   foreach ( $options as $key => $val ) {
      if ( !in_array($key, $opts) ) {
         usage("Unknown option --$key");
      }
   }
}

# ============================================================================
# Print out a brief usage summary
# ============================================================================
function usage($message) {
   $usage = <<<EOF
$message
Usage: php ss_get_by_ssh.php --host <host> --items <item,...> [OPTION]

Command-line options ALWAYS require a value after them.  If you specify an
option without a value after it, the option is ignored.  For options such as
--nocache, you can say "--nocache 1".

General options:

   --device          The device name for diskstats and netdev
   --file            Get input from this file instead of via SSH command
   --host            Hostname to connect to (via SSH)
   --items           Comma-separated list of the items whose data you want
   --nocache         Do not cache results in a file
   --port            SSH port to connect to (SSH port, not application port!)
   --port2           Port on which the application listens, such as memcached
                     port, redis port, or apache port.
   --server          The server (DNS name or IP address) from which to fetch the
                     desired data after SSHing.  Default is 'localhost' for HTTP
                     stats and --host for memcached stats. If you specify
                     '--use-ssh 0' then default is --host for HTTP stats too.
   --threadpool      Name of ThreadPool in JMX (i.e. http-8080 or jk-8009)
   --type            One of apache, nginx, proc_stat, w, memory, memcached,
                     diskstats, openvz, redis, jmx, mongodb, df, netdev, 
                     netstat, vmstat (more are TODO)
   --url             The url, such as /server-status, where server status lives
   --use-ssh         Whether to connect via SSH to gather info (default yes).
   --http-user       The HTTP authentication user
   --http-password   The HTTP authentication password
   --openvz_cmd      The command to use when fetching OpenVZ statistics
   --volume          The volume name for df

EOF;
   die($usage);
}

# ============================================================================
# Parse command-line arguments, in the format --arg value --arg value, and
# return them as an array ( arg => value )
# ============================================================================
function parse_cmdline( $args ) {
   $result = array();
   for ( $i = 0; $i < count($args); ++$i ) {
      if ( strpos($args[$i], '--') === 0 ) {
         if ( $i + 1 < count($args) && strpos($args[$i + 1], '--') !== 0 ) {
            # The next element should be the value for this option.
            $result[substr($args[$i], 2)] = $args[$i + 1];
            ++$i;
         }
      }
   }
   debug($result);
   return $result;
}

# ============================================================================
# This is the main function.  Some parameters are filled in from defaults at the
# top of this file.
# ============================================================================
function ss_get_by_ssh( $options ) {
   global $debug, $cache_dir, $poll_time;

   # Build and test the type-specific function names.
   $caching_func = "$options[type]_cachefile";
   $cmdline_func = "$options[type]_cmdline";
   $parsing_func = "$options[type]_parse";
   $getting_func = "$options[type]_get";
   debug("Functions: '$caching_func', '$cmdline_func', '$parsing_func'");
   if ( !function_exists($cmdline_func) ) {
      die("The parsing function '$cmdline_func' does not exist");
   }
   if ( !function_exists($parsing_func) ) {
      die("The parsing function '$parsing_func' does not exist");
   }

   # Check the cache.
   $fp = null;
   if ( !isset($options['file']) && $cache_dir && !isset($options['nocache'])
      && function_exists($caching_func)
   ) {
      $cache_file = call_user_func($caching_func, $options);
      $cache_res  = check_cache($cache_dir, $poll_time, $cache_file, $options);
      if ( $cache_res[1] ) {
         debug("The cache is usable.");
         return extract_desired($options, $cache_res[1]);
      }
      elseif ( $cache_res[0] ) {
         $fp = $cache_res[0];
         debug("Got a filehandle to the cache file");
      }
   }
   if ( !$fp ) {
      debug("Caching is disabled.");
   }

   # There might be a custom function that overrides the SSH fetch.
   if ( !isset($options['file']) && function_exists($getting_func) ) {
      debug("$getting_func() is defined, will call it");
      $output = call_user_func($getting_func, $options);
   }
   else {
      # Get the command-line to fetch the data, then fetch and parse the data.
      debug("No getting_func(), will use normal code path");
      $cmd = call_user_func($cmdline_func, $options);
      debug($cmd);
      $output = get_command_result($cmd, $options);
   }
   debug($output);
   $result = call_user_func($parsing_func, $options, $output);

   # Define the variables to output.  I use shortened variable names so maybe
   # it'll all fit in 1024 bytes for Cactid and Spine's benefit.  However, don't
   # use things that have only hex characters, thus begin with 'g0' to avoid a
   # bug in Cacti.  This list must come right after the word
   # MAGIC_VARS_DEFINITIONS.  The Perl script parses it and uses it as a Perl
   # variable.
   $keys = array(
      'APACHE_Requests'                   =>  'g0',
      'APACHE_Bytes_sent'                 =>  'g1',
      'APACHE_Idle_workers'               =>  'g2',
      'APACHE_Busy_workers'               =>  'g3',
      'APACHE_CPU_Load'                   =>  'g4',
      'APACHE_Waiting_for_connection'     =>  'g5',
      'APACHE_Starting_up'                =>  'g6',
      'APACHE_Reading_request'            =>  'g7',
      'APACHE_Sending_reply'              =>  'g8',
      'APACHE_Keepalive'                  =>  'g9',
      'APACHE_DNS_lookup'                 =>  'ga',
      'APACHE_Closing_connection'         =>  'gb',
      'APACHE_Logging'                    =>  'gc',
      'APACHE_Gracefully_finishing'       =>  'gd',
      'APACHE_Idle_cleanup'               =>  'ge',
      'APACHE_Open_slot'                  =>  'gf',
      'STAT_CPU_user'                     =>  'gg',
      'STAT_CPU_nice'                     =>  'gh',
      'STAT_CPU_system'                   =>  'gi',
      'STAT_CPU_idle'                     =>  'gj',
      'STAT_CPU_iowait'                   =>  'gk',
      'STAT_CPU_irq'                      =>  'gl',
      'STAT_CPU_softirq'                  =>  'gm',
      'STAT_CPU_steal'                    =>  'gn',
      'STAT_CPU_guest'                    =>  'go',
      'STAT_interrupts'                   =>  'gp',
      'STAT_context_switches'             =>  'gq',
      'STAT_forks'                        =>  'gr',
      'STAT_loadavg'                      =>  'gs',
      'STAT_numusers'                     =>  'gt',
      'STAT_memcached'                    =>  'gu',
      'STAT_membuffer'                    =>  'gv',
      'STAT_memshared'                    =>  'gw',
      'STAT_memfree'                      =>  'gx',
      'STAT_memused'                      =>  'gy',
      'STAT_memtotal'                     =>  'jv',
      'NGINX_active_connections'          =>  'gz',
      'NGINX_server_accepts'              =>  'h0',
      'NGINX_server_handled'              =>  'h1',
      'NGINX_server_requests'             =>  'h2',
      'NGINX_reading'                     =>  'h3',
      'NGINX_writing'                     =>  'h4',
      'NGINX_waiting'                     =>  'h5',
      'MEMC_rusage_user'                  =>  'h6',
      'MEMC_rusage_system'                =>  'h7',
      'MEMC_curr_items'                   =>  'h8',
      'MEMC_total_items'                  =>  'h9',
      'MEMC_bytes'                        =>  'ha',
      'MEMC_curr_connections'             =>  'hb',
      'MEMC_total_connections'            =>  'hc',
      'MEMC_cmd_get'                      =>  'hd',
      'MEMC_cmd_set'                      =>  'he',
      'MEMC_get_misses'                   =>  'hf',
      'MEMC_evictions'                    =>  'hg',
      'MEMC_bytes_read'                   =>  'hh',
      'MEMC_bytes_written'                =>  'hi',
      'DISK_reads'                        =>  'hj',
      'DISK_reads_merged'                 =>  'hk',
      'DISK_sectors_read'                 =>  'hl',
      'DISK_time_spent_reading'           =>  'hm',
      'DISK_writes'                       =>  'hn',
      'DISK_writes_merged'                =>  'ho',
      'DISK_sectors_written'              =>  'hp',
      'DISK_time_spent_writing'           =>  'hq',
      'DISK_io_ops_in_progress'           =>  'hr',
      'DISK_io_time'                      =>  'hs',
      'DISK_io_time_weighted'             =>  'ht',
      'OPVZ_kmemsize_held'                =>  'hu',
      'OPVZ_kmemsize_failcnt'             =>  'hv',
      'OPVZ_lockedpages_held'             =>  'hw',
      'OPVZ_lockedpages_failcnt'          =>  'hx',
      'OPVZ_privvmpages_held'             =>  'hy',
      'OPVZ_privvmpages_failcnt'          =>  'hz',
      'OPVZ_shmpages_held'                =>  'i0',
      'OPVZ_shmpages_failcnt'             =>  'i1',
      'OPVZ_numproc_held'                 =>  'i2',
      'OPVZ_numproc_failcnt'              =>  'i3',
      'OPVZ_physpages_held'               =>  'i4',
      'OPVZ_physpages_failcnt'            =>  'i5',
      'OPVZ_vmguarpages_held'             =>  'i6',
      'OPVZ_vmguarpages_failcnt'          =>  'i7',
      'OPVZ_oomguarpages_held'            =>  'i8',
      'OPVZ_oomguarpages_failcnt'         =>  'i9',
      'OPVZ_numtcpsock_held'              =>  'ia',
      'OPVZ_numtcpsock_failcnt'           =>  'ib',
      'OPVZ_numflock_held'                =>  'ic',
      'OPVZ_numflock_failcnt'             =>  'id',
      'OPVZ_numpty_held'                  =>  'ie',
      'OPVZ_numpty_failcnt'               =>  'if',
      'OPVZ_numsiginfo_held'              =>  'ig',
      'OPVZ_numsiginfo_failcnt'           =>  'ih',
      'OPVZ_tcpsndbuf_held'               =>  'ii',
      'OPVZ_tcpsndbuf_failcnt'            =>  'ij',
      'OPVZ_tcprcvbuf_held'               =>  'ik',
      'OPVZ_tcprcvbuf_failcnt'            =>  'il',
      'OPVZ_othersockbuf_held'            =>  'im',
      'OPVZ_othersockbuf_failcnt'         =>  'in',
      'OPVZ_dgramrcvbuf_held'             =>  'io',
      'OPVZ_dgramrcvbuf_failcnt'          =>  'ip',
      'OPVZ_numothersock_held'            =>  'iq',
      'OPVZ_numothersock_failcnt'         =>  'ir',
      'OPVZ_dcachesize_held'              =>  'is',
      'OPVZ_dcachesize_failcnt'           =>  'it',
      'OPVZ_numfile_held'                 =>  'iu',
      'OPVZ_numfile_failcnt'              =>  'iv',
      'OPVZ_numiptent_held'               =>  'iw',
      'OPVZ_numiptent_failcnt'            =>  'ix',
      'REDIS_connected_clients'           =>  'iy',
      'REDIS_connected_slaves'            =>  'iz',
      'REDIS_used_memory'                 =>  'j0',
      'REDIS_changes_since_last_save'     =>  'j1',
      'REDIS_total_connections_received'  =>  'j2',
      'REDIS_total_commands_processed'    =>  'j3',
      'JMX_heap_memory_used'              =>  'j4',
      'JMX_heap_memory_committed'         =>  'j5',
      'JMX_heap_memory_max'               =>  'j6',
      'JMX_non_heap_memory_used'          =>  'j7',
      'JMX_non_heap_memory_committed'     =>  'j8',
      'JMX_non_heap_memory_max'           =>  'j9',
      'JMX_open_file_descriptors'         =>  'ja',
      'JMX_max_file_descriptors'          =>  'jb',
      'JMX_current_threads_busy'          =>  'kl',
      'JMX_current_thread_count'          =>  'km',
      'JMX_max_threads'                   =>  'kn',
      'MONGODB_connected_clients'         =>  'jc',
      'MONGODB_used_resident_memory'      =>  'jd',
      'MONGODB_used_mapped_memory'        =>  'je',
      'MONGODB_used_virtual_memory'       =>  'jf',
      'MONGODB_index_accesses'            =>  'jg',
      'MONGODB_index_hits'                =>  'jh',
      'MONGODB_index_misses'              =>  'ji',
      'MONGODB_index_resets'              =>  'jj',
      'MONGODB_back_flushes'              =>  'jk',
      'MONGODB_back_total_ms'             =>  'jl',
      'MONGODB_back_average_ms'           =>  'jm',
      'MONGODB_back_last_ms'              =>  'jn',
      'MONGODB_op_inserts'                =>  'jo',
      'MONGODB_op_queries'                =>  'jp',
      'MONGODB_op_updates'                =>  'jq',
      'MONGODB_op_deletes'                =>  'jr',
      'MONGODB_op_getmores'               =>  'js',
      'MONGODB_op_commands'               =>  'jt',
      'MONGODB_slave_lag'                 =>  'ju',
      'DISKFREE_used'                     =>  'jw',
      'DISKFREE_available'                =>  'jx',
      'NETDEV_rxbytes'                    =>  'jy',
      'NETDEV_rxerrs'                     =>  'jz',
      'NETDEV_rxdrop'                     =>  'k0',
      'NETDEV_rxfifo'                     =>  'k1',
      'NETDEV_rxframe'                    =>  'k2',
      'NETDEV_txbytes'                    =>  'k3',
      'NETDEV_txerrs'                     =>  'k4',
      'NETDEV_txdrop'                     =>  'k5',
      'NETDEV_txfifo'                     =>  'k6',
      'NETDEV_txcolls'                    =>  'k7',
      'NETDEV_txcarrier'                  =>  'k8',
      'NETSTAT_established'               =>  'k9',
      'NETSTAT_syn_sent'                  =>  'ka',
      'NETSTAT_syn_recv'                  =>  'kb',
      'NETSTAT_fin_wait1'                 =>  'kc',
      'NETSTAT_fin_wait2'                 =>  'kd',
      'NETSTAT_time_wait'                 =>  'ke',
      'NETSTAT_close'                     =>  'kf',
      'NETSTAT_close_wait'                =>  'kg',
      'NETSTAT_last_ack'                  =>  'kh',
      'NETSTAT_listen'                    =>  'ki',
      'NETSTAT_closing'                   =>  'kj',
      'NETSTAT_unknown'                   =>  'kk',
      'VMSTAT_pswpin'                     =>  'ko',
      'VMSTAT_pswpout'                    =>  'kp',
   );

   # Prepare and return the output.  The output we have right now is the whole
   # info, and we need that -- to write it to the cache file -- but what we
   # return should be only the desired items.
   $output = array();
   foreach ($keys as $key => $short ) {
      # If the value isn't defined, return -1 which is lower than (most graphs')
      # minimum value of 0, so it'll be regarded as a missing value.
      $val      = isset($result[$key]) ? $result[$key] : -1;
      $output[] = "$short:$val";
   }
   $result = implode(' ', $output);
   if ( $fp ) {
      if ( fwrite($fp, $result) === FALSE ) {
         die("Cannot write to '$cache_file'");
      }
      fclose($fp);
   }
   return extract_desired($options, $result);
}

# ============================================================================
# Checks the cache file.  If its contents are valid, return them.  Otherwise
# return the filehandle, locked with flock() and ready for writing.  Return an
# array:
#  0 => $fp       The file pointer for the cache file
#  1 => $arr      The contents of the file, if it's valid.
# ============================================================================
function check_cache ( $cache_dir, $poll_time, $filename, $options ) {
   $cache_file = "$cache_dir/${filename}_cacti_stats.txt";
   debug("Cache file: $cache_file");
   if ( $fp = fopen($cache_file, 'a+') ) {
      $locked = flock($fp, 1); # LOCK_SH
      if ( $locked ) {
         if ( filesize($cache_file) > 0
            && filectime($cache_file) + ($poll_time/2) > time()
            && ($arr = file($cache_file))
         ) {# The cache file is good to use.
            debug("Using the cache file");
            fclose($fp);
            return array(null, $arr[0]);
         }
         else {
            debug("The cache file seems too small or stale");
            # Escalate the lock to exclusive, so we can write to it.
            if ( flock($fp, 2) ) { # LOCK_EX
               # We might have blocked while waiting for that LOCK_EX, and
               # another process ran and updated it.  Let's see if we can just
               # return the data now:
               if ( filesize($cache_file) > 0
                  && filectime($cache_file) + ($poll_time/2) > time()
                  && ($arr = file($cache_file))
               ) { # The cache file is good to use.
                  debug("Using the cache file");
                  fclose($fp);
                  return array(null, $arr[0]);
               }
               ftruncate($fp, 0); # Now it's ready for writing later.
            }
         }
      }
      else {
         debug("Couldn't lock the cache file, ignoring it.");
         $fp = null;
      }
   }

   return array($fp, null);
}

# ============================================================================
# Simple function to replicate PHP 5 behaviour
# ============================================================================
function microtime_float() {
   list( $usec, $sec ) = explode( " ", microtime() );
   return ( (float) $usec + (float) $sec );
}

# ============================================================================
# Function to sanitize filenames
# ============================================================================
function sanitize_filename($options, $keys, $tail) {
   $result = "";
   foreach ( $keys as $k ) {
      if ( isset($options[$k]) ) {
         $result .= $options[$k] . '_';
      }
   }
   return str_replace(array(":", "/"), array("", "_"), $result . $tail);
}

# ============================================================================
# Execute the command to get the output and return it.
# ============================================================================
function get_command_result($cmd, $options) {
   global $debug, $ssh_user, $ssh_port, $ssh_iden, $ssh_tout, $use_ssh;
   $use_ssh = isset($options['use-ssh']) ? $options['use-ssh'] : $use_ssh;

   # If there is a --file, we just use that.
   if ( isset($options['file']) ) {
      return implode("\n", file($options['file']));
   }

   # Build the SSH command line.
   $port = isset($options['port']) ? $options['port'] : $ssh_port;
   $ssh  = "ssh -q -o \"ConnectTimeout $ssh_tout\" -o \"StrictHostKeyChecking no\" "
         . "$ssh_user@$options[host] -p $port $ssh_iden";
   debug($ssh);
   $final_cmd = $use_ssh ? "$ssh '$cmd'" : $cmd;
   debug($final_cmd);
   $start = microtime_float();
   $result = `$final_cmd`; # XXX this is the ssh command.
   $end = microtime_float();
   debug(array("Time taken to exec: ", $end - $start));
   debug(array("result of $final_cmd", $result));
   return $result;
}

# ============================================================================
# Extracts the numbers from a string.  You can't reliably do this by casting to
# an int, because numbers that are bigger than PHP's int (varies by platform)
# will be truncated.  So this just handles them as a string instead.
# ============================================================================
function to_int ( $str ) {
   debug($str);
   global $debug;
   preg_match('{(\d+)}', $str, $m);
   if ( isset($m[1]) ) {
      return $m[1];
   }
   elseif ( $debug ) {
      print_r(debug_backtrace());
   }
   else {
      return 0;
   }
}

# ============================================================================
# Extracts a float from a string.  See to_int().  This is tested in
# get_by_ssh.php.
# ============================================================================
function to_float ( $str ) {
   debug($str);
   global $debug;
   preg_match('{([0-9.]+)}', $str, $m); 
   if ( isset($m[1]) ) {
      return $m[1];
   }
   elseif ( $debug ) {
      print_r(debug_backtrace());
   }
   else {
      return 0;
   }
}

# ============================================================================
# Safely increments a value that might be null.
# ============================================================================
function increment(&$arr, $key, $howmuch) {
   debug(array($key, $howmuch));
   if ( array_key_exists($key, $arr) && isset($arr[$key]) ) {
      $arr[$key] = big_add($arr[$key], $howmuch);
   }
   else {
      $arr[$key] = $howmuch;
   }
}

# ============================================================================
# Multiply two big integers together as accurately as possible with reasonable
# effort.  This is tested in t/mysql_stats.php and copied, without tests, to
# ss_get_by_ssh.php.  $force is for testability.
# ============================================================================
function big_multiply ($left, $right, $force = null) {
   if ( function_exists("gmp_mul") && (is_null($force) || $force == 'gmp') ) {
      debug(array('gmp_mul', $left, $right));
      return gmp_strval( gmp_mul( $left, $right ));
   }
   elseif ( function_exists("bcmul") && (is_null($force) || $force == 'bc') ) {
      debug(array('bcmul', $left, $right));
      return bcmul( $left, $right );
   }
   else { # Or $force == 'something else'
      debug(array('sprintf', $left, $right));
      return sprintf("%.0f", $left * $right);
   }
}

# ============================================================================
# Subtract two big integers as accurately as possible with reasonable effort.
# This is tested in t/mysql_stats.php and copied, without tests, to
# ss_get_by_ssh.php.  $force is for testability.
# ============================================================================
function big_sub ($left, $right, $force = null) {
   debug(array($left, $right));
   if ( is_null($left)  ) { $left = 0; }
   if ( is_null($right) ) { $right = 0; }
   if ( function_exists("gmp_sub") && (is_null($force) || $force == 'gmp')) {
      debug(array('gmp_sub', $left, $right));
      return gmp_strval( gmp_sub( $left, $right ));
   }
   elseif ( function_exists("bcsub") && (is_null($force) || $force == 'bc')) {
      debug(array('bcsub', $left, $right));
      return bcsub( $left, $right );
   }
   else { # Or $force == 'something else'
      debug(array('to_int', $left, $right));
      return to_int($left - $right);
   }
}

# ============================================================================
# Add two big integers together as accurately as possible with reasonable
# effort.  This is tested in t/mysql_stats.php and copied, without tests, to
# ss_get_by_ssh.php.  $force is for testability.
# ============================================================================
function big_add ($left, $right, $force = null) {
   if ( is_null($left)  ) { $left = 0; }
   if ( is_null($right) ) { $right = 0; }
   if ( function_exists("gmp_add") && (is_null($force) || $force == 'gmp')) {
      debug(array('gmp_add', $left, $right));
      return gmp_strval( gmp_add( $left, $right ));
   }
   elseif ( function_exists("bcadd") && (is_null($force) || $force == 'bc')) {
      debug(array('bcadd', $left, $right));
      return bcadd( $left, $right );
   }
   else { # Or $force == 'something else'
      debug(array('to_int', $left, $right));
      return to_int($left + $right);
   }
}

# ============================================================================
# Writes to a debugging log.
# ============================================================================
function debug($val) {
   global $debug_log;
   if ( !$debug_log ) {
      return;
   }
   if ( $fp = fopen($debug_log, 'a+') ) {
      $trace = debug_backtrace();
      $calls = array();
      $i    = 0;
      $line = 0;
      $file = '';
      foreach ( debug_backtrace() as $arr ) {
         if ( $i++ ) {
            $calls[] = "$arr[function]() at $file:$line";
         }
         $line = array_key_exists('line', $arr) ? $arr['line'] : '?';
         $file = array_key_exists('file', $arr) ? $arr['file'] : '?';
      }
      if ( !count($calls) ) {
         $calls[] = "at $file:$line";
      }
      fwrite($fp, date('Y-m-d h:i:s') . ' ' . implode(' <- ', $calls));
      fwrite($fp, "\n" . var_export($val, TRUE) . "\n");
      fclose($fp);
   }
   else { # Disable logging
      print("Warning: disabling debug logging to $debug_log\n");
      $debug_log = FALSE;
   }
}

# ============================================================================
# Everything from this point down is the functions that do the specific work to
# get and parse command output.  These are called from get_by_ssh().  The work
# is broken down into parts by several functions, one set for each type of data
# collection, based on the --type option:
# 0) Build a cache file name.
#    This is done in $type_cachefile().
# 1) Build a command-line string.
#    This is done in $type_cmdline() and will often be trivially simple.  The
#    resulting command-line string should use double-quotes wherever quotes
#    are needed, because it'll end up being enclosed in single-quotes if it
#    is executed remotely via SSH (which is typically the case).
# 2) SSH to the server and execute that command to get its output.
#    This is common code called from get_by_ssh(), in get_command_result().
# 3) Parse the result.
#    This is done in $type_parse().
# ============================================================================

# ============================================================================
# Gets and parses /proc/stat from Linux.
# Options used: none.
# You can test it like this, as root:
# su - cacti -c 'env -i php /var/www/cacti/scripts/ss_get_by_ssh.php --type proc_stat --host 127.0.0.1 --items gg,gh'
# ============================================================================
function proc_stat_cachefile ( $options ) {
   return sanitize_filename($options, array('host', 'port'), 'proc_stat');
}

function proc_stat_cmdline ( $options ) {
   return "cat /proc/stat";
}

function proc_stat_parse ( $options, $output ) {
   $result = array(
      'STAT_interrupts'        => null,
      'STAT_context_switches'  => null,
      'STAT_forks'             => null,
   );
   $cpu_types = array(
      'STAT_CPU_user',
      'STAT_CPU_nice',
      'STAT_CPU_system',
      'STAT_CPU_idle',
      'STAT_CPU_iowait',
      'STAT_CPU_irq',
      'STAT_CPU_softirq',
      'STAT_CPU_steal',
      'STAT_CPU_guest',
   );
   foreach ( $cpu_types as $key ) {
      $result[$key] = null;
   }

   foreach ( explode("\n", $output) as $line ) {
      if ( preg_match_all('/\w+/', $line, $words) ) {
         $words = $words[0];
         if ( $words[0] == "cpu" ) {
            for ( $i = 1; $i < count($words) && $i <= count($cpu_types); ++$i ) {
               $result[$cpu_types[$i - 1]] = $words[$i];
            }
         }
         elseif ( $words[0] == "intr" ) {
            $result['STAT_interrupts'] = $words[1];
         }
         elseif ( $words[0] == "ctxt" ) {
            $result['STAT_context_switches'] = $words[1];
         }
         elseif ( $words[0] == "processes" ) {
            $result['STAT_forks'] = $words[1];
         }
      }
   }
   return $result;
}

# ============================================================================
# Gets and parses the 'free' command from Linux.
# Options used: none.
# You can test it like this, as root:
# su - cacti -c 'env -i php /var/www/cacti/scripts/ss_get_by_ssh.php --type memory --host 127.0.0.1 --items gu,gv'
# ============================================================================
function memory_cachefile ( $options ) {
   return sanitize_filename($options, array('host', 'port'), 'memory');
}

function memory_cmdline ( $options ) {
   return "free -ob";
}

function memory_parse ( $options, $output ) {
   $result = array(
      'STAT_memcached' => null,
      'STAT_membuffer' => null,
      'STAT_memshared' => null,
      'STAT_memfree'   => null,
      'STAT_memused'   => null,
      'STAT_memtotal'  => null,
   );

   foreach ( explode("\n", $output) as $line ) {
      if ( preg_match_all('/\S+/', $line, $words) ) {
         $words = $words[0];
         if ( $words[0] == "Mem:" ) {
            $result['STAT_memcached'] = $words[6];
            $result['STAT_membuffer'] = $words[5];
            $result['STAT_memshared'] = $words[4];
            $result['STAT_memfree']   = $words[3];
            $result['STAT_memtotal']  = $words[1];
            $result['STAT_memused']   = sprintf('%.0f',
               $words[2] - $words[4] - $words[5] - $words[6]);
         }
      }
   }
   return $result;
}

# ============================================================================
# Gets and parses the results of the 'w' command from Linux.  Actually it's
# designed to get loadavg and number of users, so it uses 'uptime' instead; it
# used to use 'w' but uptime prints the same thing.
# Options used: none.
# You can test it like this, as root:
# su - cacti -c 'env -i php /var/www/cacti/scripts/ss_get_by_ssh.php --type w --host 127.0.0.1 --items gs,gt'
# ============================================================================
function w_cachefile ( $options ) {
   return sanitize_filename($options, array('host', 'port'), 'w');
}

function w_cmdline ( $options ) {
   return "uptime";
}

function w_parse ( $options, $output ) {
   $result = array(
      'STAT_loadavg'        => null,
      'STAT_numusers'       => null,
   );

   # The 'uptime' command returns different things on different servers:
   # 13:50:25 up  4:50, load average: 0.00, 0.03, 0.06
   # 13:51:53 up 1 day, 17 min,  0 users,  load average: 1.00, 0.62, 0.57
   # 21:11 up 12 days, 12:07, 3 users, load averages: 1.19 1.11 1.08
   # Notice on some systems id doesn't show the number of users. It also might
   # be localized: Utilizadores, 1,58 or 1.58
   foreach ( explode("\n", $output) as $line ) {
      $line = trim($line);
      if ( strlen($line) > 0 ) {
         $result['STAT_numusers'] = 0;
         if ( preg_match('/(\d+) u[^ ]*,/', $line, $words) ) {
            $result['STAT_numusers'] = $words[1];
         }
         if ( preg_match('/(\d+[,.]\d+)$/', $line, $words) ) {
            $result['STAT_loadavg']  = $words[1];
         }
      }
   }
   return $result;
}

# ============================================================================
# Gets and parses /server-status from Apache.
# You can test it like this, as root:
# su - cacti -c 'env -i php /var/www/cacti/scripts/ss_get_by_ssh.php --type apache --host 127.0.0.1 --items ge,gf'
# ============================================================================
function apache_cachefile ( $options ) {
   return sanitize_filename($options, array('host', 'port', 'server'), 'apache');
}

function apache_cmdline ( $options ) {
   global $status_server, $status_url, $http_user, $http_pass, $http_port;
   $srv = $status_server;
   if ( isset($options['server']) ) {
      $srv = $options['server'];
   }
   elseif ( ! $options['use-ssh'] ) {
      $srv = $options['host'];
   }
   $url = isset($options['url'])    ? $options['url']    : $status_url;
   $user = isset($options['http-user'])     ? $options['http-user']     : $http_user;
   $pass = isset($options['http-password']) ? $options['http-password'] : $http_pass;
   $port = isset($options['port2']) ? ":$options[port2]" : ":$http_port";
   $auth = ($user ? "--http-user=$user" : '') . ' ' . ($pass ? "--http-password=$pass" : '');
   return "wget $auth -U Cacti/1.0 -q -O - -T 5 \"http://$srv$port$url?auto\"";
}

function apache_parse ( $options, $output ) {
   $result = array(
      'APACHE_Requests'     => null,
      'APACHE_Bytes_sent'   => null,
      'APACHE_Idle_workers' => null,
      'APACHE_Busy_workers' => null,
      'APACHE_CPU_Load'     => null,
      # More are added from $scoreboard below.
   );

   # Mapping from Scoreboard statuses to friendly labels
   $scoreboard = array(
      '_' => 'APACHE_Waiting_for_connection',
      'S' => 'APACHE_Starting_up',
      'R' => 'APACHE_Reading_request',
      'W' => 'APACHE_Sending_reply',
      'K' => 'APACHE_Keepalive',
      'D' => 'APACHE_DNS_lookup',
      'C' => 'APACHE_Closing_connection',
      'L' => 'APACHE_Logging',
      'G' => 'APACHE_Gracefully_finishing',
      'I' => 'APACHE_Idle_cleanup',
      '.' => 'APACHE_Open_slot',
   );
   foreach ( $scoreboard as $key => $val ) {
      # These are not null, they are zero, when they aren't in the output.
      $result[$val] = 0;
   }

   # Mapping from line prefix to data item name
   $mapping = array (
      "Total Accesses" => 'APACHE_Requests',
      "Total kBytes"   => 'APACHE_Bytes_sent',
      "CPULoad"        => 'APACHE_CPU_Load',
      "BusyWorkers"    => 'APACHE_Busy_workers',
      "IdleWorkers"    => 'APACHE_Idle_workers',
   );

   foreach ( explode("\n", $output ) as $line ) {
      $words = explode(": ", $line);
      if ( $words[0] == "Total kBytes" ) {
         $words[1] = big_multiply($words[1], 1024);
      }

      if ( array_key_exists($words[0], $mapping) ) {
         # Check for really small values indistinguishable from 0, but otherwise
         # just copy the value to the output.
         $result[$mapping[$words[0]]] = strstr($words[1], 'e') ? 0 : $words[1];
      }
      elseif ( $words[0] == "Scoreboard" ) {
         $string = $words[1];
         $length = strlen($string);
         for ( $i = 0; $i < $length ; $i++ ) {
            increment($result, $scoreboard[$string[$i]], 1);
         }
      }
   }
   return $result;
}

# ============================================================================
# Gets /server-status from Nginx.
# You can test it like this, as root:
# su - cacti -c 'env -i php /var/www/cacti/scripts/ss_get_by_ssh.php --type nginx --host 127.0.0.1 --items gz,h0'
# ============================================================================
function nginx_cachefile ( $options ) {
   return sanitize_filename($options, array('host', 'port', 'port2', 'server'), 'nginx');
}

function nginx_cmdline ( $options ) {
   global $status_server, $status_url, $http_user, $http_pass;
   $srv = $status_server;
   if ( isset($options['server']) ) {
      $srv = $options['server'];
   }
   elseif ( ! $options['use-ssh'] ) {
      $srv = $options['host'];
   }
   $url = isset($options['url'])    ? $options['url']    : $status_url;
   $user = isset($options['http-user'])     ? $options['http-user']     : $http_user;
   $pass = isset($options['http-password']) ? $options['http-password'] : $http_pass;
   $port = isset($options['port2']) ? ":$options[port2]" : '';
   $auth = ($user ? "--http-user=$user" : '') . ' ' . ($pass ? "--http-password=$pass" : '');
   return "wget $auth -U Cacti/1.0 -q -O - -T 5 \"http://$srv$port$url?auto\"";
}

function nginx_parse ( $options, $output ) {
   $result = array(
      'NGINX_active_connections' => null,
      'NGINX_server_accepts'     => null,
      'NGINX_server_handled'     => null,
      'NGINX_server_requests'    => null,
      'NGINX_reading'            => null,
      'NGINX_writing'            => null,
      'NGINX_waiting'            => null,
   );

   foreach ( explode("\n", $output) as $line ) {
      if ( preg_match_all('/\S+/', $line, $words) ) {
         $words = $words[0];
         if ( $words[0] == 'Active' ) {
            $result['NGINX_active_connections'] = $words[2];
         }
         elseif ( $words[0] == 'Reading:' ) {
            $result['NGINX_reading'] = $words[1];
            $result['NGINX_writing'] = $words[3];
            $result['NGINX_waiting'] = $words[5];
         }
         elseif ( preg_match('/^\d+$/', $words[0]) ) {
            $result['NGINX_server_accepts']  = $words[0];
            $result['NGINX_server_handled']  = $words[1];
            $result['NGINX_server_requests'] = $words[2];
         }
      }
   }
   return $result;
}

# ============================================================================
# Get and parse stats from memcached, using nc (netcat).
# You can test it like this, as root:
# su - cacti -c 'env -i php /var/www/cacti/scripts/ss_get_by_ssh.php --type memcached --host 127.0.0.1 --items h6,h7'
# ============================================================================
function memcached_cachefile ( $options ) {
   return sanitize_filename($options, array('host', 'port', 'port2', 'server'), 'memcached');
}

function memcached_cmdline ( $options ) {
   global $memcache_port, $nc_cmd;
   $srv = isset($options['server']) ? $options['server'] : $options['host'];
   $prt = isset($options['port2'])  ? $options['port2']  : $memcache_port;
   return "echo \"stats\nquit\" | $nc_cmd $srv $prt";
}

function memcached_parse ( $options, $output ) {
   $result = array();
   foreach ( explode("\n", $output) as $line ) {
      $words = explode(' ', $line);
      if ( count($words) && $words[0] === "STAT" ) {
         # rusage are in microseconds, but COUNTER does not accept fractions
         if ( $words[1] === 'rusage_user' || $words[1] === 'rusage_system' ) {
            $result["MEMC_$words[1]"]
               = sprintf('%.0f', 1000000 * trim($words[2]));
         }
         else {
            $result["MEMC_$words[1]"] = trim($words[2]);
         }
      }
   }
   return $result;
}

# ============================================================================
# Get and parse stats from /proc/diskstats
# You can test it like this, as root:
# su - cacti -c 'env -i php /var/www/cacti/scripts/ss_get_by_ssh.php --type diskstats --device sda4 --host 127.0.0.1 --items hj,hk,hl,hm,hn,ho,hp'
# ============================================================================
function diskstats_cachefile ( $options ) {
   if ( !isset($options['device']) ) {
      die("--device is required for --type diskstats");
   }
   return sanitize_filename($options, array('host', 'port', 'device'), 'diskstats');
}

function diskstats_cmdline ( $options ) {
   return "cat /proc/diskstats";
}

function diskstats_parse ( $options, $output ) {
   if ( !isset($options['device']) ) {
      die("--device is required for --type diskstats");
   }
   foreach ( explode("\n", $output) as $line ) {
      if ( preg_match_all('/\S+/', $line, $words) ) {
         $words = $words[0];
         if ( count($words) > 2 && $words[2] === $options['device'] ) {
            if ( count($words) > 10 ) {
               return array(
                  'DISK_reads'              => $words[3],
                  'DISK_reads_merged'       => $words[4],
                  'DISK_sectors_read'       => $words[5],
                  'DISK_time_spent_reading' => $words[6],
                  'DISK_writes'             => $words[7],
                  'DISK_writes_merged'      => $words[8],
                  'DISK_sectors_written'    => $words[9],
                  'DISK_time_spent_writing' => $words[10],
                  'DISK_io_ops_in_progress' => $words[11],
                  'DISK_io_time'            => $words[12],
                  'DISK_io_time_weighted'   => $words[13],
               );
            }
            else { # Early 2.6 kernels had only 4 fields for partitions.
               return array(
                  'DISK_reads'              => $words[3],
                  'DISK_reads_merged'       => 0,
                  'DISK_sectors_read'       => $words[4],
                  'DISK_time_spent_reading' => 0,
                  'DISK_writes'             => $words[5],
                  'DISK_writes_merged'      => 0,
                  'DISK_sectors_written'    => $words[6],
                  'DISK_time_spent_writing' => 0,
                  'DISK_io_ops_in_progress' => 0,
                  'DISK_io_time'            => 0,
                  'DISK_io_time_weighted'   => 0,
               );
            }
         }
      }
   }
   debug("Looks like we did not find $options[device] in the output");
   return array();
}

# ============================================================================
# Get and parse stats from /proc/user_beancounters for openvz graphs
# You can test it like this, as root:
# su - cacti -c 'env -i php /var/www/cacti/scripts/ss_get_by_ssh.php --type openvz --host 127.0.0.1 --items hu,hv,hw,hx,hy,hz,i0'
# ============================================================================
function openvz_cachefile ( $options ) {
   return sanitize_filename($options, array('host', 'port'), 'openvz');
}

function openvz_cmdline ( $options ) {
   global $openvz_cmd;
   $meth = isset($options['openvz_cmd'])
         ? $options['openvz_cmd']
         : $openvz_cmd;
   return $meth;
}

function openvz_parse ( $options, $output ) {
   $headers = array();
   $result  = array();
   foreach ( explode("\n", $output) as $line ) {
      if ( preg_match_all('/\S+/', $line, $words) ) {
         $words = $words[0];
         if ( $words[0] === 'Version:' || $words[0] === 'dummy' ) {
            # An intro line or a dummy line
            continue;
         }
         else if ( $words[0] === 'uid' ) {
            # It's the header row.  Get the headers into the header array,
            # except for the UID header, which we don't need, and the resource
            # header, which just defines the leftmost header that's in every
            # subsequent line but isn't itself a statistic.
            array_shift($words);
            array_shift($words);
            $headers = $words;
            continue;
         }
         elseif ( strpos(strrev($words[0]), ':') === 0 ) {
            # This is a line that starts with something like "200:" and we want
            # to toss the first word in that line.  It's the UID of the
            # container.
            array_shift($words);
         }
         $row_hdr = array_shift($words);
         for ( $i = 0; $i < count($words); ++$i ) {
            $col_hdr = $headers[$i];
            if ( $col_hdr !== 'held' && $col_hdr !== 'failcnt' ) {
               continue; # Those are the only ones we're interested in.
            }
            $key = "OPVZ_${row_hdr}_${col_hdr}";
            $result[$key] = $words[$i];
         }
      }
   }
   return $result;
}

# ============================================================================
# Get and parse stats from redis, using nc (netcat).
# You can test it like this, as root:
# su - cacti -c 'env -i php /var/www/cacti/scripts/ss_get_by_ssh.php --type redis --host 127.0.0.1 --items iy,iz,j2,j3
# ============================================================================
function redis_cachefile ( $options ) {
   global $status_server, $redis_port;
   return sanitize_filename($options, array('host', 'port', 'port2', 'server'), 'redis');
}

# The function redis_get is defined below to use a TCP socket directly, so
# really the command-line won't be called.  The problem is that nc is so
# different in different systems.  We really need the -C option, but some nc
# don't have -C.
function redis_cmdline ( $options ) {
   global $redis_port, $nc_cmd;
   $srv = isset($options['server']) ? $options['server'] : $options['host'];
   $prt = isset($options['port2'])  ? $options['port2']  : $redis_port;
   return "echo INFO | $nc_cmd $srv $prt";
}

function redis_parse ( $options, $output ) {
   $result = array();
   $wanted = array(
      'connected_clients',
      'connected_slaves',
      'used_memory',
      'changes_since_last_save',
      'total_connections_received',
      'total_commands_processed'
   );
   foreach ( explode("\n", $output) as $line ) {
      $words = explode(':', $line);
      if ( count($words) && in_array($words[0], $wanted) ) {
         $result["REDIS_$words[0]"] = trim($words[1]);
      }
   }
   return $result;
}

function redis_get ( $options ) {
   global $redis_port;
   $port = isset($options['port2'])  ? $options['port2'] : $redis_port;
   $sock = fsockopen($options['host'], $port, $errno, $errstr);
   if ( !$sock ) {
      debug("Cannot open socket to $options[host]:$port: "
         . ($errno  ? " err $errno"  : "")
         . ($errmsg ? " msg $errmsg" : ""));
      return;
   }
   $res = fwrite($sock, "INFO\r\n");
   if ( !$res ) {
      debug("Can't write to socket");
      return;
   }
   $data = fread($sock, 4096); # should be WAY more than enough for INFO
   if ( !$data ) {
      debug("Cannot read from socket");
      return;
   }
   $res = fclose($sock);
   if ( !$res ) {
      debug("Can't close socket");
   }
   return $data;
}

# ============================================================================
# Get and parse stats from JMX.
# You can test it like this, as root:
# su - cacti -c 'env -i php /var/www/cacti/scripts/ss_get_by_ssh.php --type jmx --host 127.0.0.1 --items j4,j5,j6,j7,j8,j9,ja,jb
# ============================================================================
function jmx_parse ( $options, $output ) {
   $result = array();
   $wanted = array(
      'heap_memory_used',
      'heap_memory_committed',
      'heap_memory_max',
      'non_heap_memory_used',
      'non_heap_memory_committed',
      'non_heap_memory_max',
      'open_file_descriptors',
      'max_file_descriptors',
      'current_threads_busy',
      'current_thread_count',
      'max_threads',
   );
   foreach ( explode("\n", $output) as $line ) {
      $words = explode(':', $line);
      if ( count($words) && in_array($words[0], $wanted) ) {
         $result["JMX_$words[0]"] = trim($words[1]);
      }
   }
   return $result;
}

function jmx_cachefile ( $options ) {
   return sanitize_filename($options, array('host', 'port', 'port2'), 'jmx');
}

function jmx_cmdline ( $options ) {
   $port = isset($options['port2']) ? "$options[port2]" : '9012';
   $threadpool = isset($options['threadpool']) ? "$options[threadpool]" : 'http-8080';
   return "ant -Djmx.server.port=$port -Djmx.catalina.threadpool.name=$threadpool -e -q -f jmx-monitor.xml";
}

# ============================================================================
# Get and parse stats from mongodb on a given port
# You can test it like this, as root:
# su - cacti -c 'env -i php /var/www/cacti/scripts/ss_get_by_ssh.php --type mongodb --host 127.0.0.1 --items jc,je,jf,jg,jh,ji,jj,jk,jl,jm,jn,jo,jp,jq,jr,js,jt,ju
# ============================================================================
function mongodb_cachefile ( $options ) {
   return sanitize_filename($options, array('host', 'port2'), 'mongodb');
}

function mongodb_cmdline ( $options ) {
   return "echo \"db._adminCommand({serverStatus:1, repl:2})\" | mongo";
}

function mongodb_parse ( $options, $output ) {
   $result = array();
   $matches = array();

   preg_match('/"current" : ([0-9]+)/', $output, $matches);
   $result["MONGODB_connected_clients"] = $matches[1];

   preg_match('/"resident" : ([0-9]+)/', $output, $matches);
   $result["MONGODB_used_resident_memory"] = intval($matches[1]) * 1024 * 1024;
   preg_match('/"mapped" : ([0-9]+)/', $output, $matches);
   $result["MONGODB_used_mapped_memory"] = intval($matches[1]) * 1024 * 1024;
   preg_match('/"virtual" : ([0-9]+)/', $output, $matches);
   $result["MONGODB_used_virtual_memory"] = intval($matches[1]) * 1024 * 1024;

   preg_match('/"accesses" : ([0-9]+)/', $output, $matches);
   $result["MONGODB_index_accesses"] = $matches[1];
   preg_match('/"hits" : ([0-9]+)/', $output, $matches);
   $result["MONGODB_index_hits"] = $matches[1];
   preg_match('/"misses" : ([0-9]+)/', $output, $matches);
   $result["MONGODB_index_misses"] = $matches[1];
   preg_match('/"resets" : ([0-9]+)/', $output, $matches);
   $result["MONGODB_index_resets"] = $matches[1];

   preg_match('/"flushes" : ([0-9]+)/', $output, $matches);
   $result["MONGODB_back_flushes"] = $matches[1];
   preg_match('/"total_ms" : ([0-9]+)/', $output, $matches);
   $result["MONGODB_back_total_ms"] = $matches[1];
   preg_match('/"average_ms" : ([0-9]+)/', $output, $matches);
   $result["MONGODB_back_average_ms"] = $matches[1];
   preg_match('/"last_ms" : ([0-9]+)/', $output, $matches);
   $result["MONGODB_back_last_ms"] = $matches[1];

   preg_match('/"insert" : ([0-9]+)/', $output, $matches);
   $result["MONGODB_op_inserts"] = $matches[1];
   preg_match('/"query" : ([0-9]+)/', $output, $matches);
   $result["MONGODB_op_queries"] = $matches[1];
   preg_match('/"update" : ([0-9]+)/', $output, $matches);
   $result["MONGODB_op_updates"] = $matches[1];
   preg_match('/"delete" : ([0-9]+)/', $output, $matches);
   $result["MONGODB_op_deletes"] = $matches[1];
   preg_match('/"getmore" : ([0-9]+)/', $output, $matches);
   $result["MONGODB_op_getmores"] = $matches[1];
   preg_match('/"command" : ([0-9]+)/', $output, $matches);
   $result["MONGODB_op_commands"] = $matches[1];

   if (preg_match('/"lagSeconds" : ([0-9]+)/', $output, $matches) == 0) {
     $result["MONGODB_slave_lag"] = -1;
   } else {
     $result["MONGODB_slave_lag"] = $matches[1];
   }

   return $result;
}

function df_parse ( $options, $output ) {
   if ( !isset($options['volume']) ) {
      die("--volume is required for --type df");
   }
   foreach ( explode("\n", $output) as $line ) {
      if ( preg_match_all('/\S+/', $line, $words) ) {
         $words = $words[0];
         if ( count($words) > 0 && $words[0] === $options['volume'] ) {
            if ( count($words) > 3 ) {
               return array(
                  'DISKFREE_used'      => $words[2]*1024,
                  'DISKFREE_available' => $words[3]*1024,
               );
            }
         }
      }
   }
   debug("Looks like we did not find $options[volume] in the output");
   return array();
}

function df_cachefile ( $options ) {
   return sanitize_filename($options, array('host', 'volume'), 'df');
}

function df_cmdline ( $options ) {
   return "df -k -P";
}

function netdev_parse ( $options, $output ) {
   if ( !isset($options['device']) ) {
      die("--device is required for --type netdev");
   }
   foreach ( explode("\n", $output) as $line ) {
      if ( preg_match_all('/[^\s:]+/', $line, $words) ) {
         $words = $words[0];
         if ( count($words) > 0 && $words[0] === $options['device'] ) {
            if ( count($words) > 15 ) {
                return array(
                    'NETDEV_rxbytes'   => $words[1],
                    'NETDEV_rxerrs'    => $words[3],
                    'NETDEV_rxdrop'    => $words[4],
                    'NETDEV_rxfifo'    => $words[5],
                    'NETDEV_rxframe'   => $words[6],
                    'NETDEV_txbytes'   => $words[9],
                    'NETDEV_txerrs'    => $words[11],
                    'NETDEV_txdrop'    => $words[12],
                    'NETDEV_txfifo'    => $words[13],
                    'NETDEV_txcolls'   => $words[14],
                    'NETDEV_txcarrier' => $words[15],
                );
            }
         }
      }
   }
   debug("Looks like we did not find $options[device] in the output");
   return array();
}

function netdev_cachefile ( $options ) {
   return sanitize_filename($options, array('host', 'device'), 'netdev');
}

function netdev_cmdline ( $options ) {
   return "cat /proc/net/dev";
}

function netstat_parse ( $options, $output ) {
    $array = array(
        'NETSTAT_established' => 0,
        'NETSTAT_syn_sent'    => 0,
        'NETSTAT_syn_recv'    => 0,
        'NETSTAT_fin_wait1'   => 0,
        'NETSTAT_fin_wait2'   => 0,
        'NETSTAT_time_wait'   => 0,
        'NETSTAT_close'       => 0,
        'NETSTAT_close_wait'  => 0,
        'NETSTAT_last_ack'    => 0,
        'NETSTAT_listen'      => 0,
        'NETSTAT_closing'     => 0,
        'NETSTAT_unknown'     => 0,
    );

    foreach(explode("\n", $output) as $line) {
        if(preg_match('/^tcp/', $line)){
            $array['NETSTAT_'.strtolower(end(preg_split('/[\s]+/', trim($line))))]++;
        }
    }
    return $array;
}

function netstat_cachefile ( $options ) {
   return sanitize_filename($options, array('host'), 'netstat');
}

function netstat_cmdline ( $options ) {
   return "netstat -ant";
}

function vmstat_parse ( $options, $output ) {
   $result = array();
   $matches = array();

   preg_match('/pswpin ([0-9]+)/', $output, $matches);
   $result["VMSTAT_pswpin"] = $matches[1];

   preg_match('/pswpout ([0-9]+)/', $output, $matches);
   $result["VMSTAT_pswpout"] = $matches[1];

   return $result;
}

function vmstat_cachefile ( $options ) {
   return sanitize_filename($options, array('host'), 'vmstat');
}

function vmstat_cmdline ( $options ) {
   return "cat /proc/vmstat";
}

