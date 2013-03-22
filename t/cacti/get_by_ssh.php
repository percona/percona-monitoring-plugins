<?php
require('test-more.php');
require('../../cacti/scripts/ss_get_by_ssh.php');
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
      'items'   => 'gw,gx,gy,gz,hg,hh,hi,hj,hk,hl,hm,hn' 
   )),
   'gw:24198 gx:0 gy:69614 gz:2630536 hg:558 hh:5872 hi:1572 hj:0 hk:0'
   . ' hl:339490 hm:697948 hn:11558',
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
      'items'   => 'hq,hr,hs,ht,hu,hv'
   )),
   'hq:22106112 hr:1531904 hs:0 ht:17928192 hu:21389312 hv:62955520',
   'main(samples/free-001.txt)'
);

is_deeply(
   w_parse( null, file_get_contents('samples/w-001.txt') ),
   array(
      'STAT_loadavg' => '0.00',
      'STAT_numusers' => '2',
   ),
   'samples/w-001.txt'
);

is_deeply(
   w_parse( null, file_get_contents('samples/w-002.txt') ),
   array(
      'STAT_loadavg' => '0.29',
      'STAT_numusers' => '6',
   ),
   'samples/w-002.txt'
);

is_deeply(
   w_parse( null, file_get_contents('samples/w-003.txt') ),
   array(
      'STAT_loadavg' => '0.02',
      'STAT_numusers' => '1',
   ),
   'samples/w-003.txt'
);

is_deeply(
   w_parse( null, file_get_contents('samples/w-004.txt') ),
   array(
      'STAT_loadavg' => '11.02',
      'STAT_numusers' => '1',
   ),
   'samples/w-004.txt'
);

is_deeply(
   w_parse( null, file_get_contents('samples/uptime-001.txt') ),
   array(
      'STAT_loadavg' => '0.00',
      'STAT_numusers' => '0',
   ),
   'samples/uptime-001.txt'
);

