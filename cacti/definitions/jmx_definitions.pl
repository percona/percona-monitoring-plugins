# This is the template definition file.  To use it, see make-template.pl.  This
# one goes with the ss_get_by_ssh.php script.
#
# This program is copyright (c) 2010 LI Daobing. Feedback and improvements
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
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

# Autobuild: ss_get_by_ssh.php

{  name    => 'JMX Server',
   hash    => 'hash_02_VER_48c14a8d4a9f079ee691526cbf10c0a0',
   version => {
      version => '1.1.8',
      hash    => 'hash_06_VER_30ad6e39e56f911b3c93545c8d44c984',
   },
   checksum => 'hash_06_VER_9a101a62d4dc2ace6f7b022cf16010d1',
   graphs => [
      {  name       => 'JMX Heap Memory Usage',
         base_value => '1024',
         hash       => 'hash_00_VER_68e078ab874ea34fec4e42bbd7f300c6',
         dt         => {
            hash  => 'hash_01_VER_8790c041d8bd2412b6e77642050f2104',
            input => 'Heap Memory Usage',
            JMX_heap_memory_used => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_cdc9a9e4dae51dbfe5ec95d0f9445d27'
            },
            JMX_heap_memory_committed => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_36d3606b177b7c7c409a6c2917d40625'
            },
            JMX_heap_memory_max => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_2451b83739058d8c05a861c0c1d86a7a'
            },
         },
         items => [
            {  item   => 'JMX_heap_memory_max',
               color  => '4F7774',
               task   => 'hash_02_VER_24f6301c90cb2721de85e4481bcd08af',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_b476ae9f73a3d8e763a18bec392b447e',
                  'hash_10_VER_674a447d52ea894a7a68b71c88973d8b',
                  'hash_10_VER_5cea25a317bc39432842e706bccd952a',
                  'hash_10_VER_8958122127b149f02da28f4d4b7f62ba'
               ],
            },
            {  item   => 'JMX_heap_memory_committed',
               color  => 'FFDB87',
               task   => 'hash_02_VER_c3e7c60bd6bf464e92792ec335e801eb',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_1602288c955962065c9bf0ebaf90fb2c',
                  'hash_10_VER_b61a091d010f26edc3231821bfcc3136',
                  'hash_10_VER_273034f3285a46393758ff3c5a544cb7',
                  'hash_10_VER_4bb13c2d64d6810e91b54d50c2f68860'
               ],
            },
            {  item   => 'JMX_heap_memory_used',
               color  => '850707',
               task   => 'hash_02_VER_64ec5ed91e2661c3dfccddac9b321b10',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_07a06081159fcd776892c6cdfd7b2079',
                  'hash_10_VER_2dae09985e6740dcd4c24d3545bbbb44',
                  'hash_10_VER_020db1bfce101042be2541cb6d9d2a11',
                  'hash_10_VER_18504e3ab2caa2ec0729aa307ed331c6'
               ],
            },
         ],
      },
      {  name       => 'JMX Non-Heap Memory Usage',
         base_value => '1024',
         hash       => 'hash_00_VER_7994aab7e71d10d474fa0af729fe3f3a',
         dt         => {
            hash  => 'hash_01_VER_cceafeecdbfd3870b656ca90f363c6ca',
            input => 'Non-Heap Memory Usage',
            JMX_non_heap_memory_used => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_fc3fa2aa1288524d6e7510a83cc6b2f3'
            },
            JMX_non_heap_memory_committed => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_1e8980d9a0b58626f5f5a7e176492f10'
            },
            JMX_non_heap_memory_max => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_52895f8b3ba59a1b4c27782273ea45f9'
            },
         },
         items => [
            {  item   => 'JMX_non_heap_memory_max',
               color  => '4F7774',
               task   => 'hash_02_VER_ddbfedd1335e728a3734c6601644aa27',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_8b9a25afd5a8bb1227133d276395afe6',
                  'hash_10_VER_63353ecc77d4f97e0e23cf590fe37ce2',
                  'hash_10_VER_c4474365f795fe4279b7af775e6392aa',
                  'hash_10_VER_932b9cb12e491dfd507f30c2ffc4a57e'
               ],
            },
            {  item   => 'JMX_non_heap_memory_committed',
               color  => 'FFDB87',
               task   => 'hash_02_VER_f5665100f5736ca4e6734c363289c2f3',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_f97f72c65f7978e939e06e9c8a1366ad',
                  'hash_10_VER_8d63f3e67d75d63ada895931226f1614',
                  'hash_10_VER_4cde6558d06896fc6684b7efcbd2ce46',
                  'hash_10_VER_3088105383b953a2c763a3a1763122c5'
               ],
            },
            {  item   => 'JMX_non_heap_memory_used',
               color  => '850707',
               task   => 'hash_02_VER_35aae66d1e8c7f56d545c5fa118cb530',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_0fbcefa1de77e6660ad2eb49510af309',
                  'hash_10_VER_8fad23d61ea3f68f4debc83069d48b72',
                  'hash_10_VER_f7681fab6ed7cd47db13cbd8a3eab880',
                  'hash_10_VER_8623719613f60b18092a506c7c32cf1d'
               ],
            },
         ],
      },
      {  name       => 'JMX File Descriptor',
         base_value => '1000',
         hash       => 'hash_00_VER_58c8e5dacd51785c76ce4c8202648fc6',
         dt         => {
            hash  => 'hash_01_VER_22c04338d3e02d5d4fd0c34dc3e66708',
            input => 'File Descriptor',
            JMX_open_file_descriptors => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_3e67b36ea631297157c891d96175a4c4'
            },
            JMX_max_file_descriptors => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_4c272fb8d5bb17e6991d4ead9c17b369'
            },
         },
         items => [
            {  item   => 'JMX_max_file_descriptors',
               color  => '4F7774',
               task   => 'hash_02_VER_90e212ffb6aec7d09432f9517853faac',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_2efbe7d46c26fa73e2bf488852b3dc87',
                  'hash_10_VER_ff4425b7ef50b119c86f00e18595c14f',
                  'hash_10_VER_7708ba9771e5dced951654d557058206',
                  'hash_10_VER_1baf374810a6affd2284de35480a2275'
               ],
            },
            {  item   => 'JMX_open_file_descriptors',
               color  => '850707',
               task   => 'hash_02_VER_710fbdd16e9d25109119a355e346e2ab',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_d062ed5bd545a3148ebbf45cec5385c6',
                  'hash_10_VER_66429a79c2fe39e5243336a859d41028',
                  'hash_10_VER_c0d4b7adcb26686a80b32f8ab9d63e59',
                  'hash_10_VER_8482b1fb6955c84486cd498ad2f692d1'
               ],
            },
         ],
      },
      {  name       => 'JMX ThreadPool',
         base_value => '1000',
         hash       => 'hash_00_VER_8c2ec59bd22ecf2a530a21c6d4e918ca',
         dt         => {
            hash  => 'hash_01_VER_d6a840937346b3f3b5e33888ac842708',
            input => 'ThreadPool',
            JMX_max_threads => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_7bc29aa177ac5efa0bddeebb363669db'
            },
            JMX_current_thread_count => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_d4c21fa0fb69a169b6ce1a388a2a1553'
            },
            JMX_current_threads_busy => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_c14fbc3af70e0a61e17e42174b7ebe16'
            },
         },
         items => [
            {  item   => 'JMX_max_threads',
               color  => '4F7774',
               task   => 'hash_02_VER_0e83f70bd10ce46004cd90b2b950d943',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_c0a4b4f316075ea6be3bf7d806979987',
                  'hash_10_VER_3a2c9c7258e1e6bfe46f6b8d235a3222',
                  'hash_10_VER_9995590e807064aaea233d1d0ee1ad70',
                  'hash_10_VER_e7d58f42e04cb561270b5df8957a1558'
               ],
            },
            {  item   => 'JMX_current_thread_count',
               color  => 'FFDB87',
               task   => 'hash_02_VER_3be2d93854f4079a37f2cd9221b010df',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_36a4ddfcaf4b8b857d495d396f190086',
                  'hash_10_VER_bd5a1e016b70362a9b9cc43d71b92f84',
                  'hash_10_VER_e41ee5172d438012858b13a9dfba6983',
                  'hash_10_VER_683e1832280fd659b5f580087bafb07d'
               ],
            },
            {  item   => 'JMX_current_threads_busy',
               color  => '850707',
               task   => 'hash_02_VER_049abbd379abec6dfedb6c108c5e370c',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_79a2315acac9403c010277a169497ff7',
                  'hash_10_VER_95af64bfd807a2b6e1d2eb3e7f126216',
                  'hash_10_VER_c3f4daa800b92532f43899214de65e1b',
                  'hash_10_VER_01de3f6927116fd2dbbf0a8fde685508'
               ],
            },
         ],
      },
   ],
   inputs => {
      'Heap Memory Usage' => {
         type_id => 1,
         hash    => 'hash_03_VER_beb2f81a856e5ba03b0f08adc39160bc',
         input_string =>
            '<path_php_binary> -q <path_cacti>/scripts/ss_get_by_ssh.php '
            . '--host <hostname> --type jmx --items <items>',
         inputs => [
            {  allow_nulls => '',
               hash        => 'hash_07_VER_73b15f9cff6981090931ebf57661efdd',
               name        => 'hostname'
            },
         ],
         outputs => {
            JMX_heap_memory_used =>
               'hash_07_VER_d3ff23086e6d53adf935de14b04f32bc',
            JMX_heap_memory_committed =>
               'hash_07_VER_1c10f8ce987251079bba3a545d706892',
            JMX_heap_memory_max =>
               'hash_07_VER_594d7a7da75cc27f35168c02cc62f3e2',
         },
      },
      'Non-Heap Memory Usage' => {
         type_id => 1,
         hash    => 'hash_03_VER_2f143b3f470112c4199aae55a931d49c',
         input_string =>
            '<path_php_binary> -q <path_cacti>/scripts/ss_get_by_ssh.php '
            . '--host <hostname> --type jmx --items <items>',
         inputs => [
            {  allow_nulls => '',
               hash        => 'hash_07_VER_b70b0da69dde9e1d9937085c08305c1d',
               name        => 'hostname'
            },
         ],
         outputs => {
            JMX_non_heap_memory_used =>
               'hash_07_VER_e7572a60d80d702f3f20432cfc421f9e',
            JMX_non_heap_memory_committed =>
               'hash_07_VER_a18d9e71f8b894c8a34efcb4e0f7e5d5',
            JMX_non_heap_memory_max =>
               'hash_07_VER_d45e0587edc75f776db6b32720ada6fb',
         },
      },
      'File Descriptor' => {
         type_id => 1,
         hash    => 'hash_03_VER_d915cc3b266cdebaa26a30c25c4c0b84',
         input_string =>
            '<path_php_binary> -q <path_cacti>/scripts/ss_get_by_ssh.php '
            . '--host <hostname> --type jmx --items <items>',
         inputs => [
            {  allow_nulls => '',
               hash        => 'hash_07_VER_0e0ae59f56b615ae2c2708952ea5dd98',
               name        => 'hostname'
            },
         ],
         outputs => {
            JMX_open_file_descriptors =>
               'hash_07_VER_c1c38e5ec6cb89b5cc3aa3d48f8e49b7',
            JMX_max_file_descriptors =>
               'hash_07_VER_d8f96bdd0f3950c50ff9776789274c81',
         },
      },
      'ThreadPool' => {
         type_id => 1,
         hash    => 'hash_03_VER_81b20f10ae00cb284a49291ce83b3b58',
         input_string =>
            '<path_php_binary> -q <path_cacti>/scripts/ss_get_by_ssh.php '
            . '--host <hostname> --type jmx --items <items>',
         inputs => [
            {  allow_nulls => '',
               hash        => 'hash_07_VER_b04a547db314499fdc16534467196754',
               name        => 'hostname'
            },
            {  allow_nulls => '',
               hash        => 'hash_07_VER_50ae6f7bdd6bc35a4b9206dd23921783',
               name        => 'threadpool',
               override    => 1,
            },
         ],
         outputs => {
            JMX_current_threads_busy =>
               'hash_07_VER_7bed075223c77eb1c767b8fdd8ae6c7a',
            JMX_current_thread_count =>
               'hash_07_VER_31f702762bd160ac48a9b4728e6c49ac',
            JMX_max_threads =>
               'hash_07_VER_b3bb6cf017b4cf7b6c2471c0c4750e2f',
         },
      },
   }
};
