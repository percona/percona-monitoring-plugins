<?php
require('test-more.php');
require('../scripts/ss_get_by_ssh.php');
$debug = true;

is(
   sanitize_filename(
      array('foo' => 'bar'),
      array('foo', 'biz'),
      'tail'),
   'bar_tail',
   'sanitize_filename'
);

is_deeply(
   proc_stat_parse(null, file_get_contents('samples/proc_stat-001.txt')),
   array(
      'STAT_interrupts'       => '339490',
      'STAT_context_switches' => '697948',
      'STAT_forks'            => '11558',
      'STAT_CPU_user'         => '24198',
      'STAT_CPU_nice'         => '0',
      'STAT_CPU_system'       => '69614',
      'STAT_CPU_idle'         => '2630536',
      'STAT_CPU_iowait'       => '558',
      'STAT_CPU_irq'          => '5872',
      'STAT_CPU_softirq'      => '1572',
      'STAT_CPU_steal'        => '0',
      'STAT_CPU_guest'        => '0'
   ),
   'samples/proc_stat-001.txt'
);

is_deeply(
   proc_stat_parse(null, file_get_contents('samples/proc_stat-002.txt')),
   array(
      'STAT_interrupts'       => '87480486',
      'STAT_context_switches' => '125521467',
      'STAT_forks'            => '239810',
      'STAT_CPU_user'         => '2261920',
      'STAT_CPU_nice'         => '38824',
      'STAT_CPU_system'       => '986335',
      'STAT_CPU_idle'         => '39683698',
      'STAT_CPU_iowait'       => '62368',
      'STAT_CPU_irq'          => '19193',
      'STAT_CPU_softirq'      => '8499',
      'STAT_CPU_steal'        => '0',
      'STAT_CPU_guest'        => '0'
   ),
   'samples/proc_stat-002.txt'
);

is(
   ss_get_by_ssh( array(
      'file'    => 'samples/proc_stat-001.txt',
      'type'    => 'proc_stat',
      'host'    => 'localhost',
      'items'   => 'ag,ah,ai,aj,ak,al,am,an,ao,ap,aq,ar'
   )),
   'ag:24198 ah:0 ai:69614 aj:2630536 ak:558 al:5872 am:1572 an:0 ao:0'
      . ' ap:339490 aq:697948 ar:11558',
   'main(samples/proc_stat-001.txt)'
);

is_deeply(
   memory_parse( null, file_get_contents('samples/free-001.txt') ),
   array(
      'STAT_memcached' => '22106112',
      'STAT_membuffer' => '1531904',
      'STAT_memshared' => '0',
      'STAT_memfree'   => '17928192',
      'STAT_memused'   => '21389312',
      'STAT_memtotal'  => '62955520',
   ),
   'samples/free-001.txt'
);

is_deeply(
   memory_parse( null, file_get_contents('samples/free-002.txt') ),
   array(
      'STAT_memcached' => '1088184320',
      'STAT_membuffer' => '131469312',
      'STAT_memshared' => '0',
      'STAT_memfree'   => '189325312',
      'STAT_memused'   => '7568291328',
      'STAT_memtotal'  => '8977270272',
   ),
   'samples/free-002.txt (issue 102)'
);

is(
   ss_get_by_ssh( array(
      'file'    => 'samples/free-001.txt',
      'type'    => 'memory',
      'host'    => 'localhost',
      'items'   => 'au,av,aw,ax,ay'
   )),
   'au:22106112 av:1531904 aw:0 ax:17928192 ay:21389312',
   'main(samples/free-001.txt)'
);

is_deeply(
   w_parse( null, file_get_contents('samples/w-001.txt') ),
   array(
      'STAT_loadavg' => '1.43',
      'STAT_numusers' => '2',
   ),
   'samples/w-001.txt'
);

is_deeply(
   w_parse( null, file_get_contents('samples/w-002.txt') ),
   array(
      'STAT_loadavg' => '0.35',
      'STAT_numusers' => '6',
   ),
   'samples/w-002.txt'
);

is_deeply(
   w_parse( null, file_get_contents('samples/w-003.txt') ),
   array(
      'STAT_loadavg' => '0.00',
      'STAT_numusers' => '1',
   ),
   'samples/w-003.txt'
);

is_deeply(
   w_parse( null, file_get_contents('samples/w-004.txt') ),
   array(
      'STAT_loadavg' => '11.00',
      'STAT_numusers' => '1',
   ),
   'samples/w-004.txt'
);