is(
   ss_get_by_ssh( array(
      'file'    => 'samples/w-001.txt',
      'type'    => 'w',
      'host'    => 'localhost',
      'items'   => 'ho,hp'
   )),
   'ho:0.00 hp:2',
   'main(samples/w-001.txt)'
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

is(
   ss_get_by_ssh( array(
      'file'    => 'samples/memcached-001.txt',
      'type'    => 'memcached',
      'host'    => 'localhost',
      'items'   => 'ij,ik,il,im,in,io,ip,iq,ir,is,it,iu,iv'
   )),
   'ij:396024 ik:1956122 il:0 im:0 in:0 io:1 ip:5 iq:0 ir:0 is:0 it:0 iu:45'
   . ' iv:942',
   'main(samples/memcached-001.txt)'
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

is(
   ss_get_by_ssh( array(
      'file'    => 'samples/nginx-001.txt',
      'type'    => 'nginx',
      'host'    => 'localhost',
      'items'   => 'hw,hx,hy,hz,ig,ih,ii'
   )),
   'hw:251 hx:255601634 hy:255601634 hz:671013148 ig:5 ih:27 ii:219',
   'main(samples/nginx-001.txt)'
);

is_deeply(
   apache_parse( null, file_get_contents('samples/apache-001.txt') ),
   array(
      'APACHE_Requests'               => '3452389',
      'APACHE_Bytes_sent'             => '23852769280',
      'APACHE_Idle_workers'           => '8',
      'APACHE_Busy_workers'           => '1',
      'APACHE_CPU_Load'               => '.023871',
      'APACHE_Waiting_for_connection' => '8',
      'APACHE_Starting_up'            => 0,
      'APACHE_Reading_request'        => 0,
      'APACHE_Sending_reply'          => '1',
      'APACHE_Keepalive'              => 0,
      'APACHE_DNS_lookup'             => 0,
      'APACHE_Closing_connection'     => 0,
      'APACHE_Logging'                => 0,
      'APACHE_Gracefully_finishing'   => 0,
      'APACHE_Idle_cleanup'           => 0,
      'APACHE_Open_slot'              => '247',
   ),
   'samples/apache-001.txt'
);

is_deeply(
   apache_parse( null, file_get_contents('samples/apache-002.txt') ),
   array(
      'APACHE_Requests'               => '368',
      'APACHE_Bytes_sent'             => 1151 * 1024,
      'APACHE_Idle_workers'           => '19',
      'APACHE_Busy_workers'           => '1',
      'APACHE_CPU_Load'               => '.0284617',
      'APACHE_Waiting_for_connection' => '19',
      'APACHE_Starting_up'            => 0,
      'APACHE_Reading_request'        => 0,
      'APACHE_Sending_reply'          => '1',
      'APACHE_Keepalive'              => 0,
      'APACHE_DNS_lookup'             => 0,
      'APACHE_Closing_connection'     => 0,
      'APACHE_Logging'                => 0,
      'APACHE_Gracefully_finishing'   => 0,
      'APACHE_Idle_cleanup'           => 0,
      'APACHE_Open_slot'              => '236',
   ),
   'samples/apache-002.txt'
);

is(
   ss_get_by_ssh( array(
      'file'    => 'samples/apache-001.txt',
      'type'    => 'apache',
      'host'    => 'localhost',
      'items'   => 'gg,gh,gi,gj,gk,gl,gm,gn,go,gp,gq,gr,gs,gt,gu,gv'
   )),
   'gg:3452389 gh:23852769280 gi:8 gj:1 gk:.023871 gl:8 gm:0 gn:0 go:1 gp:0'
   . ' gq:0 gr:0 gs:0 gt:0 gu:0 gv:247',
   'main(samples/apache-001.txt)'
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
      'DISK_io_time'            => '12368',
      'DISK_io_time_weighted'   => '28832',
      'DISK_io_ops'             => '24780'
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
      'DISK_io_ops'             => '181509'
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
      'DISK_io_ops'             => '488334420'
   ),
   'samples/diskstats-003.txt'
);

is(
   ss_get_by_ssh( array(
      'file'    => 'samples/diskstats-001.txt',
      'type'    => 'diskstats',
      'host'    => 'localhost',
      'items'   => 'iw,ix,iy,iz,jg,jh,ji,jj,jk,jl,jm',
      'device'  => 'hda1'
   )),
   'iw:12043 ix:387 iy:300113 iz:6472 jg:12737 jh:21340 ji:272616 jj:22360'
   . ' jk:24780 jl:12368 jm:28832',
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
      'items'   => 'jn,jo,jp,jq,jr,js,jt,ju,jv,jw,jx,jy,jz,kg,kh,ki,kj,kk,kl,km,kn,ko,kp,kq,kr,ks,kt,ku,kv,kw,kx,ky,kz,lg,lh,li,lj,lk,ll,lm',
   )),
   'jn:8906701 jo:0 jp:0 jq:0 jr:39695 js:0 jt:688 ju:0 jv:32 jw:0 jx:11101'
   . ' jy:0 jz:0 kg:0 kh:11101 ki:0 kj:6 kk:0 kl:6 km:0 kn:1 ko:0 kp:0 kq:0'
   . ' kr:338656 ks:0 kt:98304 ku:0 kv:9280 kw:0 kx:0 ky:0 kz:9 lg:0 lh:0 li:0'
   . ' lj:788 lk:0 ll:10 lm:0',
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
      'items'   => 'ln,lo,lp,lq,lr,ls',
   )),
   'ln:119 lo:911 lp:412372 lq:4321 lr:3333 ls:5',
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
         'items' => 'lt,lu,lv,lw,lx,ly,lz,mg,mh,mi,mj',
      )
   ),
   'lt:52685256 lu:205979648 lv:1864171520 lw:55160928 lx:61603840'
   . ' ly:318767104 lz:60 mg:1024 mh:7 mi:172 mj:200',
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
      'items'   => 'mk,ml,mm,mn,mo,mp,mq,mr,ms,mt,mu,mv,mw,mx,my,mz,ng,nh,ni',
   )),
   'mk:3 ml:16029581312 mm:64981303296 mn:65457356800 mo:1589814 mp:1589814'
   . ' mq:0 mr:0 ms:4883 mt:2309034 mu:472 mv:36 mw:1584705 mx:145518'
   . ' my:2521129 mz:601 ng:2268817 nh:17810 ni:0',
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
      'items'   => 'nj,nk',
      'volume'  => '/dev/vzfs',
   )),
   'nj:4596444160 nk:26860835840',
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
      'items'   => 'nj,nk',
      'volume'  => '/dev/mapper/vg00-server',
   )),
   'nj:437121024 nk:3575664640',
   'main(samples/df-002.txt)'
);

is_deeply(
   netdev_parse( array('device' => 'eth0'), file_get_contents('samples/netdev-001.txt') ),
   array(
        'NETDEV_inbound'   => '99704481',
        'NETDEV_rxerrs'    => '0',
        'NETDEV_rxdrop'    => '0',
        'NETDEV_rxfifo'    => '0',
        'NETDEV_rxframe'   => '0',
        'NETDEV_outbound'  => '21749178',
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
      'items'   => 'nl,nm,nn,no,np,nq,nr,ns,nt,nu,nv',
      'device'  => 'eth0',
   )),
   'nl:99704481 nm:0 nn:0 no:0 np:0 nq:21749178 nr:0 ns:0 nt:0 nu:0 nv:0',
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
      'items'   => 'nw,nx,ny,nz,og,oh,oi,oj,ok,ol,om,on',
   )),
   'nw:7 nx:0 ny:0 nz:1 og:27 oh:6412 oi:0 oj:0 ok:0 ol:11 om:0 on:0',
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
      'items'   => 'oo,op',
   )),
   'oo:32 op:1274',
   'main(samples/vmstat-001.txt)'
);

?>
