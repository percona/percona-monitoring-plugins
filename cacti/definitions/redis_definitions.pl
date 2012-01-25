# This is the template definition file.  To use it, see make-template.pl.  This
# one goes with the ss_get_by_ssh.php script.
#
# This program is copyright (c) 2008 Baron Schwartz. Feedback and improvements
# are welcome.
#
# THIS PROGRAM IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
# MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, version 2.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, write to the Free Software Foundation, Inc., 59 Temple
# Place, Suite 330, Boston, MA  02111-1307  USA.

# Autobuild: ss_get_by_ssh.php

{
   name   => 'Redis Server',
   hash   => 'hash_02_VER_f3047229cf7d96bb613032d847a29113',
   version => {
      version => '1.1.8',
      hash    => 'hash_06_VER_0f91ebe15204e0d45977627acaabd138',
   },
   checksum => 'hash_06_VER_fc13e22cb63305e2ac89c5e350af8337',
   graphs => [
      {  name       => 'Redis Connections',
         base_value => '1000',
         hash       => 'hash_00_VER_84ebd40765d98e2f876692bec708bb6d',
         dt         => {
            hash       => 'hash_01_VER_eeae29f39e8657454bde3e7600937f63',
            input      => 'Get Redis Stats',
            REDIS_connected_clients => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_aab0dc2585c37325ebbb92d370e82d98'
            },
            REDIS_connected_slaves => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_542d97edeb5b0ed52e0b90ca770e3c76'
            },
            REDIS_total_connections_received => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_e1ce80efd6fe12e05e336478fb6e6749'
            },
         },
         items => [
            {  item   => 'REDIS_connected_clients',
               color  => '9B2B1B',
               task   => 'hash_09_VER_8e28f481aca7e96e4064dee8c2c69c3c',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_4af5df96e560fcb0a8f1930f7b1156cf',
                  'hash_10_VER_fca522db4bea3e30fde7361a69b6ac5f',
                  'hash_10_VER_cb171679f47cb9121e1e72f472be0c1a',
                  'hash_10_VER_fa606307b66560ae38e985bde5a10713'
               ],
            },
            {  item   => 'REDIS_connected_slaves',
               color  => '4A170F',
               task   => 'hash_09_VER_d328df039fcce441380c3a3ab8c5a550',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_e08f91815b0669edce068596f9e040ab',
                  'hash_10_VER_385daccb37cbcda9a3ac80d4c22ffe51',
                  'hash_10_VER_ecd035859f634165aa089fdde12f40fc',
                  'hash_10_VER_e5d3c4faeb89ac9fe27650ca7a597d55'
               ],
            },
            {  item   => 'REDIS_total_connections_received',
               color  => '38524B',
               task   => 'hash_09_VER_fdf1c0f25b286c2b56ba6aac54b74aaa',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_49f5d38e05744070047bccb319a16546',
                  'hash_10_VER_e058cdb4c48e5bf41876d27304cd99e8',
                  'hash_10_VER_6043255d0c40482b024a50d53bb93f5b',
                  'hash_10_VER_edbcee791812e1f90f83f5f5bf5fb4f7'
               ],
            },
         ],
      },
      {  name       => 'Redis Memory',
         base_value => '1024',
         hash       => 'hash_00_VER_6bc7cee7973b7f44ecda5b6289c3d41b',
         dt         => {
            hash       => 'hash_01_VER_71bbb5674a7fd60127453b1c17953cb4',
            input      => 'Get Redis Stats',
            REDIS_used_memory => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_a0502b590f50ad61522d7804e7fcb62b'
            },
         },
         items => [
            {  item   => 'REDIS_used_memory',
               color  => '3B7AD9',
               task   => 'hash_09_VER_75d120ce56a9e0653b86076fe0030179',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_c12a3a6161aa489bbfe6c6f11f587812',
                  'hash_10_VER_d31f6df64a0459cc6175236c194b4a52',
                  'hash_10_VER_77a22aed4ece675903470dd9144bac24',
                  'hash_10_VER_08013b39e1e214843bc431d51a26497d'
               ],
            },
         ],
      },
      {  name       => 'Redis Commands',
         base_value => '1000',
         hash       => 'hash_00_VER_9bf8937365d86e0fbff94d75151f891c',
         dt         => {
            hash       => 'hash_01_VER_9f7324073b69c016bdbac67afa871f4a',
            input      => 'Get Redis Stats',
            REDIS_total_commands_processed => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_c4e04070d2ae18fe32beaf1059260162'
            },
         },
         items => [
            {  item   => 'REDIS_total_commands_processed',
               color  => 'FF7200',
               task   => 'hash_09_VER_8bafab546a3c2c9a329163eda7e795c9',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_3c021e98935b259b66342b91ff13908e',
                  'hash_10_VER_90b832f143d92387f1c5eebff447fc59',
                  'hash_10_VER_3ce50de9067697a964dfd1e90571c2b1',
                  'hash_10_VER_111ccb7df69a4e5e336a6a2ba7bef753'
               ],
            },
         ],
      },
      {  name       => 'Redis Unsaved Changes',
         base_value => '1000',
         hash       => 'hash_00_VER_24e1734c18efaccdeae5637075647313',
         dt         => {
            hash       => 'hash_01_VER_7fd4ba2d9a1f72af2c4cadb9a5fe120b',
            input      => 'Get Redis Stats',
            REDIS_changes_since_last_save => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_05844394fda8a854144e5cd88760a4f7'
            },
         },
         items => [
            {  item   => 'REDIS_changes_since_last_save',
               color  => 'A88558',
               task   => 'hash_09_VER_b44eb38fbf04f9c72e16dbcd05f29289',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_9e773c0569b332325b06f482ba5c2461',
                  'hash_10_VER_997754feac9bfa6126b4081086557f58',
                  'hash_10_VER_e4495715fb649e8af1dc8c6e1f9d69c9',
                  'hash_10_VER_b2b7e39747eaca57a6acd5b1f6aabc8b'
               ],
            },
         ],
      },
   ],
   inputs => {
      'Get Redis Stats' => {
         type_id      => 1,
         hash         => 'hash_03_VER_3d39a7a9c9c25791440c870db77ea738',
         input_string => '<path_php_binary> -q <path_cacti>/scripts/ss_get_by_ssh.php '
                       . '--host <hostname> --type redis --items <items> ',
         inputs => [
            {  allow_nulls => '',
               hash        => 'hash_07_VER_4ac2e9c33e6d098e3b735d252d4fd84e',
               name        => 'hostname'
            },
            {  allow_nulls => 'on',
               hash        => 'hash_07_VER_4ac2e9c33e6d098e3b735d252d4fd84f',
               name        => 'port2'
            },
         ],
         outputs => {
            REDIS_connected_clients          => 'hash_07_VER_aeca8ba12e90190900f1da95a6e954ae',
            REDIS_connected_slaves           => 'hash_07_VER_6f717310dd5348ecf294bbfe7d387444',
            REDIS_used_memory                => 'hash_07_VER_bf96594b2ae19aa9eff40379096dcc79',
            REDIS_changes_since_last_save    => 'hash_07_VER_e72bdb6771b1d525bb68824e6648cc53',
            REDIS_total_connections_received => 'hash_07_VER_c1eef47fc6d9178e16a227a45bff6336',
            REDIS_total_commands_processed   => 'hash_07_VER_bb4948db9c650a1ab5e7278d3e6f7479',
         },
      },
   },
};
