#!/usr/bin/perl

# This is a script that extracts graph templates matching a pattern from a Cacti
# database.  It is supposed to make it easier to create a .pl file that
# make-template.pl can consume.
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

# ###########################################################################
# OptionParser package 1844
# ###########################################################################
use strict;
use warnings FATAL => 'all';

package OptionParser;

use Getopt::Long;
use List::Util qw(max);
use English qw(-no_match_vars);

sub new {
   my ( $class, @opts ) = @_;
   my %key_seen;
   my %long_seen;
   my %key_for;
   my %defaults;
   my @mutex;
   my @atleast1;
   my %long_for;
   my %disables;
   my %copyfrom;
   unshift @opts,
      { s => 'help',    d => 'Show this help message' },
      { s => 'version', d => 'Output version information and exit' };
   foreach my $opt ( @opts ) {
      if ( ref $opt ) {
         my ( $long, $short ) = $opt->{s} =~ m/^([\w-]+)(?:\|([^!+=]*))?/;
         $opt->{k} = $short || $long;
         $key_for{$long} = $opt->{k};
         $long_for{$opt->{k}} = $long;
         $long_for{$long} = $long;
         $opt->{l} = $long;
         die "Duplicate option $opt->{k}" if $key_seen{$opt->{k}}++;
         die "Duplicate long option $opt->{l}" if $long_seen{$opt->{l}}++;
         $opt->{t} = $short;
         $opt->{n} = $opt->{s} =~ m/!/;
         $opt->{g} ||= 'o';
         if ( (my ($y) = $opt->{s} =~ m/=([mdHhAaz])/) ) {
            $ENV{MKDEBUG} && _d("Option $opt->{k} type: $y");
            $opt->{y} = $y;
            $opt->{s} =~ s/=./=s/;
         }
         if ( $opt->{d} =~ m/required/ ) {
            $opt->{r} = 1;
            $ENV{MKDEBUG} && _d("Option $opt->{k} is required");
         }
         if ( (my ($def) = $opt->{d} =~ m/default\b(?: ([^)]+))?/) ) {
            $defaults{$opt->{k}} = defined $def ? $def : 1;
            $ENV{MKDEBUG} && _d("Option $opt->{k} has a default");
         }
         if ( (my ($dis) = $opt->{d} =~ m/(disables .*)/) ) {
            $disables{$opt->{k}} = [ $class->get_participants($dis) ];
            $ENV{MKDEBUG} && _d("Option $opt->{k} $dis");
         }
      }
      else { # It's an instruction.

         if ( $opt =~ m/at least one|mutually exclusive|one and only one/ ) {
            my @participants = map {
                  die "No such option '$_' in $opt" unless $long_for{$_};
                  $long_for{$_};
               } $class->get_participants($opt);
            if ( $opt =~ m/mutually exclusive|one and only one/ ) {
               push @mutex, \@participants;
               $ENV{MKDEBUG} && _d(@participants, ' are mutually exclusive');
            }
            if ( $opt =~ m/at least one|one and only one/ ) {
               push @atleast1, \@participants;
               $ENV{MKDEBUG} && _d(@participants, ' require at least one');
            }
         }
         elsif ( $opt =~ m/default to/ ) {
            my @participants = map {
                  die "No such option '$_' in $opt" unless $long_for{$_};
                  $key_for{$_};
               } $class->get_participants($opt);
            $copyfrom{$participants[0]} = $participants[1];
            $ENV{MKDEBUG} && _d(@participants, ' copy from each other');
         }

      }
   }

   if ( $ENV{MKDEBUG} ) {
      my $text = do {
         local $RS = undef;
         open my $fh, "<", $PROGRAM_NAME
            or die "Can't open $PROGRAM_NAME: $OS_ERROR";
         <$fh>;
      };
      my %used = map { $_ => 1 } $text =~ m/\$opts\{'?([\w-]+)'?\}/g;
      my @unused;
      my @undefined;
      my %option_exists;
      foreach my $opt ( @opts ) {
         next unless ref $opt;
         my $key = $opt->{k};
         $option_exists{$key}++;
         next if $opt->{l} =~ m/^(?:help|version|defaults-file|database|charset
                                    |password|port|socket|user|host)$/x
              || $disables{$key};
         push @unused, $key unless $used{$key};
      }
      foreach my $key ( keys %used ) {
         push @undefined, $key unless $option_exists{$key};
      }
      if ( @unused || @undefined ) {
         die "The following command-line options are unused: "
            . join(',', @unused)
            . ' The following are undefined: '
            . join(',', @undefined);
      }
   }

   foreach my $dis ( keys %disables ) {
      $disables{$dis} = [ map {
            die "No such option '$_' while processing $dis" unless $long_for{$_};
            $long_for{$_};
         } @{$disables{$dis}} ];
   }

   return bless {
      specs => [ grep { ref $_ } @opts ],
      notes => [],
      instr => [ grep { !ref $_ } @opts ],
      mutex => \@mutex,
      defaults => \%defaults,
      long_for => \%long_for,
      atleast1 => \@atleast1,
      disables => \%disables,
      key_for  => \%key_for,
      copyfrom => \%copyfrom,
      strict   => 1,
      groups   => [ { k => 'o', d => 'Options' } ],
   }, $class;
}

