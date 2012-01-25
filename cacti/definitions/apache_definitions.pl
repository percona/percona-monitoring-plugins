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
   name   => 'Apache Server',
   hash   => 'hash_02_VER_f74237cf7fb53fc002b0215117856be3',
   version => {
      version => '1.1.8',
      hash    => 'hash_06_VER_ac10705723a27cae224aa85dc7e38cd0',
   },
   checksum    => 'hash_06_VER_f6212a68c24f9ef744bb58b4a45345b4',
   graphs => [
      {  name       => 'Apache Requests',
         base_value => '1000',
         hash       => 'hash_00_VER_7dd582146162f1d9c61bc52bec83d2f8',
         dt         => {
            hash       => 'hash_01_VER_b126c9d16618d1cd99dc2d4eb27703c3',
            input      => 'Get Apache Stats',
            Requests => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_9ab18f7a0cdc99e5a704af15dd0908cc'
            },
         },
         items => [
            {  item   => 'Requests',
               color  => '803405',
               task   => 'hash_09_VER_320385532fb7c191c962fdb9a1414479',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_c98bdbb53284805a8938d434041b9781',
                  'hash_10_VER_eb7b204a8beeae2f41193d4eecdbc54c',
                  'hash_10_VER_58d5ab7cbd19f1650bb08815a2d752ae',
                  'hash_10_VER_268eea107e7cb8c3b936a21bb0ce9236'
               ],
            },
         ],
      },
      {  name       => 'Apache Bytes',
         base_value => '1024',
         hash       => 'hash_00_VER_35fc5db4eda3fcb831ee4e66f2d758ed',
         dt         => {
            hash       => 'hash_01_VER_fcd7e3d3cfb9ff2086af3573da16c4bb',
            input      => 'Get Apache Stats',
            Bytes_sent => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_4f32e43daef6ae3e1423c80578c06ce1'
            },
         },
         items => [
            {  item   => 'Bytes_sent',
               color  => '5D868C',
               task   => 'hash_09_VER_f21ce020e6fab43d47cecf785340ab30',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_94e067cb1e0cff9995cbdeec92a42932',
                  'hash_10_VER_1a5ccbed57de33186c1a003dd0a0f28e',
                  'hash_10_VER_37f077e6b4a61aea6ff0cc5dc6ec7db7',
                  'hash_10_VER_cc030ec16b2a03aebfee1d83a765d645'
               ],
            },
         ],
      },
      {  name       => 'Apache CPU Load',
         base_value => '1000',
         hash       => 'hash_00_VER_19dbe918854a4e549e48b172ad8b51b2',
         dt         => {
            hash       => 'hash_01_VER_a6ae963635e330621d67f3c1d680efb0',
            input      => 'Get Apache Stats',
            CPU_Load => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_4192deafb5ae488a21ae6cf33999fe82'
            },
         },
         items => [
            {  item   => 'CPU_Load',
               color  => '700004',
               task   => 'hash_09_VER_a20147e0e31048d256b063831641b2dc',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_d91eca467ac3b023964efb712d0d823a',
                  'hash_10_VER_2f6a43e23d7160e0a5b549e43fe0a4e9',
                  'hash_10_VER_dcd286268735b635bcab92c37704f759',
                  'hash_10_VER_42fd6384bc247e64271f8a6b3baee61c'
               ],
            },
            {  item   => 'CPU_Load',
               color  => '000000',
               task   => 'hash_09_VER_a5ab7839ad06a8b08c10e2eac17f2d46',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_ad3dbea90e53675c6a715fa70d80b425',
               ],
            },
         ],
      },
      {  name       => 'Apache Workers',
         base_value => '1000',
         hash       => 'hash_00_VER_9b65e677a20f742582b9985a208550b6',
         dt         => {
            hash       => 'hash_01_VER_6e1cc2e3365f385cf934e32b8a204138',
            input      => 'Get Apache Stats',
            Idle_workers => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_6aa30e77d556e4f27b78e86d75d240ce'
            },
            Busy_workers => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_51669662e5a65025cc33a6963f7d13a5'
            },
         },
         items => [
            {  item   => 'Idle_workers',
               color  => 'EEB78E',
               task   => 'hash_09_VER_c607a8fc1798542b45d9db03821f5416',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_79922e1752125c15992283338f02e41c',
                  'hash_10_VER_dc6d82130210fea4e442f4d449005bf0',
                  'hash_10_VER_999a3c9ca0b6052df9f684eb86349833',
                  'hash_10_VER_7af8dc449c88a166aae40048350281ff'
               ],
            },
            {  item   => 'Busy_workers',
               color  => '47748B',
               task   => 'hash_09_VER_b41cfa6817023350822546893ce286bb',
               type   => 'STACK',
               hashes => [
                  'hash_10_VER_03bb3a68dcddd53c5a52d9d7fea80557',
                  'hash_10_VER_fc4196b492d51221a20559eaf897d0cb',
                  'hash_10_VER_5a9805bf1435610ccb227023d1f624b4',
                  'hash_10_VER_8edc7aa7ab4c0fbdc8e080bdcb2b33e2'
               ],
            },
         ],
      },
      {  name       => 'Apache Scoreboard',
         base_value => '1000',
         hash       => 'hash_00_VER_6a66771502a2ef127619d17a6510eaf3',
         dt         => {
            hash       => 'hash_01_VER_5dc334b912c46ab4c6d9af8ba8a62b18',
            input      => 'Get Apache Stats',
            Waiting_for_connection => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_37696315ea6d63f72ff4369f8ce9d28f'
            },
            Starting_up => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_be57013790b1b1f990cd854e915ed011'
            },
            Reading_request => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_55b42d77e63ae182af5a1accbcb446ba'
            },
            Sending_reply => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_7d7d154d9836e010680e178ad01f05e7'
            },
            Keepalive => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_e5fbb1607fe2e9a06be2c8c6a03655f4'
            },
            DNS_lookup => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_1ca4724e477d5e6a01c9a2e4158715a1'
            },
            Closing_connection => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_db20e41c1485c040e6458d82fd2aa1ee'
            },
            Logging => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_d1d955999673b9ee52fd04958ce4f69f'
            },
            Gracefully_finishing => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_970a7ed0d0685727508fa9cc791a5eec'
            },
            Idle_cleanup => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_5d906b480bed5be85ddf27b46feb5ba9'
            },
            Open_slot => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_a8a002b8651f6ec96d58db5c6534c959'
            },
         },
         items => [
            {  item   => 'Waiting_for_connection',
               color  => 'DE0056',
               task   => 'hash_09_VER_a80215bf3ff228c0b6c568779f06b85c',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_2f5b9e2564725c0fb1b922b4bd97c201',
                  'hash_10_VER_a7238d0616a2ba162566702834a2347a',
                  'hash_10_VER_513fd42fc5895a7dc86e815d908a06bf',
                  'hash_10_VER_0db1a81e909798e42edd1ed9805c2a30'
               ],
            },
            {  item   => 'Starting_up',
               color  => '784890',
               task   => 'hash_09_VER_6a181d6121b20efdf004a70a8ef47f1c',
               type   => 'STACK',
               hashes => [
                  'hash_10_VER_feec879010e407f91aa272ced883c4e2',
                  'hash_10_VER_f43ceb7975cedae059a11be3221b5fcc',
                  'hash_10_VER_b518386180a8f75c6871413f80be2175',
                  'hash_10_VER_b67fbc3ae53d866e9dca38c3983aba7f'
               ],
            },
            {  item   => 'Reading_request',
               color  => 'D1642E',
               task   => 'hash_09_VER_838a522638302fbdfca68eb4d8e8e755',
               type   => 'STACK',
               hashes => [
                  'hash_10_VER_b4c6d061c33b77bdacdc2eb6d9d72734',
                  'hash_10_VER_730a9ae5490b1abe140abbfca6318df7',
                  'hash_10_VER_23ab4fa861de371911f31fde6f4c650c',
                  'hash_10_VER_dee2bf79588d24ac22c3960e2a1adfcc'
               ],
            },
            {  item   => 'Sending_reply',
               color  => '487860',
               task   => 'hash_09_VER_126a087f7bcae3056b701b0493e0714a',
               type   => 'STACK',
               hashes => [
                  'hash_10_VER_7f2572aa90ec46c979e2b89cdfe6a598',
                  'hash_10_VER_53d8d8d3b22a98d1365a09f526eb3574',
                  'hash_10_VER_8f4ab85a11d053e4e3ccebfdbbb40c07',
                  'hash_10_VER_ecf6b2f8603ae2e75e4a9053d0300f43'
               ],
            },
            {  item   => 'Keepalive',
               color  => '907890',
               task   => 'hash_09_VER_4a39512d24f2023398eedff0dcd399a7',
               type   => 'STACK',
               hashes => [
                  'hash_10_VER_396b8bcfd67623c10b9485ccb698288c',
                  'hash_10_VER_6f2683a8d3808dfc064ce7720585558b',
                  'hash_10_VER_7cc79c5569657285a10c5aab2930235b',
                  'hash_10_VER_51e655f37c25b6015aaf10eafa5749f1'
               ],
            },
            {  item   => 'DNS_lookup',
               color  => 'DE0056',
               task   => 'hash_09_VER_f99da81cd9ba660c901cdcdbdcbb6bba',
               type   => 'STACK',
               hashes => [
                  'hash_10_VER_552fe0cfcd2bd7a7ca0a7104293eb1b7',
                  'hash_10_VER_950147840d123dd58eb753be80e9634c',
                  'hash_10_VER_d8bfcf3d0a8cb176432eeb52ee6bcb53',
                  'hash_10_VER_41b645619a517cc7ba9b8cd8f7edace1'
               ],
            },
            {  item   => 'Closing_connection',
               color  => '1693A7',
               task   => 'hash_09_VER_cf8485ee4bb76ed6c8538c77abd7b310',
               type   => 'STACK',
               hashes => [
                  'hash_10_VER_44315f16adcfd7e3882f60e92f332dda',
                  'hash_10_VER_0583112cb00ae94c17d6fe0d96bb1ab4',
                  'hash_10_VER_0a877cf8512ef1b9d2813f0774db0ca3',
                  'hash_10_VER_5a44212b067eb73c8170ff88b1b1c829'
               ],
            },
            {  item   => 'Logging',
               color  => 'FF7D00',
               task   => 'hash_09_VER_aac162da0dc535a0ea28291194658b85',
               type   => 'STACK',
               hashes => [
                  'hash_10_VER_9ae920a46f532f0f4a49dbaca7e731c0',
                  'hash_10_VER_e6fbbc3f9b85f1ff8f778e46ab0b1e41',
                  'hash_10_VER_ac2161413f7ee6920d3786c8eb1fc1bc',
                  'hash_10_VER_14616b47b80629a31cf649885a7523a0'
               ],
            },
            {  item   => 'Gracefully_finishing',
               color  => 'B83A04',
               task   => 'hash_09_VER_6626c31745e227ee7799add9014e86a1',
               type   => 'STACK',
               hashes => [
                  'hash_10_VER_ac488b16d39e0bbb7b9e19f989177f06',
                  'hash_10_VER_8a625639d2f5d9301f6b6810e9e68dd2',
                  'hash_10_VER_f47ebd6fa1afdead7b2a3cbb4770fa25',
                  'hash_10_VER_594b24cc59ab5381ad72007df314e4ef'
               ],
            },
            {  item   => 'Idle_cleanup',
               color  => '540202',
               task   => 'hash_09_VER_fc03d4316c43ccbd3d9ecf0a7279a850',
               type   => 'STACK',
               hashes => [
                  'hash_10_VER_bbfb4404823a3a1e1d1f9eabd25455c4',
                  'hash_10_VER_9e222bde9a5af3ffd4bd5aaa13a4676c',
                  'hash_10_VER_d22744845006091d5db17198591ba3e9',
                  'hash_10_VER_e31c7864d29b10c35d3c0c7640797caf'
               ],
            },
            {  item   => 'Open_slot',
               color  => '6E645A',
               task   => 'hash_09_VER_1555fa38c0124d776cc8e4810db0f3ec',
               type   => 'STACK',
               hashes => [
                  'hash_10_VER_5bc2da8fc57817b82413247f0c029607',
                  'hash_10_VER_4e9f134418a7f4e2b36e033d063ee585',
                  'hash_10_VER_1aa91553763234161676d15c6c9c0760',
                  'hash_10_VER_b189156869d85a4ebe01f805d5ea5b37'
               ],
            },
         ],
      },
   ],
   inputs => {
      'Get Apache Stats' => {
         type_id      => 1,
         hash         => 'hash_03_VER_6d2a648161b8c79a67821046280dde43',
         input_string => '<path_php_binary> -q <path_cacti>/scripts/ss_get_by_ssh.php '
                       . '--host <hostname> --type apache --items <items>',
         inputs => [
            {  allow_nulls => '',
               hash        => 'hash_07_VER_9ede3b32324e1978bc938bbbcf99c7da',
               name        => 'hostname'
            },
         ],
         outputs => {
            Requests               => 'hash_07_VER_cff73d78a6870918b25fec9af9ba55d3',
            Bytes_sent             => 'hash_07_VER_9430882fbafec2abb63390553b47f6d8',
            CPU_Load               => 'hash_07_VER_254558f5aa21ff73ebe348612cca429e',
            Idle_workers           => 'hash_07_VER_8f45bda7f92b305ce53485bf349c74a2',
            Busy_workers           => 'hash_07_VER_37cae992ca15d54db89e5fbb4d55b5e3',
            Waiting_for_connection => 'hash_07_VER_b3882f9fad342ef4437389afe5a48255',
            Starting_up            => 'hash_07_VER_bca2a7f9e02eb1e0119b9901620213e0',
            Reading_request        => 'hash_07_VER_f55a3ab774898f05be545865ab08dc3d',
            Sending_reply          => 'hash_07_VER_ae55e6043b1e658090c3992b429ab772',
            Keepalive              => 'hash_07_VER_95432bea896bfe38ae8b02bfda3345ae',
            DNS_lookup             => 'hash_07_VER_d7708a0ebcdbd2c2d50e795c785607e4',
            Closing_connection     => 'hash_07_VER_65d90ec19f533d6dfd59b7e59a59a961',
            Logging                => 'hash_07_VER_1c9ae3f9d3f450274caf42acda243314',
            Gracefully_finishing   => 'hash_07_VER_e9ea07ba78ae485021e48f3d09d2fe51',
            Idle_cleanup           => 'hash_07_VER_cd3456d0c13abf6bd90ca951466508d6',
            Open_slot              => 'hash_07_VER_11e86aca3dd09262052d32571502349f',
         },
      },
   },
};