is_deeply(
   w_parse( null, file_get_contents('samples/uptime-001.txt') ),
   array(
      'STAT_loadavg' => '0.06',
      'STAT_numusers' => '0',
   ),
   'samples/uptime-001.txt'
);

is(
   ss_get_by_ssh( array(
      'file'    => 'samples/w-001.txt',
      'type'    => 'w',
      'host'    => 'localhost',
      'items'   => 'as,at'
   )),
   'as:1.43 at:2',
   'main(samples/w-002.txt)'
);

is_deeply(
   memcached_parse( null, file_get_contents('samples/memcached-001.txt') ),
   array(
      'MEMC_pid'                   => '2120',
      'MEMC_uptime'                => '32314',
      'MEMC_time'                  => '1261775864',
      'MEMC_version'               => '1.2.2',
      'MEMC_pointer_size'          => '32',
      'MEMC_rusage_user'           => '396024',
      'MEMC_rusage_system'         => '1956122',
      'MEMC_curr_items'            => '0',
      'MEMC_total_items'           => '0',
      'MEMC_bytes'                 => '0',
      'MEMC_curr_connections'      => '1',
      'MEMC_total_connections'     => '5',
      'MEMC_connection_structures' => '2',
      'MEMC_cmd_get'               => '0',
      'MEMC_cmd_set'               => '0',
      'MEMC_get_hits'              => '0',
      'MEMC_get_misses'            => '0',
      'MEMC_evictions'             => '0',
      'MEMC_bytes_read'            => '45',
      'MEMC_bytes_written'         => '942',
      'MEMC_limit_maxbytes'        => '67108864',
      'MEMC_threads'               => '1',
   ),
   'samples/memcached-001.txt'
);

is_deeply(
   nginx_parse( null, file_get_contents('samples/nginx-001.txt') ),
   array(
      'NGINX_active_connections' => '251',
      'NGINX_server_accepts'     => '255601634',
      'NGINX_server_handled'     => '255601634',
      'NGINX_server_requests'    => '671013148',
      'NGINX_reading'            => '5',
      'NGINX_writing'            => '27',
      'NGINX_waiting'            => '219',
   ),
   'samples/nginx-001.txt'
);

is_deeply(
   apache_parse( null, file_get_contents('samples/apache-001.txt') ),
   array(
      'Requests'               => '3452389',
      'Bytes_sent'             => '23852769280',
      'Idle_workers'           => '8',
      'Busy_workers'           => '1',
      'CPU_Load'               => '.023871',
      'Waiting_for_connection' => '8',
      'Starting_up'            => 0,
      'Reading_request'        => 0,
      'Sending_reply'          => '1',
      'Keepalive'              => 0,
      'DNS_lookup'             => 0,
      'Closing_connection'     => 0,
      'Logging'                => 0,
      'Gracefully_finishing'   => 0,
      'Idle_cleanup'           => 0,
      'Open_slot'              => '247',
   ),
   'samples/apache-001.txt'
);

is_deeply(
   apache_parse( null, file_get_contents('samples/apache-002.txt') ),
   array(
      'Requests'               => '368',
      'Bytes_sent'             => 1151 * 1024,
      'Idle_workers'           => '19',
      'Busy_workers'           => '1',
      'CPU_Load'               => '.0284617',
      'Waiting_for_connection' => '19',
      'Starting_up'            => 0,
      'Reading_request'        => 0,
      'Sending_reply'          => '1',
      'Keepalive'              => 0,
      'DNS_lookup'             => 0,
      'Closing_connection'     => 0,
      'Logging'                => 0,
      'Gracefully_finishing'   => 0,
      'Idle_cleanup'           => 0,
      'Open_slot'              => '236',
   ),
   'samples/apache-001.txt'
);

is_deeply(
   diskstats_parse( array('device' => 'hda1'), file_get_contents('samples/diskstats-001.txt') ),
   array(
      'DISK_reads'              => '12043',
      'DISK_reads_merged'       => '387',
      'DISK_sectors_read'       => '300113',
      'DISK_time_spent_reading' => '6472',
      'DISK_writes'             => '12737',
      'DISK_writes_merged'      => '21340',
      'DISK_sectors_written'    => '272616',
      'DISK_time_spent_writing' => '22360',
      'DISK_io_ops_in_progress' => '0',
      'DISK_io_time'            => '12368',
      'DISK_io_time_weighted'   => '28832'
   ),
   'samples/diskstats-001.txt'
);