sub get_participants {
   my ( $self, $str ) = @_;
   my @participants;
   foreach my $thing ( $str =~ m/(--?[\w-]+)/g ) {
      if ( (my ($long) = $thing =~ m/--(.+)/) ) {
         push @participants, $long;
      }
      else {
         foreach my $short ( $thing =~ m/([^-])/g ) {
            push @participants, $short;
         }
      }
   }
   $ENV{MKDEBUG} && _d("Participants for $str: ", @participants);
   return @participants;
}

sub parse {
   my ( $self, %defaults ) = @_;
   my @specs = @{$self->{specs}};
   my %factor_for = (k => 1_024, M => 1_048_576, G => 1_073_741_824);

   my %opt_seen;
   my %vals = %{$self->{defaults}};
   @vals{keys %defaults} = values %defaults;
   foreach my $spec ( @specs ) {
      $vals{$spec->{k}} = undef unless defined $vals{$spec->{k}};
      $opt_seen{$spec->{k}} = 1;
   }

   foreach my $key ( keys %defaults ) {
      die "Cannot set default for non-existent option '$key'\n"
         unless $opt_seen{$key};
   }

   Getopt::Long::Configure('no_ignore_case', 'bundling');
   GetOptions( map { $_->{s} => \$vals{$_->{k}} } @specs )
      or $self->error('Error parsing options');

   if ( $vals{version} ) {
      my $prog = $self->prog;
      printf("%s  Ver %s Distrib %s Changeset %s\n",
         $prog, $main::VERSION, $main::DISTRIB, $main::SVN_REV);
      exit(0);
   }

   if ( @ARGV && $self->{strict} ) {
      $self->error("Unrecognized command-line options @ARGV");
   }

   foreach my $dis ( grep { defined $vals{$_} } keys %{$self->{disables}} ) {
      my @disses = map { $self->{key_for}->{$_} } @{$self->{disables}->{$dis}};
      $ENV{MKDEBUG} && _d("Unsetting options: ", @disses);
      @vals{@disses} = map { undef } @disses;
   }

   foreach my $spec ( grep { $_->{r} } @specs ) {
      if ( !defined $vals{$spec->{k}} ) {
         $self->error("Required option --$spec->{l} must be specified");
      }
   }

   foreach my $mutex ( @{$self->{mutex}} ) {
      my @set = grep { defined $vals{$self->{key_for}->{$_}} } @$mutex;
      if ( @set > 1 ) {
         my $note = join(', ',
            map { "--$self->{long_for}->{$_}" }
                @{$mutex}[ 0 .. scalar(@$mutex) - 2] );
         $note .= " and --$self->{long_for}->{$mutex->[-1]}"
               . " are mutually exclusive.";
         $self->error($note);
      }
   }

   foreach my $required ( @{$self->{atleast1}} ) {
      my @set = grep { defined $vals{$self->{key_for}->{$_}} } @$required;
      if ( !@set ) {
         my $note = join(', ',
            map { "--$self->{long_for}->{$_}" }
                @{$required}[ 0 .. scalar(@$required) - 2] );
         $note .= " or --$self->{long_for}->{$required->[-1]}";
         $self->error("Specify at least one of $note");
      }
   }

   foreach my $spec ( grep { $_->{y} && defined $vals{$_->{k}} } @specs ) {
      my $val = $vals{$spec->{k}};
      if ( $spec->{y} eq 'm' ) {
         my ( $num, $suffix ) = $val =~ m/(\d+)([a-z])?$/;
         if ( !$suffix ) {
            my ( $s ) = $spec->{d} =~ m/\(suffix (.)\)/;
            $suffix = $s || 's';
            $ENV{MKDEBUG} && _d("No suffix given; using $suffix for $spec->{k} "
               . "(value: '$val')");
         }
         if ( $suffix =~ m/[smhd]/ ) {
            $val = $suffix eq 's' ? $num            # Seconds
                 : $suffix eq 'm' ? $num * 60       # Minutes
                 : $suffix eq 'h' ? $num * 3600     # Hours
                 :                  $num * 86400;   # Days
            $vals{$spec->{k}} = $val;
            $ENV{MKDEBUG} && _d("Setting option $spec->{k} to $val");
         }
         else {
            $self->error("Invalid --$spec->{l} argument");
         }
      }
      elsif ( $spec->{y} eq 'd' ) {
         $ENV{MKDEBUG} && _d("Parsing option $spec->{y} as a DSN");
         my $from_key = $self->{copyfrom}->{$spec->{k}};
         my $default = {};
         if ( $from_key ) {
            $ENV{MKDEBUG} && _d("Option $spec->{y} DSN copies from option $from_key");
            $default = $self->{dsn}->parse($self->{dsn}->as_string($vals{$from_key}));
         }
         $vals{$spec->{k}} = $self->{dsn}->parse($val, $default);
      }
      elsif ( $spec->{y} eq 'z' ) {
         my ($pre, $num, $factor) = $val =~ m/^([+-])?(\d+)([kMG])?$/;
         if ( defined $num ) {
            if ( $factor ) {
               $num *= $factor_for{$factor};
               $ENV{MKDEBUG} && _d("Setting option $spec->{y} to num * factor");
            }
            $vals{$spec->{k}} = ($pre || '') . $num;
         }
         else {
            $self->error("Invalid --$spec->{l} argument");
         }
      }
   }

   foreach my $spec ( grep { $_->{y} } @specs ) {
      $ENV{MKDEBUG} && _d("Treating option $spec->{k} as a list");
      my $val = $vals{$spec->{k}};
      if ( $spec->{y} eq 'H' || (defined $val && $spec->{y} eq 'h') ) {
         $vals{$spec->{k}} = { map { $_ => 1 } split(',', ($val || '')) };
      }
      elsif ( $spec->{y} eq 'A' || (defined $val && $spec->{y} eq 'a') ) {
         $vals{$spec->{k}} = [ split(',', ($val || '')) ];
      }
   }

   return %vals;
}

