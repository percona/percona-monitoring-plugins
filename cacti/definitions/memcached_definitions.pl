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
   name   => 'Memcached Server',
   hash   => 'hash_02_VER_1827008740e9ec8ca2103434f56302c8',
   version => {
      version => '1.1.8',
      hash    => 'hash_06_VER_ac10705723a27cae224aa85dc7e38cdc',
   },
   checksum => 'hash_06_VER_5e4fdcffaa9d5f03dfb4a4bdd992e555',
   graphs => [
      {  name       => 'Memcached Rusage',
         base_value => '1000',
         hash       => 'hash_00_VER_09d9a71a602d18d831925419fddbdd39',
         dt         => {
            hash       => 'hash_01_VER_07ad123d392f3d06d255271acb37f628',
            input      => 'Get Memcached Stats',
            MEMC_rusage_user => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_ccda4eba57a840570248abdcfc46043f'
            },
            MEMC_rusage_system => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_d51a5c5f1b7194edb50c9c6c2b50776b'
            },
         },
         items => [
            {  item   => 'MEMC_rusage_user',
               color  => '91204D',
               task   => 'hash_09_VER_75f16bbbd9a2db71c459d811910d638b',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_1324ebad5fb000d1baa62fb4610b2b7b',
                  'hash_10_VER_0cab391e9fca9406bb1824e8b3b9b724',
                  'hash_10_VER_fcdaa9ac97c925ba2af1486063b2d401',
                  'hash_10_VER_042bdc29fe56dc077c2735581c3bea87'
               ],
            },
            {  item   => 'MEMC_rusage_system',
               color  => 'E4844A',
               task   => 'hash_09_VER_edca72f9a4e2157edecfced39fde2c15',
               type   => 'STACK',
               hashes => [
                  'hash_10_VER_f8fa75f03441ae0b91e0c5be6220ce9a',
                  'hash_10_VER_ce3e5624bb0dc6dfde7dd5a8996b9d14',
                  'hash_10_VER_0dbfbb6b2f12b2bd5bc815b3976becb1',
                  'hash_10_VER_8704c32d7c43d204ccf192affdda1967'
               ],
            },
         ],
      },
      {  name       => 'Memcached Current Items',
         base_value => '1000',
         hash       => 'hash_00_VER_d96a39dda6aa105080d0eadc4e1e7bfc',
         dt         => {
            hash       => 'hash_01_VER_9fd6baac1477b928ef3ed12856dcede5',
            input      => 'Get Memcached Stats',
            MEMC_curr_items => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_19dd6c8d0129e6a0ee16da9ca5705190'
            },
         },
         items => [
            {  item   => 'MEMC_curr_items',
               color  => '3D2610',
               task   => 'hash_09_VER_b0b89fae3cc04882538d43f6b709468a',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_c80a4b8509f3a7d505522597deedeb02',
                  'hash_10_VER_14c707bb374461c17c46784024e3591d',
                  'hash_10_VER_7849bcecdc08a29b3a3d3968c83896e0',
                  'hash_10_VER_7f654cc75c52d6ede508a2dc20088d63'
               ],
            },
         ],
      },
      {  name       => 'Memcached Additions and Evictions',
         base_value => '1000',
         hash       => 'hash_00_VER_1a26f1b8f757f5881ffd656d729cbafc',
         dt         => {
            hash       => 'hash_01_VER_8bf04184980e94d02929412c0da0e8ed',
            input      => 'Get Memcached Stats',
            MEMC_total_items => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_aa7bfa7266ac4c57af2c3402945e1ac2'
            },
            MEMC_evictions => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_c8edc0984b23d25afe50283ad9bcf20b'
            },
         },
         items => [
            {  item   => 'MEMC_total_items',
               color  => '324D88',
               task   => 'hash_09_VER_fa38b3baaa91995d0ceeb7d367cb9a5a',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_471b944587687b29a448fe54a26298bb',
                  'hash_10_VER_2d05a3131122f9743aa1c0fca741e93d',
                  'hash_10_VER_e09c9795296683aa9788d39185260c95',
                  'hash_10_VER_c5c34bd102bf1f3de3e71a789448cefb'
               ],
            },
            {  item   => 'MEMC_evictions',
               color  => 'A03333',
               task   => 'hash_09_VER_13591371f8ad724c4d5ba3e3d4a97271',
               type   => 'AREA',
               cdef   => 'Negate',
               hashes => [
                  'hash_10_VER_2b957916996bb5cb0538e1ad1ed6de06',
                  'hash_10_VER_0adfb7f1d5fc9877ae3a60c79363ed08',
                  'hash_10_VER_70bc665ac4abf87ad1f25af8ada5a411',
                  'hash_10_VER_3bb04a6049aaa9d4dd2ee4325accb099'
               ],
            },
         ],
      },
      {  name       => 'Memcached Memory',
         base_value => '1024',
         hash       => 'hash_00_VER_b0970cc645cb8a8f559a968ad45efa25',
         dt         => {
            hash       => 'hash_01_VER_6060f90c4b48dc5d591d27bbdfb57fe7',
            input      => 'Get Memcached Stats',
            MEMC_bytes => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_039f751d5ff6352691052c347c8d1ddd'
            },
         },
         items => [
            {  item   => 'MEMC_bytes',
               color  => '3C5E53',
               task   => 'hash_09_VER_1c30d133a982f198257a72871e448e8b',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_344dfa1d72d2487ddca98c8cf1da0fe9',
                  'hash_10_VER_4050ab5ede860b9b6d82b3bc1698cd83',
                  'hash_10_VER_fc5b788299131f2ca367d544b1e238d8',
                  'hash_10_VER_42c1f9d4435b14c9ac93650ac8254e2f'
               ],
            },
         ],
      },
      {  name       => 'Memcached Connections',
         base_value => '1000',
         hash       => 'hash_00_VER_602de4d4f6467122ab48f809a88315d6',
         dt         => {
            hash       => 'hash_01_VER_27f41cb85350660e54e3a3e646d4665f',
            input      => 'Get Memcached Stats',
            MEMC_curr_connections => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_0725ee8c887b598a97b978e188527629'
            },
            MEMC_total_connections => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_5215c2bb84d484ca5a7f653e37bcf169'
            },
         },
         items => [
            {  item   => 'MEMC_curr_connections',
               color  => '06998F',
               task   => 'hash_09_VER_8dadd65774c0358bd90d5bb2eef8bf54',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_9ffdb7c60f4afa9fcc399217b17c695b',
                  'hash_10_VER_3f5698374b828282e20f6799662057fa',
                  'hash_10_VER_af6e31ddd27d7fdab46ae6b2858e40c8',
                  'hash_10_VER_5436bcdf227cc5c03942a3dcabb00a33'
               ],
            },
            {  item   => 'MEMC_total_connections',
               color  => '105B3D',
               task   => 'hash_09_VER_c3400edd93607fed4d38653030e1c94a',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_949cdc429a15b2f330ab070d09be9589',
                  'hash_10_VER_b8792a1edc9d760cd1bd45ae16f9831c',
                  'hash_10_VER_a3522a2edb8361e4f6d2b0b0416d654d',
                  'hash_10_VER_0384735cc5623d8172c55385425e56b9'
               ],
            },
         ],
      },
      {  name       => 'Memcached Requests',
         base_value => '1000',
         hash       => 'hash_00_VER_9e44a7b7d5ea1e917fdd5d7a37d46697',
         dt         => {
            hash       => 'hash_01_VER_0c8f26f3e3a38d4953955ee4556bd948',
            input      => 'Get Memcached Stats',
            MEMC_cmd_get => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_28953d4c95e4b887bd0f2a70aedb4f7e'
            },
            MEMC_cmd_set => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_50e0d9fdd8764e55727c5f74ad06f3ee'
            },
            MEMC_get_misses => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_89581f8238b3e80caad434c3a09d3a8d'
            },
         },
         items => [
            {  item   => 'MEMC_cmd_get',
               color  => 'F8BE7D',
               task   => 'hash_09_VER_81f4d7b835c2279a9d63def30da2a42e',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_33dcbcc262d634d0d5fe9e56a731ddcb',
                  'hash_10_VER_e33cc8ec124aea8ad0bbca864042bf65',
                  'hash_10_VER_6d52039a65770421301f495e08313a9f',
                  'hash_10_VER_8c243805b0f9c7a4e5ff9a26e745e9c1'
               ],
            },
            {  item   => 'MEMC_get_misses',
               color  => 'CC1306',
               task   => 'hash_09_VER_873cf87d8be3f2bcda1bbe990f0a4b93',
               type   => 'LINE2',
               hashes => [
                  'hash_10_VER_4c28a431ad229ea022798eae37867a98',
                  'hash_10_VER_31ef32b5f20cbea42fd446e495d6421a',
                  'hash_10_VER_01f7a79bd64b63430d0b3461f85f7ebd',
                  'hash_10_VER_d5f9222bad8f4d2af195426062736bb8'
               ],
            },
            {  item   => 'MEMC_cmd_set',
               color  => '3C5E53',
               task   => 'hash_09_VER_7b98b2396030f4e25305b9fb1611a39c',
               type   => 'AREA',
               cdef   => 'Negate',
               hashes => [
                  'hash_10_VER_68393007ae8e77fd7dfcce1e2a074cd9',
                  'hash_10_VER_35452e8a4832c5d773b7769a85fd610d',
                  'hash_10_VER_e1d3f750b8bf39ec14b9f5cf56151496',
                  'hash_10_VER_23e22e3512ab2b6ffb4dd34aa743c815'
               ],
            },
         ],
      },
      {  name       => 'Memcached Traffic',
         base_value => '1024',
         hash       => 'hash_00_VER_6f95e3c5df1887f6981fd753d4d2df26',
         dt         => {
            hash       => 'hash_01_VER_58a735642fc8886c54763c0d7daee893',
            input      => 'Get Memcached Stats',
            MEMC_bytes_read => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_9055e96b91e4aa2d84a110c8cff1d2ed'
            },
            MEMC_bytes_written => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_f5cb902cf58b3c4fbca7e85edd9d676e'
            },
         },
         items => [
            {  item   => 'MEMC_bytes_read',
               color  => 'A38A64',
               task   => 'hash_09_VER_59d42abe2881685b6420e27b1c98c062',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_fee12d190cbb0578da87474325121c10',
                  'hash_10_VER_eb80ce95c270a955985cf6fd9c3597a9',
                  'hash_10_VER_4c89ad0eea4023ce453f0db1e3b9d837',
                  'hash_10_VER_a35804599a1068b819c846be5a0b55e9'
               ],
            },
            {  item   => 'MEMC_bytes_written',
               color  => '183030',
               task   => 'hash_09_VER_6f55bb88d6f5c3ddc9face8ed725ddf7',
               type   => 'AREA',
               cdef   => 'Negate',
               hashes => [
                  'hash_10_VER_30b60e02c3530f47900e9e3280a68732',
                  'hash_10_VER_5a6f5e69283fb75417ebb8483d92f2a8',
                  'hash_10_VER_37ac441d436fec7759023c90d9710f32',
                  'hash_10_VER_bd8364ea38411ad0f3daa94e98876b57'
               ],
            },
         ],
      },
   ],
   inputs => {
      'Get Memcached Stats' => {
         type_id      => 1,
         hash         => 'hash_03_VER_de0c6857fe68c9cde6caaf3413594c28',
         input_string => '<path_php_binary> -q <path_cacti>/scripts/ss_get_by_ssh.php '
                       . '--host <hostname> --type memcached --items <items> '
                       . '--server <server>',
         inputs => [
            {  allow_nulls => '',
               hash        => 'hash_07_VER_8a62eca31127304468b3c39d54cd544f',
               name        => 'hostname'
            },
            {  allow_nulls => 'on',
               hash        => 'hash_07_VER_8a62eca31127394468b3c39d54cd544f',
               name        => 'server'
            },
            {  allow_nulls => 'on',
               hash        => 'hash_07_VER_8a62eca31127395468b3c39d54cd544f',
               name        => 'port2'
            },
         ],
         outputs => {
            MEMC_rusage_user       => 'hash_07_VER_dbaa5f4dbc8534f49f72fe8955e55927',
            MEMC_rusage_system     => 'hash_07_VER_f1d68237c38c5d0b03d42fd93e9f09c3',
            MEMC_curr_items        => 'hash_07_VER_7cb50cfde1f3c9498de0f49de1e774df',
            MEMC_total_items       => 'hash_07_VER_f2d5c7cc6c611f24fb9c98eee75835fe',
            MEMC_bytes             => 'hash_07_VER_aeb38d6f5cf1b1fa21a0993f7076204c',
            MEMC_curr_connections  => 'hash_07_VER_80f508a6bc8ac343010467e600c2da18',
            MEMC_total_connections => 'hash_07_VER_51b534412b815a484ccf15e55968ab60',
            MEMC_cmd_get           => 'hash_07_VER_b269f618aa06a984cd0168550b6b68c8',
            MEMC_cmd_set           => 'hash_07_VER_321173f4ea7768451485d6835d935131',
            MEMC_get_misses        => 'hash_07_VER_3e5cff45b2266318783480108113c39a',
            MEMC_evictions         => 'hash_07_VER_1f1388bf0497d39dbb2fa4add030db1b',
            MEMC_bytes_read        => 'hash_07_VER_9210faa03da3f15e1fe0e37fa9f0a8bb',
            MEMC_bytes_written     => 'hash_07_VER_2442551920abf4f05121043fe4cd51d7',
         },
      },
   },
};
