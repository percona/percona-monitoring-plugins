#!/usr/bin/perl

# This is a script that helps generates a Perl data structure for Cacti graph
# templates.
#
# This program is copyright (c) 2007 Baron Schwartz. Feedback and improvements
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

use strict;
use warnings FATAL => 'all';
use English qw(-no_match_vars);

my $oktorun = 1;
while ( $oktorun ) {
   my @names;
   my $line;
   while ( $line = <> ) {
      chomp $line;
      last unless $line; # Break at blank lines.
      my ( $name ) = $line =~ m/(\S+)/;
      push @names, $name;
   }
   $oktorun = defined $line; # exit at eof

   print <<'   EOF';
      {  name       => 'NAME',
         base_value => '1024',
         hash       => 'hash_00_VER_09d9a71a602d18d831925419fddbdd39',
         dt         => {
            hash       => 'hash_01_VER_07ad123d392f3d06d255271acb37f628',
            input      => 'Get NAME Stats',
   EOF

   foreach my $name ( @names ) {
      print <<"      EOF";
            $name => {
               data_source_type_id => '1',
               hash => 'hash_08_VER_ccda4eba57a840570248abdcfc46043f'
            },
      EOF
   }

   print <<'   EOF';
         },
         items => [
   EOF

   foreach my $name ( @names ) {
      print <<"      EOF";
            {  item   => '$name',
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
      EOF
   }

   print <<'   EOF';
         ],
      },
   EOF

}