sub error {
   my ( $self, $note ) = @_;
   $self->{__error__} = 1;
   push @{$self->{notes}}, $note;
}

sub prog {
   (my $prog) = $PROGRAM_NAME =~ m/([.A-Za-z-]+)$/;
   return $prog || $PROGRAM_NAME;
}

sub prompt {
   my ( $self ) = @_;
   my $prog   = $self->prog;
   my $prompt = $self->{prompt} || '<options>';
   return "Usage: $prog $prompt\n";
}

sub descr {
   my ( $self ) = @_;
   my $prog = $self->prog;
   my $descr  = $prog . ' ' . ($self->{descr} || '')
          . "  For more details, please use the --help option, "
          . "or try 'perldoc $prog' for complete documentation.";
   $descr = join("\n", $descr =~ m/(.{0,80})(?:\s+|$)/g);
   $descr =~ s/ +$//mg;
   return $descr;
}

sub usage_or_errors {
   my ( $self, %opts ) = @_;
   if ( $opts{help} ) {
      print $self->usage(%opts);
      exit(0);
   }
   elsif ( $self->{__error__} ) {
      print $self->errors();
      exit(0);
   }
}

sub errors {
   my ( $self ) = @_;
   my $usage = $self->prompt() . "\n";
   if ( (my @notes = @{$self->{notes}}) ) {
      $usage .= join("\n  * ", 'Errors in command-line arguments:', @notes) . "\n";
   }
   return $usage . "\n" . $self->descr();
}