is_deeply(
   diskstats_parse( array('device' => 'sda4'), file_get_contents('samples/diskstats-002.txt') ),
   array(
      'DISK_reads'              => '30566',
      'DISK_reads_merged'       => '3341',
      'DISK_sectors_read'       => '586664',
      'DISK_time_spent_reading' => '370308',
      'DISK_writes'             => '150943',
      'DISK_writes_merged'      => '163833',
      'DISK_sectors_written'    => '2518672',
      'DISK_time_spent_writing' => '12081496',
      'DISK_io_time'            => '347416',
      'DISK_io_time_weighted'   => '12451664',
      'DISK_io_ops_in_progress' => '0'
   ),
   'samples/diskstats-002.txt'
);

is_deeply(
   diskstats_parse( array('device' => 'sda2'), file_get_contents('samples/diskstats-003.txt') ),
   array(
      'DISK_reads'              => '15425346',
      'DISK_reads_merged'       => '0',
      'DISK_sectors_read'       => '385290786',
      'DISK_time_spent_reading' => '0',
      'DISK_writes'             => '472909074',
      'DISK_writes_merged'      => '0',
      'DISK_sectors_written'    => '3783272616',
      'DISK_time_spent_writing' => '0',
      'DISK_io_time'            => '0',
      'DISK_io_time_weighted'   => '0',
      'DISK_io_ops_in_progress' => '0'
   ),
   'samples/diskstats-003.txt'
);

is(
   ss_get_by_ssh( array(
      'file'    => 'samples/diskstats-001.txt',
      'type'    => 'diskstats',
      'host'    => 'localhost',
      'items'   => 'bj,bk,bl,bm,bn,bo,bp,bq,br,bs,bt',
      'device'  => 'hda1'
   )),
   'bj:12043 bk:387 bl:300113 bm:6472 bn:12737 bo:21340 bp:272616 bq:22360 '
      . 'br:0 bs:12368 bt:28832',
   'main(samples/diskstats-001.txt)'
);

is_deeply(
   openvz_parse( array(), file_get_contents('samples/openvz-001.txt') ),
   array(
      'OPVZ_kmemsize_held'        => '8906701',
      'OPVZ_kmemsize_failcnt'     => '0',
      'OPVZ_lockedpages_held'     => '0',
      'OPVZ_lockedpages_failcnt'  => '0',
      'OPVZ_privvmpages_held'     => '39695',
      'OPVZ_privvmpages_failcnt'  => '0',
      'OPVZ_shmpages_held'        => '688',
      'OPVZ_shmpages_failcnt'     => '0',
      'OPVZ_numproc_held'         => '32',
      'OPVZ_numproc_failcnt'      => '0',
      'OPVZ_physpages_held'       => '11101',
      'OPVZ_physpages_failcnt'    => '0',
      'OPVZ_vmguarpages_held'     => '0',
      'OPVZ_vmguarpages_failcnt'  => '0',
      'OPVZ_oomguarpages_held'    => '11101',
      'OPVZ_oomguarpages_failcnt' => '0',
      'OPVZ_numtcpsock_held'      => '6',
      'OPVZ_numtcpsock_failcnt'   => '0',
      'OPVZ_numflock_held'        => '6',
      'OPVZ_numflock_failcnt'     => '0',
      'OPVZ_numpty_held'          => '1',
      'OPVZ_numpty_failcnt'       => '0',
      'OPVZ_numsiginfo_held'      => '0',
      'OPVZ_numsiginfo_failcnt'   => '0',
      'OPVZ_tcpsndbuf_held'       => '338656',
      'OPVZ_tcpsndbuf_failcnt'    => '0',
      'OPVZ_tcprcvbuf_held'       => '98304',
      'OPVZ_tcprcvbuf_failcnt'    => '0',
      'OPVZ_othersockbuf_held'    => '9280',
      'OPVZ_othersockbuf_failcnt' => '0',
      'OPVZ_dgramrcvbuf_held'     => '0',
      'OPVZ_dgramrcvbuf_failcnt'  => '0',
      'OPVZ_numothersock_held'    => '9',
      'OPVZ_numothersock_failcnt' => '0',
      'OPVZ_dcachesize_held'      => '0',
      'OPVZ_dcachesize_failcnt'   => '0',
      'OPVZ_numfile_held'         => '788',
      'OPVZ_numfile_failcnt'      => '0',
      'OPVZ_numiptent_held'       => '10',
      'OPVZ_numiptent_failcnt'    => '0',
   ),
   'samples/openvz-001.txt'
);

