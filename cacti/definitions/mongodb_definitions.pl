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
   name   => 'MongoDB Server',
   hash   => 'hash_02_VER_84ce0c2c9aa026d00b96855bdf871054',
   version => {
      version => '1.1.8',
      hash    => 'hash_06_VER_a6ad1a38080a578e67ad18fa4be4ac9a',
   },
   checksum => 'hash_06_VER_821f03ccd62a3befed9a768ac4932858',
   graphs => [
      {  name       => 'MongoDB Connections',
         base_value => '1000',
         hash       => 'hash_00_VER_dba507645d086014b4ed0b4d44e9387a',
         dt         => {
            hash       => 'hash_01_VER_4f7f138dfa3fb4c33dc1e61119977dbb',
            input      => 'Get MongoDB Stats',
            MONGODB_connected_clients => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_0e74f4236f462a54a211ac1dc60b96a8'
            },
         },
         items => [
            {  item   => 'MONGODB_connected_clients',
               color  => '9B2B1B',
               task   => 'hash_09_VER_21d41d3aa727d4cd070d7e605b2c44f9',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_913a9ed433e4cc74053baf168ce60c81',
                  'hash_10_VER_74602650f3181ba0ee2db63ad6487f17',
                  'hash_10_VER_75a6f840091667dbe70f3e2754f55a2f',
                  'hash_10_VER_a8a38c9a36965cad0439e348e5d1af82'
               ],
            },
         ],
      },
      {  name       => 'MongoDB Memory',
         base_value => '1000',
         hash       => 'hash_00_VER_f01951c2799f75c4c1d1bed47eb96e40',
         dt         => {
            hash       => 'hash_01_VER_7e137605a58148cf8a555e6baf20eb65',
            input      => 'Get MongoDB Stats',
            MONGODB_used_virtual_memory => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_f475ce42705736a51c34cb23aacbc59c'
            },
            MONGODB_used_mapped_memory => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_105540d3a0b2664526af482a402879a4'
            },
            MONGODB_used_resident_memory => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_3e96effb78a68f210912bbb4361c387c'
            },
         },
         items => [
            {  item   => 'MONGODB_used_virtual_memory',
               color  => '3B7AD9',
               task   => 'hash_09_VER_936aaccd9fe9a045f9390ad43f39b340',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_aca5c6394c7044db6e692116d4cf8157',
                  'hash_10_VER_33d353aaa7402585620291409568caff',
                  'hash_10_VER_de9b6cb0db0f43cbdc28f9f8b6a596be',
                  'hash_10_VER_25135544e3d38c248793b353e54faeb8'
               ],
            },
            {  item   => 'MONGODB_used_mapped_memory',
               color  => '6FD1BF',
               task   => 'hash_09_VER_c10f15a6a1883445421af675cca5d42e',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_44b596605bebc90b45a526331d3391f0',
                  'hash_10_VER_8b83f86611fd0567225bbcd69f649f23',
                  'hash_10_VER_13267cb4cc2f57e42e77afc63f93682a',
                  'hash_10_VER_275260a561c1707ad24ddca5b427adb4'
               ],
            },
            {  item   => 'MONGODB_used_resident_memory',
               color  => '0E6E5C',
               task   => 'hash_09_VER_48aedb0124cacaf12b138ec38a73ca3f',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_3e7d709085ccdaf9afed9d3a6c98db5a',
                  'hash_10_VER_d79210d1ffb8a132f70b22c75c3c3c52',
                  'hash_10_VER_55396aa89c98397a4cc3f31b52f87990',
                  'hash_10_VER_c1ba73653931511c45060f267fc6cb30'
               ],
            },
         ],
      },
      {  name       => 'MongoDB Commands',
         base_value => '1000',
         hash       => 'hash_00_VER_80a7a84bde78767289d31d1ed655afd5',
         dt         => {
            hash       => 'hash_01_VER_f5edc729abaf7108fdb225dbef0269d2',
            input      => 'Get MongoDB Stats',
            MONGODB_op_inserts => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_99a1475f96923a6424566af7187d8755'
            },
            MONGODB_op_queries => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_cbfaa4bf39e56a544d33f1b3dae25f59'
            },
            MONGODB_op_updates => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_270098586e9ddb730b228db4db35dc83'
            },
            MONGODB_op_deletes => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_a39184cbd72f1710576d2f96cd7c9c01'
            },
            MONGODB_op_getmores => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_b7b44cedfe365a8d1591e7b1cf7974cf'
            },
            MONGODB_op_commands => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_855722b9df77c4a52cdc6dcb5535fdf9'
            },
         },
         items => [
            {  item   => 'MONGODB_op_inserts',
               color  => 'FF7200',
               task   => 'hash_09_VER_51843de5556c83fd6017210bcbe1c8dc',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_25f0c6652a13d2aa625e000b6df313d3',
                  'hash_10_VER_e6e557c4308cef7f185895bcbb4e7d1c',
                  'hash_10_VER_a3b2ad85b70ebbc7d61bb43b81409892',
                  'hash_10_VER_acfc0b6a993edf8d33c9b092f317c9e6'
               ],
            },
            {  item   => 'MONGODB_op_queries',
               color  => '503001',
               task   => 'hash_09_VER_bb359d50779d9fa5a00d76b78b6a4b0c',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_afd2d45192c139095bacb9feee1ffab5',
                  'hash_10_VER_ec73cdf0ae78c03e734d023c14a24a0a',
                  'hash_10_VER_f564cd40dee74afda778005b8b511e63',
                  'hash_10_VER_06f0d7c21e83da219532f68b0176c3f8'
               ],
            },
            {  item   => 'MONGODB_op_updates',
               color  => 'EDAC00',
               task   => 'hash_09_VER_23bd922edc3460e20607d1fc4d49b3a3',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_0de086b64280315bf8b46137882e7913',
                  'hash_10_VER_52347bc4d82487b5c1c964f9cfcf365a',
                  'hash_10_VER_1c40a2119fb0d1744db533e1fe859b4b',
                  'hash_10_VER_76078fc1ad0b4cdc0b3de91e8b0914f8'
               ],
            },
            {  item   => 'MONGODB_op_deletes',
               color  => '506101',
               task   => 'hash_09_VER_a1bdad535e71b4d0586a15bcd95b0db4',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_3e49b88d0953866e87ee17645b394008',
                  'hash_10_VER_2ef0b64c0cedd6cb628a5163f171c25c',
                  'hash_10_VER_199f308f7588dea4b0007e45b1835556',
                  'hash_10_VER_508bff27083eada2973d6cb2176e78e9'
               ],
            },
            {  item   => 'MONGODB_op_getmores',
               color  => '0CCCCC',
               task   => 'hash_09_VER_bd1348bd4e29a59053855d9a5991ad34',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_827895cdb5c458e76b3531ca22b65933',
                  'hash_10_VER_94c1370388158e64b1f14bb0cf972cca',
                  'hash_10_VER_370af505286ec26fe7940b461369e73b',
                  'hash_10_VER_f7eee0432160a69e98746e03793533d5'
               ],
            },
            {  item   => 'MONGODB_op_commands',
               color  => '53CA05',
               task   => 'hash_09_VER_38b38ffc417def78328030363aaec579',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_8670a7133b9b8e062018918554234603',
                  'hash_10_VER_e0dd370c9a09110551dcad6958da48a0',
                  'hash_10_VER_7b664bf01401fb6c7f59bd582ab5161b',
                  'hash_10_VER_19ede2025d22ed99b6b4b9795e9c6f7a'
               ],
            },
         ],
      },
      {  name       => 'MongoDB Index Ops',
         base_value => '1000',
         hash       => 'hash_00_VER_848c071980c96258dd18744b3a9ff39c',
         dt         => {
            hash       => 'hash_01_VER_bd5644cbf5d3ca35337f79f9e0f8b4a4',
            input      => 'Get MongoDB Stats',
            MONGODB_index_accesses => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_46eb1be565c7a55ecdf704eb298a8c88'
            },
            MONGODB_index_hits => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_e8ea64ab280f5de96736df018731f288'
            },
            MONGODB_index_misses => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_62a52639845ff73bb78b6d975bc24b41'
            },
            MONGODB_index_resets => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_ccf8394176d5abd677f92505f00f1658'
            },
         },
         items => [
            {  item   => 'MONGODB_index_accesses',
               color  => 'FF7200',
               task   => 'hash_09_VER_b9dbbef8132bc85a9e5264d4f7ebaf53',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_eda1210fc9cea3e25e5679a1e84c682d',
                  'hash_10_VER_c56af0ca1cbd299acab1d5fea1271caa',
                  'hash_10_VER_1f2361d26a14ba73d084aedd939cb46d',
                  'hash_10_VER_a7071be3273f22095dbd5d451d8ea7bc'
               ],
            },
            {  item   => 'MONGODB_index_hits',
               color  => '503001',
               task   => 'hash_09_VER_5b0d0368aa961d96e77ba1b4ac43255e',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_9200f01ce0d9d4a22855cada0f075676',
                  'hash_10_VER_95c94c6fac87cb29b89c528735b7696c',
                  'hash_10_VER_4c8096f50a59e9d4fb2a85055592d315',
                  'hash_10_VER_88a4f0d29e3edf2869b672557c575a9d'
               ],
            },
            {  item   => 'MONGODB_index_misses',
               color  => 'EDAC00',
               task   => 'hash_09_VER_b96035a15bf05b77e0c3d966a1605ec3',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_a935f7447f61ce516bf778b0334cb156',
                  'hash_10_VER_cf0f73b6c696ab9fa31bbf9ec8bcb8f6',
                  'hash_10_VER_53795146d0ce1df8f1b678f53ca40d19',
                  'hash_10_VER_40be6010aebedb2f7da2fdaccf6f7f32'
               ],
            },
            {  item   => 'MONGODB_index_resets',
               color  => '506101',
               task   => 'hash_09_VER_be464f29ce22e1f52ca992bb76cf3cb3',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_05e1ef078af38b6df02a5dad8cb3668a',
                  'hash_10_VER_ac442bc02c64ab54341de23c27fc59ad',
                  'hash_10_VER_a79064534fc4a79fc1c378c494a58ef5',
                  'hash_10_VER_9e7cd2b5c58e33f1609cc43fc6cd101e'
               ],
            },
         ],
      },
      {  name       => 'MongoDB Background Flushes',
         base_value => '1000',
         hash       => 'hash_00_VER_e54ed4634fd41c685b98ee1cd62dba5e',
         dt         => {
            hash       => 'hash_01_VER_013e3f54ad8c37507c8e4d2897da823f',
            input      => 'Get MongoDB Stats',
            MONGODB_back_flushes => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_911b147d6f39c8dbf86c0009581ef58f'
            },
            MONGODB_back_total_ms => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_bb0448956715e340eb299d17513d263d'
            },
            MONGODB_back_average_ms => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_a7414d1f065cbab2320b4b0b0ff71edc'
            },
            MONGODB_back_last_ms => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_ce3f2037f1d85ed067a4fc2a8aa04d51'
            },
         },
         items => [
            {  item   => 'MONGODB_back_flushes',
               color  => '71FF06',
               task   => 'hash_09_VER_785524f59ad8a61a3a8055a50710d17c',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_88385e7e266bcfe7aa35f496c4d24da3',
                  'hash_10_VER_56f0327b458c2392e13cb7d73ac46ef6',
                  'hash_10_VER_1eb2899e371b775acec3e5783ff49d51',
                  'hash_10_VER_137bca1ad0aa94f3029afd740ee1d95e'
               ],
            },
            {  item   => 'MONGODB_back_total_ms',
               color  => 'FF2400',
               task   => 'hash_09_VER_075d63b55ffad4d20c3bf2bf7dfd65a7',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_6f14f158408e1077617f27d345d6e433',
                  'hash_10_VER_95ebd255c839bff1d47ceed2fbf5c028',
                  'hash_10_VER_59e323765d8f42883701eba0c963de8c',
                  'hash_10_VER_4fc49b2fc73fde5b0bc320eeb4377875'
               ],
            },
            {  item   => 'MONGODB_back_average_ms',
               color  => 'E83089',
               task   => 'hash_09_VER_3fbfd1f87e64b8bcd2a2cce4577ac417',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_2a0c2374dc568cc268026e711c8fec39',
                  'hash_10_VER_df6aaeaa863dfdca8d770bef7705edae',
                  'hash_10_VER_2ea6e12bb40f7539c93559c8eda79ca0',
                  'hash_10_VER_fc4a6a58606d710e13564603140653d1'
               ],
            },
            {  item   => 'MONGODB_back_last_ms',
               color  => '17D2E1',
               task   => 'hash_09_VER_821277043f15e675a713c6e690d37260',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_ec73703301f5d6365f1524edc484bb41',
                  'hash_10_VER_04008f2d5384206553d6333b1ea5babd',
                  'hash_10_VER_27bb936bc4f5687182b9cb43c81852e1',
                  'hash_10_VER_e7b9de63dff13e7275bd8cb005e3dd8a'
               ],
            },
         ],
      },
      {  name       => 'MongoDB Slave Lag',
         base_value => '1000',
         hash       => 'hash_00_VER_6cfb71a1dc590427a4f67abaa4dd6ee4',
         dt         => {
            hash       => 'hash_01_VER_529a99cd4b6edb898fa8feec8e83e21f',
            input      => 'Get MongoDB Stats',
            MONGODB_slave_lag => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_625e2cdbc38a3b585a7853d4b200d698'
            },
         },
         items => [
            {  item   => 'MONGODB_slave_lag',
               color  => '3F00B8',
               task   => 'hash_09_VER_c80db7bad932cc5c423f5cbfe0a42ee2',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_c2755fa8b0515fa3873f1337190789df',
                  'hash_10_VER_3e88dc304b302139f13e896022bccb1b',
                  'hash_10_VER_62ee89e92919a52ea61ec8023851d82e',
                  'hash_10_VER_e6d21024f9c230356b004ff222a6999f'
               ],
            },
         ],
      },
   ],
   inputs => {
      'Get MongoDB Stats' => {
         type_id      => 1,
         hash         => 'hash_03_VER_60ed7b684520464b297f37dc2bd9e8dc',
         input_string => '<path_php_binary> -q <path_cacti>/scripts/ss_get_by_ssh.php '
                       . '--host <hostname> --type mongodb --items <items> ',
         inputs => [
            {  allow_nulls => '',
               hash        => 'hash_07_VER_82825188a4c13b855a5e22957e7f360c',
               name        => 'hostname'
            },
            {  allow_nulls => 'on',
               hash        => 'hash_07_VER_3b6b2abbb52a49d4c36b9d6c5f2ee1f0',
               name        => 'port2',
            },
         ],
         outputs => {
            MONGODB_connected_clients        => 'hash_07_VER_368a909f411926bacf04b0471272addd',
            MONGODB_used_resident_memory     => 'hash_07_VER_26c4dc0fec2e453f4fabc00e7bd04f29',
            MONGODB_used_mapped_memory       => 'hash_07_VER_ef9a8d4ae93bd14f04d051015f0baa68',
            MONGODB_used_virtual_memory      => 'hash_07_VER_7eb45727b3a37545f1a3e886f2d00680',
            MONGODB_index_accesses           => 'hash_07_VER_777d92fd00565f0679fd4990f04f3136',
            MONGODB_index_hits               => 'hash_07_VER_5fd799714e2a28e4e11ac760aa8850a1',
            MONGODB_index_misses             => 'hash_07_VER_b6565823721824dc64bad2edcfb9b09c',
            MONGODB_index_resets             => 'hash_07_VER_e68de5962130d08b205a9488a629bb92',
            MONGODB_back_flushes             => 'hash_07_VER_d2966c4241e730b30cd304879cdb8dc2',
            MONGODB_back_total_ms            => 'hash_07_VER_c0dd19ec1e043b25f35ca0991dc9e595',
            MONGODB_back_average_ms          => 'hash_07_VER_42b62ff37b971947a5cb5efc7f5157ad',
            MONGODB_back_last_ms             => 'hash_07_VER_979d2bfebbb509181e4c4f9b7839ed9e',
            MONGODB_op_inserts               => 'hash_07_VER_064fd5cd30c258b953bc0d16e6df633e',
            MONGODB_op_queries               => 'hash_07_VER_cd45d5d4b38e96f23e6c0e27134ed667',
            MONGODB_op_updates               => 'hash_07_VER_684c71c7d8f1444d061e2c2e7c02b77f',
            MONGODB_op_deletes               => 'hash_07_VER_7a0a1c29c036e456291cff7b5d2550b6',
            MONGODB_op_getmores              => 'hash_07_VER_33ca6d7f73ab40c58d46cdab85070d4c',
            MONGODB_op_commands              => 'hash_07_VER_db34dc36487cb71c5b3364b2b79c6b2b',
            MONGODB_slave_lag                => 'hash_07_VER_d3e87eac689afb5c3a53888f8939396a',
         },
      },
   },
};