sub usage {
   my ( $self, %vals ) = @_;
   my @specs = @{$self->{specs}};

   my $maxl = max(map { length($_->{l}) + ($_->{n} ? 4 : 0)} @specs);

   my $maxs = max(0,
      map { length($_->{l}) + ($_->{n} ? 4 : 0)}
      grep { $_->{t} } @specs);

   my $lcol = max($maxl, ($maxs + 3));
   my $rcol = 80 - $lcol - 6;
   my $rpad = ' ' x ( 80 - $rcol );

   $maxs = max($lcol - 3, $maxs);

   my $usage = $self->descr() . "\n" . $self->prompt();
   foreach my $g ( @{$self->{groups}} ) {
      $usage .= "\n$g->{d}:\n";
      foreach my $spec (
         sort { $a->{l} cmp $b->{l} } grep { $_->{g} eq $g->{k} } @specs )
      {
         my $long  = $spec->{n} ? "[no]$spec->{l}" : $spec->{l};
         my $short = $spec->{t};
         my $desc  = $spec->{d};
         if ( $spec->{y} && $spec->{y} eq 'm' ) {
            my ($s) = $desc =~ m/\(suffix (.)\)/;
            $s    ||= 's';
            $desc =~ s/\s+\(suffix .\)//;
            $desc .= ".  Optional suffix s=seconds, m=minutes, h=hours, "
                   . "d=days; if no suffix, $s is used.";
         }
         $desc = join("\n$rpad", grep { $_ } $desc =~ m/(.{0,$rcol})(?:\s+|$)/g);
         $desc =~ s/ +$//mg;
         if ( $short ) {
            $usage .= sprintf("  --%-${maxs}s -%s  %s\n", $long, $short, $desc);
         }
         else {
            $usage .= sprintf("  --%-${lcol}s  %s\n", $long, $desc);
         }
      }
   }

   if ( (my @instr = @{$self->{instr}}) ) {
      $usage .= join("\n", map { "  $_" } @instr) . "\n";
   }
   if ( $self->{dsn} ) {
      $usage .= "\n" . $self->{dsn}->usage();
   }
   $usage .= "\nOptions and values after processing arguments:\n";
   foreach my $spec ( sort { $a->{l} cmp $b->{l} } @specs ) {
      my $val   = $vals{$spec->{k}};
      my $type  = $spec->{y} || '';
      my $bool  = $spec->{s} =~ m/^[\w-]+(?:\|[\w-])?!?$/;
      $val      = $bool                     ? ( $val ? 'TRUE' : 'FALSE' )
                : !defined $val             ? '(No value)'
                : $type eq 'd'              ? $self->{dsn}->as_string($val)
                : $type =~ m/H|h/           ? join(',', sort keys %$val)
                : $type =~ m/A|a/           ? join(',', @$val)
                :                             $val;
      $usage .= sprintf("  --%-${lcol}s  %s\n", $spec->{l}, $val);
   }
   return $usage;
}

sub prompt_noecho {
   shift @_ if ref $_[0] eq __PACKAGE__;
   my ( $prompt ) = @_;
   local $OUTPUT_AUTOFLUSH = 1;
   print $prompt;
   my $response;
   eval {
      require Term::ReadKey;
      Term::ReadKey::ReadMode('noecho');
      chomp($response = <STDIN>);
      Term::ReadKey::ReadMode('normal');
      print "\n";
   };
   if ( $EVAL_ERROR ) {
      die "Cannot read response; is Term::ReadKey installed? $EVAL_ERROR";
   }
   return $response;
}

sub groups {
   my ( $self, @groups ) = @_;
   push @{$self->{groups}}, @groups;
}

sub _d {
   my ( $line ) = (caller(0))[2];
   print "# OptionParser:$line $PID ", @_, "\n";
}

if ( $ENV{MKDEBUG} ) {
   print '# ', $^X, ' ', $], "\n";
   my $uname = `uname -a`;
   if ( $uname ) {
      $uname =~ s/\s+/ /g;
      print "# $uname\n";
   }
   printf("# %s  Ver %s Distrib %s Changeset %s line %d\n",
      $PROGRAM_NAME, ($main::VERSION || ''), ($main::DISTRIB || ''),
      ($main::SVN_REV || ''), __LINE__);
}

1;

# ###########################################################################
# End OptionParser package
# ###########################################################################

# ###########################################################################
# DSNParser package 1891
# ###########################################################################
use strict;
use warnings FATAL => 'all';

package DSNParser;

use DBI;
use Data::Dumper;
$Data::Dumper::Indent    = 0;
$Data::Dumper::Quotekeys = 0;
use English qw(-no_match_vars);