is(
   ss_get_by_ssh( array(
      'file'    => 'samples/openvz-001.txt',
      'type'    => 'openvz',
      'host'    => 'localhost',
      'items'   => 'bu,bv,bw,bx,by,bz,c0',
   )),
   'bu:8906701 bv:0 bw:0 bx:0 by:39695 bz:0 c0:688',
   'main(samples/openvz-001.txt)'
);

is_deeply(
   redis_parse( null, file_get_contents('samples/redis-001.txt') ),
   array(
      'REDIS_connected_clients'          => '119',
      'REDIS_connected_slaves'           => '911',
      'REDIS_used_memory'                => '412372',
      'REDIS_changes_since_last_save'    => '4321',
      'REDIS_total_connections_received' => '3333',
      'REDIS_total_commands_processed'   => '5',
   ),
   'samples/redis-001.txt'
);

is(
   ss_get_by_ssh( array(
      'file'    => 'samples/redis-001.txt',
      'type'    => 'redis',
      'host'    => 'localhost',
      'items'   => 'cy,cz,d0,d1,d2,d3',
   )),
   'cy:119 cz:911 d0:412372 d1:4321 d2:3333 d3:5',
   'main(samples/redis-001.txt)'
);

is_deeply(
   jmx_parse( null, file_get_contents('samples/jmx-001.txt') ),
   array(
      'JMX_heap_memory_used'          => '52685256',
      'JMX_heap_memory_committed'     => '205979648',
      'JMX_heap_memory_max'           => '1864171520',
      'JMX_non_heap_memory_used'      => '55160928',
      'JMX_non_heap_memory_committed' => '61603840',
      'JMX_non_heap_memory_max'       => '318767104',
      'JMX_open_file_descriptors'     => '60',
      'JMX_max_file_descriptors'      => '1024',
      'JMX_current_threads_busy'      => '7',
      'JMX_current_thread_count'      => '172',
      'JMX_max_threads'               => '200',
   ),
   'samples/jmx-001.txt'
);

is(
   ss_get_by_ssh(
      array(
         'file'  => 'samples/jmx-001.txt',
         'type'  => 'jmx',
         'host'  => 'localhost',
         'items' => 'd4,d5,d6,d7,d8,d9,da,db,el,em,en',
      )
   ),
   'd4:52685256 d5:205979648 d6:1864171520 d7:55160928 d8:61603840 d9:318767104 da:60 db:1024 el:7 em:172 en:200',
   'main(samples/jmx-001.txt)'
);

is_deeply(
   mongodb_parse( null, file_get_contents('samples/mongodb-001.txt') ),
   array(
      'MONGODB_connected_clients'         => '3',
      'MONGODB_used_resident_memory'      => '16029581312',
      'MONGODB_used_mapped_memory'        => '64981303296',
      'MONGODB_used_virtual_memory'       => '65457356800',
      'MONGODB_index_accesses'            => '1589814',
      'MONGODB_index_hits'                => '1589814',
      'MONGODB_index_misses'              => '0',
      'MONGODB_index_resets'              => '0',
      'MONGODB_back_flushes'              => '4883',
      'MONGODB_back_total_ms'             => '2309034',
      'MONGODB_back_average_ms'           => '472',
      'MONGODB_back_last_ms'              => '36',
      'MONGODB_op_inserts'                => '1584705',
      'MONGODB_op_queries'                => '145518',
      'MONGODB_op_updates'                => '2521129',
      'MONGODB_op_deletes'                => '601',
      'MONGODB_op_getmores'               => '2268817',
      'MONGODB_op_commands'               => '17810',
      'MONGODB_slave_lag'                 => '0',
   ),
   'samples/mongodb-001.txt'
);

is(
   ss_get_by_ssh( array(
      'file'    => 'samples/mongodb-001.txt',
      'type'    => 'mongodb',
      'host'    => 'localhost',
      'items'   => 'dc,dd,de,df,dg,dh,di,dj,dk,dl,dm,dn,do,dp,dq,dr,ds,dt,du',
   )),
   'dc:3 dd:16029581312 de:64981303296 df:65457356800 dg:1589814 dh:1589814 di:0 dj:0 dk:4883 dl:2309034 dm:472 dn:36 do:1584705 dp:145518 dq:2521129 dr:601 ds:2268817 dt:17810 du:0',
   'main(samples/mongodb-001.txt)'
);

