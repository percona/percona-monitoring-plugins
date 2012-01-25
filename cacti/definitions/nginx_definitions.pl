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
   name   => 'Nginx Server',
   hash   => 'hash_02_VER_be7718e794244e2cf363bbb64c0cb705',
   version => {
      version => '1.1.8',
      hash    => 'hash_06_VER_ac10705723a27cae224aa85dc7e38cdd',
   },
   checksum => 'hash_06_VER_c934708128c9378f53521f0842b6ea79',
   graphs => [
      {  name       => 'Nginx Requests',
         base_value => '1000',
         hash       => 'hash_00_VER_89b799bc81c33304ded07c8363fb8bdd',
         dt         => {
            hash       => 'hash_01_VER_200c3b9af34f3c6c96e68c8e561660bd',
            input      => 'Get Nginx Stats',
            NGINX_server_requests => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_e4b05773e000997ad54f63f312a97e08'
            },
         },
         items => [
            {  item   => 'NGINX_server_requests',
               color  => '803405',
               task   => 'hash_09_VER_63ad225064673ed776cf6226a9032344',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_f37177e39032acedc883e5565b189aaf',
                  'hash_10_VER_a9612d5624639d3c56d339d4883cbb27',
                  'hash_10_VER_a6b47c90bc60a0f7261c20fd3fcb51cd',
                  'hash_10_VER_a630aaced81152053b1206007c6318d9'
               ],
            },
         ],
      },
      {  name       => 'Nginx Accepts/Handled',
         base_value => '1000',
         hash       => 'hash_00_VER_78acb7b46bede0b4b8999faf194bdfdf',
         dt         => {
            hash       => 'hash_01_VER_ada5ac735d555cb01993d27575398b95',
            input      => 'Get Nginx Stats',
            NGINX_server_accepts => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_49fb074c37172a9be39e78187fa42957'
            },
            NGINX_server_handled => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_a4cc1ed0cd85151e74b1b4c4fc5c76a9'
            },
         },
         items => [
            {  item   => 'NGINX_server_accepts',
               color  => '5D868C',
               task   => 'hash_09_VER_a6dc14e10aead1f201cd21aaac3640f5',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_8284ff82b553b4baa8ec2e0e42ae267f',
                  'hash_10_VER_6626a39dac1c78e017cf93259a27f648',
                  'hash_10_VER_4b551cd2ed6015bd63efb37c56926f66',
                  'hash_10_VER_f76f4f712dd8da8bcc50aebcad3f7bc5'
               ],
            },
            {  item   => 'NGINX_server_handled',
               color  => '700004',
               task   => 'hash_09_VER_fcb4a4e8e24e75811e295e121dae29c1',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_6efd6ba48830a54dd907554da25921ca',
                  'hash_10_VER_64511bb1c2a20ce501eaedbf5d063069',
                  'hash_10_VER_a29f8e13b5cb29aa9427822798e0df4f',
                  'hash_10_VER_c8e7c9f495eb550ba2f8e80c05907a19'
               ],
            },
         ],
      },
      {  name       => 'Nginx Scoreboard',
         base_value => '1000',
         hash       => 'hash_00_VER_aaf3d5e054c9f0525790c9367e01033a',
         dt         => {
            hash       => 'hash_01_VER_ed48eeb6c1773c1adbf204520e704f71',
            input      => 'Get Nginx Stats',
            NGINX_active_connections => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_047e1a844b116f80e59d076b7c8ef0b1'
            },
            NGINX_reading => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_097e37232bc70fc54dd4decad6f6b864'
            },
            NGINX_writing => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_10b57cfb408f8ec6972a1011acfdee88'
            },
            NGINX_waiting => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_0e1f7f4ba7fa7a9996dc8f7ed521c9da'
            },
         },
         items => [
            {  item   => 'NGINX_reading',
               color  => 'D1642E',
               task   => 'hash_09_VER_c3d771fa9229c2023395dd5551909486',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_2a22a67a08b1bc599ffc9ce4d0e372f8',
                  'hash_10_VER_a4049c753fce6e14ee0672ccb12c5a21',
                  'hash_10_VER_bd0360323b082e0e04cdf7b4d39c23c2',
                  'hash_10_VER_6a762cf6c56ed9d14a80bf790f8502f4'
               ],
            },
            {  item   => 'NGINX_writing',
               color  => '850707',
               task   => 'hash_09_VER_9cd249d937d972814d8e38a66d462dc4',
               type   => 'STACK',
               hashes => [
                  'hash_10_VER_295ffd74de08d42bee44f0ae1ca9a9b2',
                  'hash_10_VER_708abdb46a2c777a05af9fa455664e91',
                  'hash_10_VER_f89921012d04dae646d6b49792e76ab5',
                  'hash_10_VER_39770e6de29f152d6cca56cb4461f78b'
               ],
            },
            {  item   => 'NGINX_waiting',
               color  => '487860',
               task   => 'hash_09_VER_3000c5bbdda2aeb2117d658672cbb5e1',
               type   => 'STACK',
               hashes => [
                  'hash_10_VER_ab0dd198d98259206565a6e01b5e8e5b',
                  'hash_10_VER_63758637862d357eac6693934683f387',
                  'hash_10_VER_3911d8dedb45fed6be5ea560968e54fd',
                  'hash_10_VER_89fdfe0cd6a0b2e6d6f5084250e8611e'
               ],
            },
            {  item   => 'NGINX_active_connections',
               color  => '000000',
               task   => 'hash_09_VER_9e921f6da9362add3e9b7c5798370163',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_4c902a673ed890465e362285d0ab6387',
                  'hash_10_VER_7d748a71aeea78d297cdf2d86497398c',
                  'hash_10_VER_1fee53f6750ed04b345680fb310353ca',
                  'hash_10_VER_c25e457997ef75d3187bb0a98d5b9201'
               ],
            },
         ],
      },
   ],
   inputs => {
      'Get Nginx Stats' => {
         type_id      => 1,
         hash         => 'hash_03_VER_686afc01e6df060bab64e885af593ffa',
         input_string => '<path_php_binary> -q <path_cacti>/scripts/ss_get_by_ssh.php '
                       . '--host <hostname> --type nginx --items <items> '
                       . '--server <server> --url <url> --http-user <http-user> '
                       . '--http-password <password>'
                       ,
         inputs => [
            {  allow_nulls => '',
               hash        => 'hash_07_VER_66ea73b103e3bb7e6793d22b14cd9bfd',
               name        => 'hostname'
            },
            {  allow_nulls => 'on',
               hash        => 'hash_07_VER_dd54f81d90b9734d59dcc8bb8af02701',
               name        => 'server'
            },
            {  allow_nulls => 'on',
               hash        => 'hash_07_VER_8197c00079b1af4c3430899375c509d3',
               name        => 'url'
            },
            {  allow_nulls => 'on',
               hash        => 'hash_07_VER_f9efa99759d943edacf3a2bbbfb61a4e',
               name        => 'http-user'
            },
            {  allow_nulls => 'on',
               hash        => 'hash_07_VER_4806787d655ef66379c425d14ce00465',
               name        => 'http-password'
            },
         ],
         outputs => {
            NGINX_active_connections => 'hash_07_VER_a9c1f21665497ec628a36e92c70c1fb4',
            NGINX_server_accepts     => 'hash_07_VER_9b3ce4bef308f4e297512075cc5493be',
            NGINX_server_handled     => 'hash_07_VER_f85507377f268d5c20675799d6336cae',
            NGINX_server_requests    => 'hash_07_VER_bcc65f926a0add4628f8b4640e67026a',
            NGINX_reading            => 'hash_07_VER_e799bddc91a433bf14bf2c59d92da425',
            NGINX_writing            => 'hash_07_VER_60d5b3f136757ab015262aaf8c148762',
            NGINX_waiting            => 'hash_07_VER_0146375a2c06277f36390ebb49877c73',
         },
      },
   },
};