sub new {
   my ( $class, @opts ) = @_;
   my $self = {
      opts => {
         A => {
            desc => 'Default character set',
            dsn  => 'charset',
            copy => 1,
         },
         D => {
            desc => 'Database to use',
            dsn  => 'database',
            copy => 1,
         },
         F => {
            desc => 'Only read default options from the given file',
            dsn  => 'mysql_read_default_file',
            copy => 1,
         },
         h => {
            desc => 'Connect to host',
            dsn  => 'host',
            copy => 1,
         },
         p => {
            desc => 'Password to use when connecting',
            dsn  => 'password',
            copy => 1,
         },
         P => {
            desc => 'Port number to use for connection',
            dsn  => 'port',
            copy => 1,
         },
         S => {
            desc => 'Socket file to use for connection',
            dsn  => 'mysql_socket',
            copy => 1,
         },
         u => {
            desc => 'User for login if not current user',
            dsn  => 'user',
            copy => 1,
         },
      },
   };
   foreach my $opt ( @opts ) {
      $ENV{MKDEBUG} && _d('Adding extra property ' . $opt->{key});
      $self->{opts}->{$opt->{key}} = { desc => $opt->{desc}, copy => $opt->{copy} };
   }
   return bless $self, $class;
}

sub prop {
   my ( $self, $prop, $value ) = @_;
   if ( @_ > 2 ) {
      $ENV{MKDEBUG} && _d("Setting $prop property");
      $self->{$prop} = $value;
   }
   return $self->{$prop};
}

sub parse {
   my ( $self, $dsn, $prev, $defaults ) = @_;
   if ( !$dsn ) {
      $ENV{MKDEBUG} && _d('No DSN to parse');
      return;
   }
   $ENV{MKDEBUG} && _d("Parsing $dsn");
   $prev     ||= {};
   $defaults ||= {};
   my %vals;
   my %opts = %{$self->{opts}};
   if ( $dsn !~ m/=/ && (my $p = $self->prop('autokey')) ) {
      $ENV{MKDEBUG} && _d("Interpreting $dsn as $p=$dsn");
      $dsn = "$p=$dsn";
   }
   my %hash = map { m/^(.)=(.*)$/g } split(/,/, $dsn);
   foreach my $key ( keys %opts ) {
      $ENV{MKDEBUG} && _d("Finding value for $key");
      $vals{$key} = $hash{$key};
      if ( !defined $vals{$key} && defined $prev->{$key} && $opts{$key}->{copy} ) {
         $vals{$key} = $prev->{$key};
         $ENV{MKDEBUG} && _d("Copying value for $key from previous DSN");
      }
      if ( !defined $vals{$key} ) {
         $vals{$key} = $defaults->{$key};
         $ENV{MKDEBUG} && _d("Copying value for $key from defaults");
      }
   }
   foreach my $key ( keys %hash ) {
      die "Unrecognized DSN part '$key' in '$dsn'\n"
         unless exists $opts{$key};
   }
   if ( (my $required = $self->prop('required')) ) {
      foreach my $key ( keys %$required ) {
         die "Missing DSN part '$key' in '$dsn'\n" unless $vals{$key};
      }
   }
   return \%vals;
}

sub as_string {
   my ( $self, $dsn ) = @_;
   return $dsn unless ref $dsn;
   return join(',',
      map  { "$_=" . ($_ eq 'p' ? '...' : $dsn->{$_}) }
      grep { defined $dsn->{$_} && $self->{opts}->{$_} }
      sort keys %$dsn );
}

sub usage {
   my ( $self ) = @_;
   my $usage
      = "DSN syntax is key=value[,key=value...]  Allowable DSN keys:\n"
      . "  KEY  COPY  MEANING\n"
      . "  ===  ====  =============================================\n";
   my %opts = %{$self->{opts}};
   foreach my $key ( sort keys %opts ) {
      $usage .= "  $key    "
             .  ($opts{$key}->{copy} ? 'yes   ' : 'no    ')
             .  ($opts{$key}->{desc} || '[No description]')
             . "\n";
   }
   if ( (my $key = $self->prop('autokey')) ) {
      $usage .= "  If the DSN is a bareword, the word is treated as the '$key' key.\n";
   }
   return $usage;
}

