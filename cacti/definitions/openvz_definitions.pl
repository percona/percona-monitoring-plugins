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
   name   => 'OpenVZ Server',
   hash   => 'hash_02_VER_c17960b3ddc6b00eaacdbcee1f0e4c50',
   version => {
      version => '1.1.8',
      hash    => 'hash_06_VER_8583b57ebeb95898fca2dbe4bbf74f11',
   },
   checksum => 'hash_06_VER_85395be08eb3e8ccc5efe03485626129',
   graphs => [
      {  name       => 'OpenVZ Kernel Memory',
         base_value => '1024',
         hash       => 'hash_00_VER_5556eca4871dbe9fb8ea03aaee4e01a4',
         dt         => {
            hash       => 'hash_01_VER_f75007d255a5c0ddd97c7e2c265ffa63',
            input      => 'Get OpenVZ Stats',
            OPVZ_kmemsize_held => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_74a782cc330c3149ce85d8f50cb0108c'
            },
            OPVZ_kmemsize_failcnt => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_af4f2d2aee35cae431eafa9ee350d1f0'
            },
         },
         items => [
            {  item   => 'OPVZ_kmemsize_held',
               color  => 'FF3838',
               task   => 'hash_09_VER_0b74ae93d2f08e7296ea2056da1c33e3',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_95c4e12be44baaff0622df3c68fa24f9',
                  'hash_10_VER_da4e46462c634ea4656d017061ae4dba',
                  'hash_10_VER_c95e7b32d5dcbfcf724f310f2b82c9bf',
                  'hash_10_VER_7b2989fcd68890bd345307797c89af08'
               ],
            },
            {  item   => 'OPVZ_kmemsize_failcnt',
               color  => 'FF0000',
               task   => 'hash_09_VER_8ace83aee588d361d30a6442f35c64b3',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_dbfd8c2b528a451ef7544ea6b8d30e0d',
                  'hash_10_VER_7f75d6bdd5fd16fb4d9f3567cf4eb556',
                  'hash_10_VER_a675414b27c8b95eccc51ccf02487099',
                  'hash_10_VER_6db433179bd9be2668b8b5f79a8bd3d0'
               ],
            },
         ],
      },
      {  name       => 'OpenVZ Pages',
         base_value => '1024',
         hash       => 'hash_00_VER_3dafa871cd83b1dea26b242ee49f4cfb',
         dt         => {
            hash       => 'hash_01_VER_c97bbf6323c88b3f6df0af1707048838',
            input      => 'Get OpenVZ Stats',
            OPVZ_lockedpages_held => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_390b8c193c4b4e0568de3cabf688f219'
            },
            OPVZ_lockedpages_failcnt => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_59dff0d99037b5d7ca13137c82b0d0c0'
            },
            OPVZ_privvmpages_held => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_de5d0c7b7a987ca9fa9c3daf44b77876'
            },
            OPVZ_privvmpages_failcnt => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_5aa8aca071f4fa6f48a277defafe9388'
            },
            OPVZ_shmpages_held => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_5edccab4fc868849e146e824c9f8a325'
            },
            OPVZ_shmpages_failcnt => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_b3f5ca1cee1d3a3c99dc751c336c3166'
            },
            OPVZ_physpages_held => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_ee52daf8b9e2467b5d6932a70513d612'
            },
            OPVZ_physpages_failcnt => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_185b65ca00474b8e590a4224cbd40a49'
            },
            OPVZ_vmguarpages_held => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_2e01a98adcd9d8d167a58a05826a1a2a'
            },
            OPVZ_vmguarpages_failcnt => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_575162b41a794deff9584695c419ac12'
            },
            OPVZ_oomguarpages_held => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_514e47530702eaad87f43950cf3e8e3d'
            },
            OPVZ_oomguarpages_failcnt => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_1f3456ba4296abe6981456f5c5a0214f'
            },
         },
         items => [
            {  item   => 'OPVZ_lockedpages_held',
               color  => '11766D',
               task   => 'hash_09_VER_b8308f555293df1a2bc7d3beac3d3a18',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_1887eeddb63ac22feb7061f3eea96095',
                  'hash_10_VER_7fb4b76ae1bc775e5b8e431851f0afb3',
                  'hash_10_VER_f44f0cc8e183b39b6cf14048b6cfca18',
                  'hash_10_VER_c048a428c84bdc39f8d376df817bce27'
               ],
            },
            {  item   => 'OPVZ_lockedpages_failcnt',
               color  => 'FF0000',
               task   => 'hash_09_VER_b6ba25568bb21d3d818e3af9ac839edf',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_048cfde25ee7f0fb2ec730760995701e',
                  'hash_10_VER_dad59a4bee7c6f2bddd23c083c86a981',
                  'hash_10_VER_845f75ad8ea62e18c6b2e94788e23f04',
                  'hash_10_VER_5845e8fcde03bbf0723346d45343db51'
               ],
            },
            {  item   => 'OPVZ_vmguarpages_held',
               color  => 'C9937F',
               task   => 'hash_09_VER_eab9862a05892a0ccecd05b3352af19e',
               type   => 'STACK',
               hashes => [
                  'hash_10_VER_bd9362254566f69077a867e2b42f30c5',
                  'hash_10_VER_166e44fefce7c6c0a7e0bda2e96efc6a',
                  'hash_10_VER_2e2e6cd9e90eec5b005404c8a587b770',
                  'hash_10_VER_15110622e61d56dd1c63920a439cb06b'
               ],
            },
            {  item   => 'OPVZ_vmguarpages_failcnt',
               color  => 'FF0000',
               task   => 'hash_09_VER_b6a5b40771cc04d81af48de4a0e81282',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_b4b1eec2874179c0b763ae6555b0d974',
                  'hash_10_VER_2f2251be18e3fbb37da374a3b9b90764',
                  'hash_10_VER_f7a0d42c17846e5aa0151617e6b3c1d9',
                  'hash_10_VER_3a2d01725d89e0e368f4d1504d9b6cfb'
               ],
            },
            {  item   => 'OPVZ_privvmpages_held',
               color  => '410936',
               task   => 'hash_09_VER_0ebb655115b7b049c462582b90caf7f6',
               type   => 'STACK',
               hashes => [
                  'hash_10_VER_4f43d7a815b4d3dad3e6258caafa3951',
                  'hash_10_VER_5f5b585f67ca9f0e44a4be37ee45a436',
                  'hash_10_VER_3d34b80c4183227178c03d5c9d07aaec',
                  'hash_10_VER_e63298e4c0838a2551398ac009a67252'
               ],
            },
            {  item   => 'OPVZ_privvmpages_failcnt',
               color  => 'FF0000',
               task   => 'hash_09_VER_e4f6ab34d70ad156fd33710c26a168c1',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_584c2606cf317ef273c764ac10f756c3',
                  'hash_10_VER_b6ad36ec94f56992d771f06de316f22e',
                  'hash_10_VER_211ecfe163dc950e315df34b8177c065',
                  'hash_10_VER_c447ff235df1dc3a13e51fb69cb5de52'
               ],
            },
            {  item   => 'OPVZ_oomguarpages_held',
               color  => 'E9D18A',
               task   => 'hash_09_VER_8f8ea375b7e3562fc498e76272f57338',
               type   => 'STACK',
               hashes => [
                  'hash_10_VER_287462a46503ed95822b4991b112ee29',
                  'hash_10_VER_bd55927a35373af3cf06132d86ef6317',
                  'hash_10_VER_9dc190f4a60ff08f78f2ad12669b0250',
                  'hash_10_VER_560bffb47536100e9694f0b3b387ea81'
               ],
            },
            {  item   => 'OPVZ_oomguarpages_failcnt',
               color  => 'FF0000',
               task   => 'hash_09_VER_c9da162efe5966abf6d1943dd45c6476',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_a5e35d171da825a7662013ff5b178d72',
                  'hash_10_VER_ef78192de81cec2f0a88c5a9f2505895',
                  'hash_10_VER_ac5dd335d6ca6705080eac5ac6a6e4e0',
                  'hash_10_VER_697c21c593bcbc372e625d9aa337d9aa'
               ],
            },
            {  item   => 'OPVZ_shmpages_held',
               color  => 'A40B54',
               task   => 'hash_09_VER_3d0063f75e8be7a3b3fefb5a03ee84e4',
               type   => 'STACK',
               hashes => [
                  'hash_10_VER_0c25e0f0673db1833559e9ca90c0bc01',
                  'hash_10_VER_ed63e97942ce96e615ec5b7a6eb43fff',
                  'hash_10_VER_ab8ab11a97c9304d38c0a996a5c9ef8b',
                  'hash_10_VER_ea78c1433eda9460215481ce84abd20a'
               ],
            },
            {  item   => 'OPVZ_shmpages_failcnt',
               color  => 'FF0000',
               task   => 'hash_09_VER_8414305d52e9e5259f5f9ed38f91b402',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_50fbced6d56ed9deef837013bac2551e',
                  'hash_10_VER_d65ee8a586d89f840be6e604f6caab11',
                  'hash_10_VER_c29d8a6816ec3a328c9ef293c443a4ed',
                  'hash_10_VER_2e92d3cf5305d3f795a1e54526febb39'
               ],
            },
            {  item   => 'OPVZ_physpages_held',
               color  => 'F0B300',
               task   => 'hash_09_VER_5f4391f15035d900516343556ae2e609',
               type   => 'STACK',
               hashes => [
                  'hash_10_VER_71249298fe388e38f92f8545a7788f34',
                  'hash_10_VER_41209dea3253e31eaef634624bee095b',
                  'hash_10_VER_e788deac0237a976b1a1e4e0b59b2c4a',
                  'hash_10_VER_2d2f921b0caae4cb07062838affcb128'
               ],
            },
            {  item   => 'OPVZ_physpages_failcnt',
               color  => 'FF0000',
               task   => 'hash_09_VER_898f85f4ee17c371dd1acfe116538fc6',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_3af4bce54930bd7614e70971ff7a1915',
                  'hash_10_VER_65280c49c985fe31c9ed015b625749f9',
                  'hash_10_VER_22d6fdad8397afe96f83a76b09c4151d',
                  'hash_10_VER_4f9de229b48b9cd7ddce2c05affd100a'
               ],
            },
         ],
      },
      {  name       => 'OpenVZ Sockets',
         base_value => '1000',
         hash       => 'hash_00_VER_086b03b9f25bce66f09bc26990e92aa4',
         dt         => {
            hash       => 'hash_01_VER_555464873231072c4d16dc1286898532',
            input      => 'Get OpenVZ Stats',
            OPVZ_numtcpsock_held => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_bf01451bbe8fbf9da747389ca68e524c'
            },
            OPVZ_numtcpsock_failcnt => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_7539fd0d6b39f6f4d8c616fc5793f8f2'
            },
            OPVZ_numothersock_held => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_99fcfb8a067ea1faf2e96899bc284cfa'
            },
            OPVZ_numothersock_failcnt => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_05d59dabe5c42ba4f8b4917b5e651bb3'
            },
         },
         items => [
            {  item   => 'OPVZ_numtcpsock_held',
               color  => 'BF604D',
               task   => 'hash_09_VER_54380e9b1c5c9b3d5cb57b1dc77c4322',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_f743a5cf79e17433120d81bf5008b224',
                  'hash_10_VER_0b290ff342a913b3a7cb1d1e22eec46c',
                  'hash_10_VER_76e961ecab020b4e6e6d55959957c92d',
                  'hash_10_VER_492bd378f6abc056e4562ce7a9ae1d75'
               ],
            },
            {  item   => 'OPVZ_numtcpsock_failcnt',
               color  => 'FF0000',
               task   => 'hash_09_VER_fb0f708eea0d489796852158e096dc52',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_cdd5922104e50726f674cd9ef7d86966',
                  'hash_10_VER_6ddc35a568db8a6894d171ee51019e0e',
                  'hash_10_VER_54ef96e2bc6ba2ab2728eb94a59fba10',
                  'hash_10_VER_a43ac1d57a702bd3a7bd417ab94ccc99'
               ],
            },
            {  item   => 'OPVZ_numothersock_held',
               color  => 'CCCD7F',
               task   => 'hash_09_VER_b29c6af1abb998336b378d5a766eee21',
               type   => 'STACK',
               hashes => [
                  'hash_10_VER_08c6de191ccf94ebe487a85265692146',
                  'hash_10_VER_2856166b102ae4ca2b13b97f16381a46',
                  'hash_10_VER_24c69dd84f25e3717e0cb02f4806446b',
                  'hash_10_VER_8fa7f89dc5b4f875b9800d93b92f07da'
               ],
            },
            {  item   => 'OPVZ_numothersock_failcnt',
               color  => 'FF0000',
               task   => 'hash_09_VER_f87ed9ccddb425bee889e45eb700f0a9',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_371e4b6c0e5924eb7d37479a85847723',
                  'hash_10_VER_86a1b2b5cf3d44aed0e14603a546fcae',
                  'hash_10_VER_a5490f3295310bc21ead503cb5af61a6',
                  'hash_10_VER_4bd0e28b896a6673c35ca5343fa0ed6f'
               ],
            },
         ],
      },
      {  name       => 'OpenVZ Processes',
         base_value => '1000',
         hash       => 'hash_00_VER_5acb2bd6c2e1c8cc2aefdbc96d62e65b',
         dt         => {
            hash       => 'hash_01_VER_1b8d5f79339364b7e551dc20d326e141',
            input      => 'Get OpenVZ Stats',
            OPVZ_numproc_held => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_071907f8a0bd0df92997534888057504'
            },
            OPVZ_numproc_failcnt => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_b94f114c479276de5a2ed9b38f0af5f9'
            },
            OPVZ_numpty_held => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_022c02e59382d8e7036136aedcf8256c'
            },
            OPVZ_numpty_failcnt => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_6c0b83b446548b824829d642cd35acd9'
            },
         },
         items => [
            {  item   => 'OPVZ_numproc_held',
               color  => '532100',
               task   => 'hash_09_VER_84663665b31dd40695de212e633ef86c',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_dbe34412519e175c5a97884ccc25943e',
                  'hash_10_VER_75803dcea5e0e700bee1eb17b83f1439',
                  'hash_10_VER_9a6d9c722c28fed1d53410d257e84c90',
                  'hash_10_VER_82228ad25c374d5e7b8ff77b958dc230'
               ],
            },
            {  item   => 'OPVZ_numproc_failcnt',
               color  => 'FF0000',
               task   => 'hash_09_VER_922464c7085992b8d7013a615f26c764',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_71531f25d7850c8e45d26e0cc0e61dad',
                  'hash_10_VER_6bed2495f8d7fea82c5a9710420dd23a',
                  'hash_10_VER_f1b028aed06abf737dbf8d8ed9c33d42',
                  'hash_10_VER_b7ad424abeb48041a3e0574ac93d0b77'
               ],
            },
            {  item   => 'OPVZ_numpty_held',
               color  => '303258',
               task   => 'hash_09_VER_a97f713c30daabcca73af641b8f64e02',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_12d4ab00db1d5b5de4b8d3a71f0f7b11',
                  'hash_10_VER_5edbea2f2289daf3967862735b059a55',
                  'hash_10_VER_f05e30f0b2eaa50e6b44821a646551bf',
                  'hash_10_VER_4c30cb39afdb4206af51a5735d500aaa'
               ],
            },
            {  item   => 'OPVZ_numpty_failcnt',
               color  => 'FF0000',
               task   => 'hash_09_VER_2dd59427c7f0432745ff0611804db6f7',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_823781bb1753b65ed88cc23fd09efb08',
                  'hash_10_VER_be618a8e8d43b43ae3d89a135eadcd8f',
                  'hash_10_VER_0d7d25bc695cad8555991f4dee8041e6',
                  'hash_10_VER_1d87f4a19857942e75494c0dfeb12f58'
               ],
            },
         ],
      },
      {  name       => 'OpenVZ Files',
         base_value => '1000',
         hash       => 'hash_00_VER_ea191cd69fd8c5b1f7efb10174842546',
         dt         => {
            hash       => 'hash_01_VER_a55f931e96822415518cfeb035ff6685',
            input      => 'Get OpenVZ Stats',
            OPVZ_numfile_held => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_eb40015bd8ce013bc646d3ca5e90b780'
            },
            OPVZ_numfile_failcnt => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_7c8bfa1419cd3ad0af26efaa227d57e4'
            },
            OPVZ_numflock_held => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_71b3d59136c2d5ddb23549c6a2fc6730'
            },
            OPVZ_numflock_failcnt => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_174a1caf1f34d45038fc8f093e2afb59'
            },
         },
         items => [
            {  item   => 'OPVZ_numfile_held',
               color  => '6D1116',
               task   => 'hash_09_VER_6d8d180e7c2d2453b704d5f7601ba1d1',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_470ebc99485b76799b30b2b5f1981a9c',
                  'hash_10_VER_2b3f1bd80c6b65224547a7ad05b00480',
                  'hash_10_VER_8b91f3aab7ba3e7f31da0e3344db9eaf',
                  'hash_10_VER_95c4b95de6f5a446747fdf97db639bdb'
               ],
            },
            {  item   => 'OPVZ_numfile_failcnt',
               color  => 'FF0000',
               task   => 'hash_09_VER_151abdf38458e6182f1c48f981656669',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_c43cc5fdc43c3726fa1c76c4013f9b93',
                  'hash_10_VER_73e58a68392fdcefc032b2b1037ddee3',
                  'hash_10_VER_2537364d2b49fa505d51a41e236b5d9b',
                  'hash_10_VER_b194ee80ba5c533ed0454528d6c4445a'
               ],
            },
            {  item   => 'OPVZ_numflock_held',
               color  => '849487',
               task   => 'hash_09_VER_d4a76512fb84b08d6e98b8a4c7ea9786',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_ca55fcaa6fabae7481f6fe6641aba732',
                  'hash_10_VER_1b4194ab1de253e817982548f86b639a',
                  'hash_10_VER_8325b292112cb36daa98e726dfd4e3b5',
                  'hash_10_VER_2b135fae9f41fc4bacfd992d8085a7f5'
               ],
            },
            {  item   => 'OPVZ_numflock_failcnt',
               color  => 'FF0000',
               task   => 'hash_09_VER_cdf66b33265ae59e43be57f3b1c8e2b3',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_34043fb3e6faf578a1c77ef122ecff96',
                  'hash_10_VER_56bb131d0278d97c12f2d380ed6904ff',
                  'hash_10_VER_7c2785f3dbab36e12a8023878695c66a',
                  'hash_10_VER_9914e114bf3435f08c5dc347f5b14534'
               ],
            },
         ],
      },
      {  name       => 'OpenVZ Signals',
         base_value => '1000',
         hash       => 'hash_00_VER_36f666c11769cabe6be93703b77e2e31',
         dt         => {
            hash       => 'hash_01_VER_8967b3ec9ebe9e41e9ae1d18203bf984',
            input      => 'Get OpenVZ Stats',
            OPVZ_numsiginfo_held => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_2c068b8e732b62bb72212dbf95d24a40'
            },
            OPVZ_numsiginfo_failcnt => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_f44f689837fc8bdc259f61a2be9a28c1'
            },
         },
         items => [
            {  item   => 'OPVZ_numsiginfo_held',
               color  => '123870',
               task   => 'hash_09_VER_abab19374bc98af8200101456ad53f88',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_63477a257c37c653179fceab1ff5e787',
                  'hash_10_VER_8cce0c18f4b7cd653b0abe80a1d646c7',
                  'hash_10_VER_768d15f117e0ac61850b6abc41e18df0',
                  'hash_10_VER_85de3db38ad3d80f13a4d2b78b947b61'
               ],
            },
            {  item   => 'OPVZ_numsiginfo_failcnt',
               color  => 'FF0000',
               task   => 'hash_09_VER_b94fcef51f29fed1ba864e156487a790',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_19248a33a617aa3b6459ec5b76169983',
                  'hash_10_VER_29710bda7de203d566cef249a0ce11e9',
                  'hash_10_VER_8976369ad419de3b5652d34eb73cceb9',
                  'hash_10_VER_4a6b55922cebb371be058f37cbc56d1c'
               ],
            },
         ],
      },
      {  name       => 'OpenVZ Buffers',
         base_value => '1024',
         hash       => 'hash_00_VER_8bdbc49aebb0f177d7d90081bfa086a6',
         dt         => {
            hash       => 'hash_01_VER_17a6c279091944c43d0cf576ba744ebd',
            input      => 'Get OpenVZ Stats',
            OPVZ_tcpsndbuf_held => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_c3f0aa3fd17691738aa6470a86b0b5cd'
            },
            OPVZ_tcpsndbuf_failcnt => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_fdb9df344c1a5e3d3abf1f17f1042ca9'
            },
            OPVZ_tcprcvbuf_held => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_9fe40d1645f3401a0777cb8aded51a6c'
            },
            OPVZ_tcprcvbuf_failcnt => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_9c7cae9f4fc99b6ae64f3b621ce8b1af'
            },
            OPVZ_othersockbuf_held => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_8c9759f4e873db47ad7aa20e201dbade'
            },
            OPVZ_othersockbuf_failcnt => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_c6e8a0a285b867a5679597dc5f4eec94'
            },
            OPVZ_dgramrcvbuf_held => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_4e79070f020a65ec61879ad3e1a12c6d'
            },
            OPVZ_dgramrcvbuf_failcnt => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_6dcfc33624e335f16290752763903c78'
            },
         },
         items => [
            {  item   => 'OPVZ_tcpsndbuf_held',
               color  => 'F35E5E',
               task   => 'hash_09_VER_6dd11255c41f49742d89bb0b6da33e6c',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_ad58c6aef528d342b016f2e24bdd18e8',
                  'hash_10_VER_be78e98f4823c2211f0b6974d2d960d5',
                  'hash_10_VER_1d56053cccd2926ea5d57d572867d916',
                  'hash_10_VER_1316ebe0a336b5f2a17a71c6d840226a'
               ],
            },
            {  item   => 'OPVZ_tcpsndbuf_failcnt',
               color  => 'FF0000',
               task   => 'hash_09_VER_e5c88ccb4c509a8f902b87ba370bac55',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_2a7619227983a7a391ecee6396e4e5b1',
                  'hash_10_VER_310c797dcc667f10b3e001fb547f6c02',
                  'hash_10_VER_b79a04aec011171abd47f91dea407e12',
                  'hash_10_VER_b4d43e25685ba7808639ed6bcfa2278c'
               ],
            },
            {  item   => 'OPVZ_tcprcvbuf_held',
               color  => '123870',
               task   => 'hash_09_VER_bda8281a97a6a03a99961ea5ff5ebb86',
               type   => 'STACK',
               hashes => [
                  'hash_10_VER_483d16168712f7983e6942975a00374b',
                  'hash_10_VER_d220bb7c9a1e8157ff174a739d7c0d1a',
                  'hash_10_VER_1209072ee711bd6a8769522e5b1a8016',
                  'hash_10_VER_67b6a51041315c5fad98469b18814c4d'
               ],
            },
            {  item   => 'OPVZ_tcprcvbuf_failcnt',
               color  => 'FF0000',
               task   => 'hash_09_VER_307d5f5d1c2182ba53dd1eb7beb1cdf2',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_3ed01f16d4276c63688f2f376b353fc2',
                  'hash_10_VER_e74326112f31104bcbb651646ba0c8c4',
                  'hash_10_VER_239690f28072a1e927d5c7863bf59cd7',
                  'hash_10_VER_2abb78ad9c028c22e574ef31205ef3a6'
               ],
            },
            {  item   => 'OPVZ_othersockbuf_held',
               color  => '67D4CC',
               task   => 'hash_09_VER_db34a8d106ebac20b3ec2e76c3db23ac',
               type   => 'STACK',
               hashes => [
                  'hash_10_VER_c8c81118926808b439587561f0a304b0',
                  'hash_10_VER_3b7b75b38be73a0b4b1dd4b67e88a95c',
                  'hash_10_VER_cac304010978ee27b01720ba2312e119',
                  'hash_10_VER_a4bbc4ead7e88bf14d28379ecd5e02be'
               ],
            },
            {  item   => 'OPVZ_othersockbuf_failcnt',
               color  => 'FF0000',
               task   => 'hash_09_VER_0570dff55658de7a9a6a8bfbe12151b0',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_acbd80ac5fc4b891b1b68da084e865ae',
                  'hash_10_VER_2338cf1c3fbd8d0eed00b25da8f9eb09',
                  'hash_10_VER_98c93c9a8e0755e9b694c51a43dbae5a',
                  'hash_10_VER_5e71b3829b6b018926c3b819b56117f7'
               ],
            },
            {  item   => 'OPVZ_dgramrcvbuf_held',
               color  => 'D80909',
               task   => 'hash_09_VER_dd5574aee953ae2355e4b80969b7a5a8',
               type   => 'STACK',
               hashes => [
                  'hash_10_VER_8832dcef8d50ef91e6de5fb09606bd69',
                  'hash_10_VER_0ea8a8f682116bbaf30fdf35575d6d58',
                  'hash_10_VER_2c4a7523efb6eb305720fe430e22a630',
                  'hash_10_VER_d7801cdbec973d911dd8fc12a6857560'
               ],
            },
            {  item   => 'OPVZ_dgramrcvbuf_failcnt',
               color  => 'FF0000',
               task   => 'hash_09_VER_d20cf3e763ee504932653b2272b6a400',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_7f29aee3a7bd1284746994db7c83c7aa',
                  'hash_10_VER_a138e7070537163c75d17d6d76242fb3',
                  'hash_10_VER_85fa7cba1b011d7707d8f2370edc21b6',
                  'hash_10_VER_7f52424bdaaa24c0d18a80e8452c6bb0'
               ],
            },
         ],
      },
      {  name       => 'OpenVZ Dentry/Inode Cache',
         base_value => '1000',
         hash       => 'hash_00_VER_df4d85bb8fab9513c7174ca49a90fe42',
         dt         => {
            hash       => 'hash_01_VER_dd82d5431b45c6bcf57d090fce675fae',
            input      => 'Get OpenVZ Stats',
            OPVZ_dcachesize_held => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_b92d38a0f32e635d85a90a6590dd20c5'
            },
            OPVZ_dcachesize_failcnt => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_816baea709e21376623041ee6f7eb735'
            },
         },
         items => [
            {  item   => 'OPVZ_dcachesize_held',
               color  => '43220A',
               task   => 'hash_09_VER_ea164c5c62d09fd9b9beb016a8a31013',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_51524f44b6dfe08c2764496303dacce2',
                  'hash_10_VER_4d418c734e7e7b6573a125d025064cba',
                  'hash_10_VER_f23accd83b591e08754ee121a3bb5b77',
                  'hash_10_VER_050a1d9f13c0ca35cc954f4eb21da147'
               ],
            },
            {  item   => 'OPVZ_dcachesize_failcnt',
               color  => 'FF0000',
               task   => 'hash_09_VER_c8168c9f67b0c1c3ed8eedbea3cfd14f',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_a0d8a481c1f1f675cb76d7f9596854e5',
                  'hash_10_VER_d5fb111ced32a47f02e9243fc8302a5a',
                  'hash_10_VER_7339c7e772eea41ac89a825ba18224b7',
                  'hash_10_VER_556faaa845da48e72042d919b57ea525'
               ],
            },
         ],
      },
      {  name       => 'OpenVZ NETFILTER Entries',
         base_value => '1000',
         hash       => 'hash_00_VER_eef17be1414b4aafee8511c95c4f105a',
         dt         => {
            hash       => 'hash_01_VER_abcf214d04dc7a4064883f2aa0db0c2d',
            input      => 'Get OpenVZ Stats',
            OPVZ_numiptent_held => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_58af1ef93e40336e509e0588717bb82e'
            },
            OPVZ_numiptent_failcnt => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_09b1b2dcae71833f33f05d9ac9058aa7'
            },
         },
         items => [
            {  item   => 'OPVZ_numiptent_held',
               color  => '7A6E64',
               task   => 'hash_09_VER_a6b39a0c91c5fc7c10f5dc9349b39c07',
               type   => 'LINE2',
               hashes => [
                  'hash_10_VER_445a7f0d474fe1028262b967b0e20fe4',
                  'hash_10_VER_6cde6ea96f931a18b580c8dec0f0cc67',
                  'hash_10_VER_c82392c6eec7cdbc9515dfee97950132',
                  'hash_10_VER_a2098b0bab7799c9ca811d1c68a3baa1'
               ],
            },
            {  item   => 'OPVZ_numiptent_failcnt',
               color  => 'FF0000',
               task   => 'hash_09_VER_a67e84ce29116b35ca9381642ac81815',
               type   => 'LINE1',
               hashes => [
                  'hash_10_VER_9f80c69e94ccc3efd9db5a971b84425c',
                  'hash_10_VER_4a5c89d08f710aca62d797ddc0e08cd8',
                  'hash_10_VER_1376ad777a3501cd7c79bd5378eaaa95',
                  'hash_10_VER_750bbe17b23f87d3ba1f58c75678ab78'
               ],
            },
         ],
      },
   ],
   inputs => {
      'Get OpenVZ Stats' => {
         type_id      => 1,
         hash         => 'hash_03_VER_7691eacce00e862debfabedd710bfa9b',
         input_string => '<path_php_binary> -q <path_cacti>/scripts/ss_get_by_ssh.php '
                       . '--host <hostname> --type openvz --items <items> ',
         inputs => [
            {  allow_nulls => '',
               hash        => 'hash_07_VER_8daeb2ad8588834c086b6ee2714d4861',
               name        => 'hostname'
            },
         ],
         outputs => {
            OPVZ_kmemsize_held        => 'hash_07_VER_3946f77a709b66a7e2308f43bee3addc',
            OPVZ_kmemsize_failcnt     => 'hash_07_VER_4eeaa1b7e267b3a4bf83ac51e42d4756',
            OPVZ_lockedpages_held     => 'hash_07_VER_118e5b61108ec4a9d59498f1f303ba84',
            OPVZ_lockedpages_failcnt  => 'hash_07_VER_635001850fbde73f8979669efcdd5fad',
            OPVZ_privvmpages_held     => 'hash_07_VER_451055cb583f6ce0e87e34ed3a6da1bf',
            OPVZ_privvmpages_failcnt  => 'hash_07_VER_df324abca8cb920329ed4d2cb21c9e59',
            OPVZ_shmpages_held        => 'hash_07_VER_cb5fed9ed8def9876dadbcbc722fdd06',
            OPVZ_shmpages_failcnt     => 'hash_07_VER_08941ae356eca9001c90ee2d580f6b26',
            OPVZ_numproc_held         => 'hash_07_VER_e701512991cd65b3b046cf2ebfda55a7',
            OPVZ_numproc_failcnt      => 'hash_07_VER_0e1570621c1e51f914c858fb29038a88',
            OPVZ_physpages_held       => 'hash_07_VER_9b81208ccc50997b50d98a82c66c5f7f',
            OPVZ_physpages_failcnt    => 'hash_07_VER_b92009c95f4670197fc5efd127216a5c',
            OPVZ_vmguarpages_held     => 'hash_07_VER_d59729f0d646cec42788bd8919bfd3ba',
            OPVZ_vmguarpages_failcnt  => 'hash_07_VER_3b8cd54f0b4d723108b411190f70090a',
            OPVZ_oomguarpages_held    => 'hash_07_VER_76efb4ba9c35ba236bb115a389986bc0',
            OPVZ_oomguarpages_failcnt => 'hash_07_VER_9ccfc58b0994871699b2ca24582a4850',
            OPVZ_numtcpsock_held      => 'hash_07_VER_c7101ff75b14dc5178f8202e4c3b6415',
            OPVZ_numtcpsock_failcnt   => 'hash_07_VER_5f7c759b020dfad4102382e17746f802',
            OPVZ_numflock_held        => 'hash_07_VER_cacec2578881eebe798999f956a11ff6',
            OPVZ_numflock_failcnt     => 'hash_07_VER_52cc7c5db849a301747b4850dab3491e',
            OPVZ_numpty_held          => 'hash_07_VER_5abb65e7d0516b33e60c79948de37b8f',
            OPVZ_numpty_failcnt       => 'hash_07_VER_44fbf080a9cc88547e69f0797a3f5f85',
            OPVZ_numsiginfo_held      => 'hash_07_VER_0814bcd0aea697512585be114e780616',
            OPVZ_numsiginfo_failcnt   => 'hash_07_VER_942305e972a77a3aeebc373f27f66727',
            OPVZ_tcpsndbuf_held       => 'hash_07_VER_66e6d9f1b3f22bc06421dd43d665d060',
            OPVZ_tcpsndbuf_failcnt    => 'hash_07_VER_d90ee4c04a96f131c520659b35970924',
            OPVZ_tcprcvbuf_held       => 'hash_07_VER_b239e304ab802bf36862556c67bed1b8',
            OPVZ_tcprcvbuf_failcnt    => 'hash_07_VER_8c529b1559ef6f69d36d4d4404161c25',
            OPVZ_othersockbuf_held    => 'hash_07_VER_4a5d5d8b731e805e8206fb8ef2deb4e1',
            OPVZ_othersockbuf_failcnt => 'hash_07_VER_b2c3698a588076da539af8020c1d2b88',
            OPVZ_dgramrcvbuf_held     => 'hash_07_VER_0095a8e4ebd21f6f5f71002f8637efca',
            OPVZ_dgramrcvbuf_failcnt  => 'hash_07_VER_d5d06be3ddc2fd83ac4e5bdd3dbd7dc2',
            OPVZ_numothersock_held    => 'hash_07_VER_fabed297529c916fba4c17c6fc4e2420',
            OPVZ_numothersock_failcnt => 'hash_07_VER_40003198d537aebf48d1f7f185156248',
            OPVZ_dcachesize_held      => 'hash_07_VER_f545a2f110974e8a03cc22a54865c470',
            OPVZ_dcachesize_failcnt   => 'hash_07_VER_325c6cc251454bb2b2eee67f2227ce78',
            OPVZ_numfile_held         => 'hash_07_VER_ed666c3965421daede1eaa64ca2c9cfd',
            OPVZ_numfile_failcnt      => 'hash_07_VER_d4fcf74f9c955552456995b1a060b8a0',
            OPVZ_numiptent_held       => 'hash_07_VER_0e3a459161ae58e45cb6898d15df812e',
            OPVZ_numiptent_failcnt    => 'hash_07_VER_a6ad875031863cc875bfd6e92b106887',
         },
      },
   },
};