is_deeply(
   df_parse( array('volume' => '/dev/vzfs'), file_get_contents('samples/df-001.txt') ),
   array(
      'DISKFREE_used'      => '4596444160',
      'DISKFREE_available' => '26860835840',
   ),
   'samples/df-001.txt'
);

is(
   ss_get_by_ssh( array(
      'file'    => 'samples/df-001.txt',
      'type'    => 'df',
      'host'    => 'localhost',
      'items'   => 'dw,dx',
      'volume'  => '/dev/vzfs',
   )),
   'dw:4596444160 dx:26860835840',
   'main(samples/df-001.txt)'
);

is_deeply(
   df_parse( array('volume' => '/dev/mapper/vg00-server'), file_get_contents('samples/df-002.txt') ),
   array(
      'DISKFREE_used'      => '437121024',
      'DISKFREE_available' => '3575664640',
   ),
   'samples/df-002.txt'
);

is(
   ss_get_by_ssh( array(
      'file'    => 'samples/df-002.txt',
      'type'    => 'df',
      'host'    => 'localhost',
      'items'   => 'dw,dx',
      'volume'  => '/dev/mapper/vg00-server',
   )),
   'dw:437121024 dx:3575664640',
   'main(samples/df-002.txt)'
);

is_deeply(
   netdev_parse( array('device' => 'eth0'), file_get_contents('samples/netdev-001.txt') ),
   array(
        'NETDEV_rxbytes'   => '99704481',
        'NETDEV_rxerrs'    => '0',
        'NETDEV_rxdrop'    => '0',
        'NETDEV_rxfifo'    => '0',
        'NETDEV_rxframe'   => '0',
        'NETDEV_txbytes'   => '21749178',
        'NETDEV_txerrs'    => '0',
        'NETDEV_txdrop'    => '0',
        'NETDEV_txfifo'    => '0',
        'NETDEV_txcolls'   => '0',
        'NETDEV_txcarrier' => '0',
   ),
   'samples/netdev-001.txt'
);

is(
   ss_get_by_ssh( array(
      'file'    => 'samples/netdev-001.txt',
      'type'    => 'netdev',
      'host'    => 'localhost',
      'items'   => 'dy,dz,e0,e1,e2,e3,e4,e5,e6,e7,e8',
      'device'  => 'eth0',
   )),
   'dy:99704481 dz:0 e0:0 e1:0 e2:0 e3:21749178 e4:0 e5:0 e6:0 e7:0 e8:0',
   'main(samples/netdev-001.txt)'
);

is_deeply(
   netstat_parse( null, file_get_contents('samples/netstat-001.txt') ),
   array(
       'NETSTAT_established'   => '7',
       'NETSTAT_syn_sent'      => '0',
       'NETSTAT_syn_recv'      => '0',
       'NETSTAT_fin_wait1'     => '1',
       'NETSTAT_fin_wait2'     => '27',
       'NETSTAT_time_wait'     => '6412',
       'NETSTAT_close'         => '0',
       'NETSTAT_close_wait'    => '0',
       'NETSTAT_last_ack'      => '0',
       'NETSTAT_listen'        => '11',
       'NETSTAT_closing'       => '0',
       'NETSTAT_unknown'       => '0',
   ),
   'samples/netstat-001.txt'
);

is(
   ss_get_by_ssh( array(
      'file'    => 'samples/netstat-001.txt',
      'type'    => 'netstat',
      'host'    => 'localhost',
      'items'   => 'e9,ea,eb,ec,ed,ee,ef,eg,eh,ei,ej,ek',
   )),
   'e9:7 ea:0 eb:0 ec:1 ed:27 ee:6412 ef:0 eg:0 eh:0 ei:11 ej:0 ek:0',
   'main(samples/netstat-001.txt)'
);

is_deeply(
   vmstat_parse( null, file_get_contents('samples/vmstat-001.txt') ),
   array(
      'VMSTAT_pswpin'  => '32',
      'VMSTAT_pswpout' => '1274',
   ),
   'samples/vmstat-001.txt'
);

is(
   ss_get_by_ssh( array(
      'file'    => 'samples/vmstat-001.txt',
      'type'    => 'vmstat',
      'host'    => 'localhost',
      'items'   => 'eo,ep',
   )),
   'eo:32 ep:1274',
   'main(samples/vmstat-001.txt)'
);

?>