sub get_cxn_params {
   my ( $self, $info ) = @_;
   my $dsn;
   my %opts = %{$self->{opts}};
   my $driver = $self->prop('dbidriver') || '';
   if ( $driver eq 'Pg' ) {
      $dsn = 'DBI:Pg:dbname=' . ( $info->{D} || '' ) . ';'
         . join(';', map  { "$opts{$_}->{dsn}=$info->{$_}" }
                     grep { defined $info->{$_} }
                     qw(h P));
   }
   else {
      $dsn = 'DBI:mysql:' . ( $info->{D} || '' ) . ';'
         . join(';', map  { "$opts{$_}->{dsn}=$info->{$_}" }
                     grep { defined $info->{$_} }
                     qw(F h P S A))
         . ';mysql_read_default_group=mysql';
   }
   $ENV{MKDEBUG} && _d($dsn);
   return ($dsn, $info->{u}, $info->{p});
}

sub get_dbh {
   my ( $self, $cxn_string, $user, $pass, $opts ) = @_;
   $opts ||= {};
   my $defaults = {
      AutoCommit        => 0,
      RaiseError        => 1,
      PrintError        => 0,
      mysql_enable_utf8 => ($cxn_string =~ m/charset=utf8/ ? 1 : 0),
   };
   @{$defaults}{ keys %$opts } = values %$opts;
   $ENV{MKDEBUG} && _d($cxn_string, ' ', $user, ' ', $pass, ' {',
      join(', ', map { "$_=>$defaults->{$_}" } keys %$defaults ), '}');
   my $dbh = DBI->connect($cxn_string, $user, $pass, $defaults);
   if ( my ($charset) = $cxn_string =~ m/charset=(\w+)/ ) {
      my $sql = "/*!40101 SET NAMES $charset*/";
      $ENV{MKDEBUG} && _d("$dbh: $sql");
      $dbh->do($sql);
      $ENV{MKDEBUG} && _d('Enabling charset for STDOUT');
      if ( $charset eq 'utf8' ) {
         binmode(STDOUT, ':utf8')
            or die "Can't binmode(STDOUT, ':utf8'): $OS_ERROR";
      }
      else {
         binmode(STDOUT) or die "Can't binmode(STDOUT): $OS_ERROR";
      }
   }
   my $setvars = $self->prop('setvars');
   if ( $cxn_string =~ m/mysql/i && $setvars ) {
      my $sql = "SET $setvars";
      $ENV{MKDEBUG} && _d("$dbh: $sql");
      $dbh->do($sql);
   }
   $ENV{MKDEBUG} && _d('DBH info: ',
      $dbh,
      Dumper($dbh->selectrow_hashref(
         'SELECT DATABASE(), CONNECTION_ID(), VERSION()/*!50038 , @@hostname*/')),
      ' Connection info: ', ($dbh->{mysql_hostinfo} || 'undef'),
      ' Character set info: ',
      Dumper($dbh->selectall_arrayref(
         'SHOW VARIABLES LIKE "character_set%"', { Slice => {}})),
      ' $DBD::mysql::VERSION: ', $DBD::mysql::VERSION,
      ' $DBI::VERSION: ', $DBI::VERSION,
   );
   return $dbh;
}

sub get_hostname {
   my ( $self, $dbh ) = @_;
   if ( my ($host) = ($dbh->{mysql_hostinfo} || '') =~ m/^(\w+) via/ ) {
      return $host;
   }
   my ( $hostname, $one ) = $dbh->selectrow_array(
      'SELECT /*!50038 @@hostname, */ 1');
   return $hostname;
}

sub disconnect {
   my ( $self, $dbh ) = @_;
   $ENV{MKDEBUG} && $self->print_active_handles($dbh);
   $dbh->disconnect;
}

sub print_active_handles {
   my ( $self, $thing, $level ) = @_;
   $level ||= 0;
   printf("# Active %sh: %s %s %s\n", $thing->{Type}, "\t" x $level,
      $thing, ($thing->{Type} eq 'st' ? $thing->{Statement} || '' : ''));
   foreach my $handle ( grep {defined} @{ $thing->{ChildHandles} } ) {
      $self->print_active_handles->( $handle, $level + 1 );
   }
}

sub _d {
   my ( $line ) = (caller(0))[2];
   @_ = map { defined $_ ? $_ : 'undef' } @_;
   print "# DSNParser:$line $PID ", @_, "\n";
}

1;

