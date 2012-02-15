#!/usr/bin/perl

# This is a script that uniqueifies hashes in a file.  When given the --refresh
# option it will replace every hash with a new one.
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

use strict;
use warnings FATAL => 'all';

use English qw(-no_match_vars);
use Digest::MD5 qw(md5_hex);
use Time::HiRes qw(gettimeofday);

my %seen;

my $hash_pat = qr/_VER_([a-fA-F0-9]+)/;

my $refresh;
if ( @ARGV && $ARGV[0] eq '--refresh' ) {
   shift @ARGV;
   $refresh = 1;
}

while ( my $line = <> ) {
   my ( $hash ) = $line =~ m/$hash_pat/g;
   if ( $hash ) {
      die "hash $hash isn't the right length" unless length($hash) == 32;
      if ( $refresh || $seen{$hash}++ ) {
         my $new = md5_hex('abcd' . gettimeofday() . rand());
         while ( $seen{$new} ) {
            $new = md5_hex('abcd' . gettimeofday() . rand());
         }
         $seen{$new}++;
         $line =~ s/$hash/$new/;
      }
   }
   print $line;
}