# ###########################################################################
# End DSNParser package
# ###########################################################################

package main;

use English qw(-no_match_vars);
use List::Util qw(max);
use Data::Dumper;
$Data::Dumper::Indent = 1;
$Data::Dumper::Quotekeys = 0;

my $dp = new DSNParser();
$dp->prop('required', { h => 1 });
$dp->prop('autokey', 'h');

# ############################################################################
# Get configuration information.
# ############################################################################

my @opt_spec = (
   { s => 'askpass',      d => 'Prompt for password for connections' },
);

my $opt_parser = OptionParser->new(@opt_spec);
$opt_parser->{prompt} = 'DSN <options>';
$opt_parser->{descr} = q{extracts Cacti templates from a database.};
my %opts = $opt_parser->parse();
$opt_parser->usage_or_errors(%opts);

# ############################################################################
# Start working.
# ############################################################################
my $dbh   = $dp->get_dbh($dp->get_cxn_params(
   {h => 'localhost', D => 'cacti'}));

my %graph_types = (
   COMMENT => 1,
   HRULE => 2,
   VRULE => 3,
   LINE1 => 4,
   LINE2 => 5,
   LINE3 => 6,
   AREA  => 7,
   STACK => 8,
   GPRINT => 9,
   LEGEND => 10,
);
my %type_for = map { $graph_types{$_} => $_ } keys %graph_types;

my $sql = 'select g.id, g.hash, g.name, t.base_value from graph_templates as g
   inner join graph_templates_graph as t on g.id = t.graph_template_id
   where name like "x %"';

foreach my $gt_row ( 
   @{ $dbh->selectall_arrayref($sql, { Slice => {} } )} ) {

   my $name = $gt_row->{name};
   $name =~ s/^X //;
   $name =~ s/ GT$//;

   my $gt = {
      name => $name,
      hash => 'hash_000013' . $gt_row->{hash},
      base_value => $gt_row->{base_value},
   };

   $sql = "
   select mi.id, mi.graph_type_id,
          colors.hex, x.cnt, x.hashes, mi.cdef_id,
          dtr.data_source_name, dtr.id as dtr_id,
          inp.hash
   from graph_templates_item as mi
      inner join (
         select task_item_id, min(id) as item_id, count(*) as cnt,
            group_concat(hash order by sequence) as hashes
         from graph_templates_item
         where graph_template_id = $gt_row->{id}
         group by task_item_id
      ) as x on mi.id = x.item_id
      inner join colors on mi.color_id = colors.id
      inner join data_template_rrd as dtr on dtr.id = mi.task_item_id
      inner join graph_template_input_defs as def on mi.id = def.graph_template_item_id
      inner join graph_template_input as inp on inp.id = def.graph_template_input_id
   order by mi.id";
   my @dtr_ids;
   foreach my $it_row ( 
      @{ $dbh->selectall_arrayref($sql, { Slice => {} } )} ) {
      push @{$gt->{items}}, {
         item => $it_row->{data_source_name},
         color => $it_row->{hex},
         type => $type_for{$it_row->{graph_type_id}},
         task => "hash_090013" . $it_row->{hash},
         hashes => [ map { "hash_100013$_" } split(/,/, $it_row->{hashes}) ],
      };
      push @dtr_ids, $it_row->{dtr_id};
   }

   $sql = "
      select dt.hash, dt.name, dtr.data_source_name, dtr.hash as dtr_hash,
         dif.hash as dif_hash, di.name as di_name, dtr.data_source_type_id
      from data_template as dt
         inner join data_template_rrd as dtr on dt.id = dtr.data_template_id
         inner join data_input_fields as dif on dif.id = dtr.data_input_field_id
         inner join data_input as di on di.id = dif.data_input_id
      where dtr.id in (" . join(',', @dtr_ids) . ')';
   foreach my $dt_row ( 
      @{ $dbh->selectall_arrayref($sql, { Slice => {} } )} ) {
      $gt->{dt}->{hash} = "hash_010013" . $dt_row->{hash};
      $gt->{dt}->{input} = $dt_row->{di_name};
      $gt->{dt}->{$dt_row->{data_source_name}} = {
         hash => "hash_080013" .  $dt_row->{dtr_hash},
         data_source_type_id => $dt_row->{data_source_type_id}
      };
   }

   print Dumper($gt);
}

$dbh->disconnect;
