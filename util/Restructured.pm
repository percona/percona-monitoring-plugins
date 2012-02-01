# Original authors: don
# $Revision: 1595 $

# Copyright (c) 2010 Don Owens <don@regexguy.com>.  All rights reserved.
#
# This is free software; you can redistribute it and/or modify it under
# the Perl Artistic license.  You should have received a copy of the
# Artistic license with this distribution, in the file named
# "Artistic".  You may also obtain a copy from
# http://regexguy.com/license/Artistic
#
# This program is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
# PURPOSE.


=pod

=head1 NAME

Pod::POM::View::Restructured - View for Pod::POM that outputs reStructuredText

=head1 SYNOPSIS

 use Pod::POM::View::Restructured;
 
 my $view = Pod::POM::View::Restructured->new;
 my $parser = Pod::POM->new;
 my $pom = $parser->parse_file("$top_dir/lib/Pod/POM/View/Restructured.pm");
 my $out = $pom->present($view);


=head1 DESCRIPTION

This module outputs reStructuredText that is expected to be used
with Sphinx.  Verbatim sections (indented paragraphs) in the POD
will be output with syntax hilighting for Perl code by default.
See L</"POD commands specifically for reStructuredText"> for how
to change this for a particular block.

For a list of changes in recent versions, see the documentation
for L<Pod::POM::View::Restructured::Changes>.

This module can be downloaded from L<http://www.cpan.org/authors/id/D/DO/DOWENS/>.

=cut

use strict;
use warnings;
use Data::Dumper ();

use Pod::POM;

package Restructured;

our $VERSION = '0.02'; # change in POD below!

use base 'Pod::POM::View::Text';

=pod

=head1 METHODS

=head2 C<new(\%params)>

Constructor.  \%params is optional.  If present, the following keys are valid:

=over 4

=item C<callbacks>

See documentation below for C<convert_file()>.

=back

=cut

sub new {
    my ($class, $params) = @_;
    $params = { } unless $params and UNIVERSAL::isa($params, 'HASH');
    
    my $self = bless { seen_something => 0, title_set => 0, params => { } }, ref($class) || $class;

    my $callbacks = $params->{callbacks};
    $callbacks = { } unless $callbacks;
    $self->{callbacks} = $callbacks;
    
    return $self;
}

=pod

=head2 C<convert_file($source_file, $title, $dest_file, $callbacks)>

Converts the POD in C<$source_file> to reStructuredText.  If
C<$dest_file> is defined, it writes the output there.  If
C<$title> is defined, it is used for the title of the document.
Otherwise, an attempt is made to infer the title from the NAME
section (checks if the body looks like C</\A\s*(\w+(?:::\w+)+)\s+-\s+/s>).

Returns the output as a string.

C<$source_file> and C<$dest_file> can be either file names or file
handles.

=cut
sub convert_file {
    my ($self, $source_file, $title, $dest_file, $callbacks) = @_;

    my $cb;
    if ($callbacks) {
        $cb = { %{ $self->{callbacks} }, %$callbacks };
    }
    else {
        $cb = $self->{callbacks};
    }
    
    my $view = Restructured->new({ callbacks => $cb });
    my $parser = Pod::POM->new;

    unless (-r $source_file) {
        warn "can't read source file $source_file";
        return undef;
    }
    
    my $pom = $parser->parse_file($source_file);

    $view->{title_set} = 1 if defined($title);
    my $out = $pom->present($view);

    if (defined($title)) {
        $out = $self->_build_header($title, '#', 1) . "\n" . $out;
    }
    else {
        $title = $view->{title};
    }

    if (defined($dest_file) and $dest_file ne '') {
        my $out_fh;
        if (UNIVERSAL::isa($dest_file, 'GLOB')) {
            $out_fh = $dest_file;
        }
        else {
            unless (open($out_fh, '>', $dest_file)) {
                warn "couldn't open output file $dest_file";
                return undef;
            }
        }

        print $out_fh $out;
        close $out_fh;
    }

    my $rv = { content => $out, title => $title };

    return $rv;
}

=pod

=head2 C<convert_files($file_spec, $index_file, $index_title, $out_dir)>

Converts the files given in C<$file_spec> to reStructuredText.
If C<$index_file> is provided, it is the path to the index file
to be created (with a table of contents pointing to all of the
files created).  If C<$index_title> is provided, it is used as
the section title for the index file.  C<$out_dir> is the
directory the generated files will be written to.

C<$file_spec> is a reference to an array of hashes specifying
attributes for each file to be converted.  The valid keys are:

=over 4

=item C<source_file>

File to convert.

=item C<dest_file>

File to output the reStructuredText.  If not provided, a file
name will be generated based on the title.

=item C<title>

Section title for the generated reStructuredText.  If not
provided, an attempt will be made to infer the title from the
NAME section in the POD, if it exists.  As a last resort, a title
will be generated that looks like "section_(\d+)".

=item C<callbacks>

A reference to a hash containing names and the corresponding callbacks.

Currently the only valid callback is C<link>.  It is given the
text inside a LE<lt>E<gt> section from the POD, and is expected to return a
tuple C<($url, $label)>.  If the value returned for C<$label> is
undefined, the value of C<$url> is used as the label.

=item C<no_toc>

Causes the item to not be printed to the index or return in the C<toc> field.

=back

This method returns a hash ref with a table of contents (the
C<toc> field) suitable for a reStructuredText table of contents.

E.g.,

 my $conv = Pod::POM::View::Restructured->new;
 
 my $files = [
              { source_file => "$base_dir/Restructured.pm" },
              { source_file => "$base_dir/DWIW.pm" },
              { source_file => "$base_dir/Wrapper.pm" },
             ];
 
 
 my $rv = $conv->convert_files($files, "$dest_dir/index.rst", 'My Big Test', $dest_dir);


=cut
sub convert_files {
    my ($self, $file_spec, $index_file, $index_title, $out_dir) = @_;

    my $index_fh = $self->_get_file_handle($index_file, '>');

    if ($index_fh and defined($index_title) and $index_title ne '') {
        my $header = $self->_build_header($index_title, '#', 1);
#         my $line = '#' x length($index_title);
#         my $header = $line . "\n" . $index_title . "\n" . $line . "\n\n";

        print $index_fh $header;

        print $index_fh "\nContents:\n\n";
        print $index_fh ".. toctree::\n";
        print $index_fh "   :maxdepth: 1\n\n";
    }

    my $count = 0;
    my $toc = '';
    foreach my $spec (@$file_spec) {
        $count++;
        my $data = $self->convert_file($spec->{source_file}, $spec->{title},
                                       $spec->{dest_file}, $spec->{callbacks});
        
        my $this_title = $data->{title};
        # print STDERR Data::Dumper->Dump([ $this_title ], [ 'this_title' ]) . "\n\n";

        unless (defined($this_title) and $this_title !~ /\A\s*\Z/) {
            $this_title = 'section_' . $count;
        }
        
        my $name = $spec->{dest_file};
        if (defined($name)) {
            $name =~ s/\.rst\Z//;
        }
        else {
            ($name = $this_title) =~ s/\W/_/g;
            my $dest_file = $out_dir . '/' . $name . '.rst';
            my $out_fh;
            
            unless (open($out_fh, '>', $dest_file)) {
                warn "couldn't open output file $dest_file";
                return undef;
            }

            print $out_fh $data->{content};
            close $out_fh;
        }

        unless ($spec->{no_toc}) {
            $toc .= '   ' . $name . "\n";
        }
        
        if ($index_fh and not $spec->{no_toc}) {
            print $index_fh "   " . $name . "\n";
        }
    }

    if ($index_fh) {
        print $index_fh "\n";
    }

    return { toc => $toc };
}

sub _get_file_handle {
    my ($self, $file, $mode) = @_;

    return undef unless defined $file;
    
    if (ref($file) and UNIVERSAL::isa($file, 'GLOB')) {
        return $file;
    }

    $mode = '<' unless $mode;
    
    my $fh;
    if ($file ne '') {
        unless (open($fh, $mode, $file)) {
            warn "couldn't open input file $file: $!";
            return undef;
        }
    }

    return $fh;
}

sub view_pod {
    my ($self, $node) = @_;

    my $content = ".. highlight:: perl\n\n";
    
    return $content . $node->content()->present($self);
}

sub _generic_head {
    my ($self, $node, $marker, $do_overline) = @_;

    return scalar($self->_generic_head_multi($node, $marker, $do_overline));
}

sub _generic_head_multi {
    my ($self, $node, $marker, $do_overline) = @_;

    my $title = $node->title()->present($self);
    my $content = $node->content()->present($self);
    
    $title = ' ' if $title eq '';
    # my $section_line = $marker x length($title);

    my $section = $self->_build_header($title, $marker, $do_overline) . "\n" . $content;
    
#     my $section = $title . "\n" . $section_line . "\n\n" . $content;
#     if ($do_overline) {
#         $section = $section_line . "\n" . $section;
#     }

    $section .= "\n";
    
    return wantarray ? ($section, $content, $title) : $section;
}

sub _build_header {
    my ($self, $text, $marker, $do_overline) = @_;

    my $line = $marker x length($text);
    my $header = $text . "\n" . $line . "\n";

    if ($do_overline) {
        $header = $line . "\n" . $header;
    }

    return "\n" . $header;
}

sub _do_indent {
    my ($self, $text, $indent_amount, $dbg) = @_;

    my $indent = ' ' x $indent_amount;

    # $indent = "'$dbg" . $indent . "'";

    my @lines = split /\n/, $text, -1;
    foreach my $line (@lines) {
        $line = $indent . $line;
    }

    return join("\n", @lines);
}

sub view_head1 {
    my ($self, $node) = @_;

    my ($section, $content, $title) = $self->_generic_head_multi($node, '*', 1);

    unless ($self->{seen_something} or $self->{title_set}) {
        if ($title eq 'NAME') {
            $self->{seen_something} = 1;

            if ($content =~ /\A\s*(\w+(?:::\w+)+)\s+-\s+/s) {
                my $mod_name = $1;
                $self->{module_name} = $mod_name;
                $self->{title} = $mod_name;
                $self->{title_set} = 1;

                $section = $self->_build_header($mod_name, '#', 1) . $section;
                
                # my $line = '#' x length($mod_name);
                # $section = $line . "\n" . $mod_name . "\n" . $line . "\n\n" . $section;
            }
            
            return $section;
        }
    }
    
    $self->{seen_something} = 1;
    return $section;
}

sub view_head2 {
    my ($self, $node) = @_;

    $self->{seen_something} = 1;
    return $self->_generic_head($node, '=');
}

sub view_head3 {
    my ($self, $node) = @_;

    $self->{seen_something} = 1;
    return $self->_generic_head($node, '-');
}

sub view_head4 {
    my ($self, $node) = @_;

    $self->{seen_something} = 1;
    return $self->_generic_head($node, '^');
}

sub view_item {
    my ($self, $node) = @_;

    $self->{seen_something} = 1;

    my $title = $node->title()->present($self);
    my $content = $node->content()->present($self);
    
    $title =~ s/\A\s+//;
    $title =~ s/\n/ /;
#     $content =~ s/\n/\n /g;
#     $content = ' ' . $content;

    $self->{view_item_count}++;
    $content = $self->_do_indent($content, 1, "[[view_item_$self->{view_item_count}]]");
    
    return "\n" . $title . "\n" . $content . "\n\n";
}

sub view_over {
    my ($self, $node) = @_;

    my $content = $node->content()->present($self);
    # my $indent = $node->indent();

    return "\n" . $content;
}

sub view_text {
    my ($self, $node) = @_;

    my @lines = split /\n/, $node;
    foreach my $line (@lines) {
        $line =~ s/\A\s+//;
    }

    return join("\n", @lines);
}

sub view_textblock {
    my ($self, $text) = @_;

    return "\n" . $text . "\n";
}


sub view_verbatim {
    my ($self, $node) = @_;

    # (my $node_part = ' ' . $node) =~ s/\n/\n /g;
    my $node_part = $self->_do_indent($node . '', 1, '[[view_verbatim]]');

    my $block_part = ".. code-block:: perl\n\n";
    if (defined($self->{next_code_block})) {
        my $lang = $self->{next_code_block};
        delete $self->{next_code_block};

        if ($lang eq 'none') {
            # FIXME: need to output a preformatted paragraph here, but no highlighting
            $block_part = '';
        }
        else {
            $block_part = ".. code-block:: $lang\n\n";
        }
    }
   
    my $content = $block_part . $node_part;

    return "\n\n" . $content . "\n\n";
}

sub view_for {
    my ($self, $node) = @_;

    my $fmt = $node->format();

    # print STDERR "got for: fmt='$fmt', text='" . $node->text() . "'\n";
    
    if ($fmt eq 'pod2rst') {
        my $text = $node->text();
        if ($text =~ /\A\s*next-code-block\s*:\s*(\S+)/) {
            my $lang = $1;
            $self->{next_code_block} = $lang;
            return '';
        }

        return '';
    }

    return $self->SUPER::view_for($node);
}

sub view_seq_code {
    my ($self, $text) = @_;

    return '\ ``' . $text . '``\ ';
}

sub view_seq_bold {
    my ($self, $text) = @_;

    $text =~ s/\*/\\*/g;
    $text =~ s/\`/\\`/g;

    return '\ **' . $text . '**\ ';
}

sub view_seq_italic {
    my ($self, $text) = @_;

    $text =~ s/\*/\\*/g;
    $text =~ s/\`/\\`/g;
    
    return '\ *' . $text . '*\ ';
}

sub view_seq_file {
    my ($self, $text) = @_;

    $text =~ s/\*/\\*/g;
    $text =~ s/\`/\\`/g;
    
    return '\ *' . $text . '*\ ';
}

sub view_seq_text {
    my ($self, $node) = @_;

    my $text = $node . '';

    $text =~ s/\*/\\*/g;
    $text =~ s/\`/\\`/g;

    return $text;
}

sub view_seq_zero {
    return '';
}

sub view_seq_link {
    my ($self, $text) = @_;

    # FIXME: determine if has label, if manpage, etc., and pass that info along to the callback,
    #        instead of just the text, e.g.,
    #        $link_cb->($label, $name, $sec, $url);
    my $link_cb = $self->{callbacks}{link};
    if ($link_cb) {
        my ($url, $label) = $link_cb->($text);

        if (defined($url)) {
            if ($url eq '' and defined($label) and $label ne '') {
                $text = $label;
            }
            elsif (defined($label) and $label ne '') {
                $text = qq{`$label <$url>`_};
            }
            else {
                $text = qq{`$url <$url>`_};
            }

            return $text;
        }
    }

    if ($text =~ m{\A/(.+)}) {
        (my $section = $1) =~ s/\A"(.+)"/$1/;
        $text = qq{`$section`_};
    }
    elsif ($text =~ m{\Ahttps?://}) {
        $text = qq{`$text <$text>`_};
    }
    elsif ($text =~ /::/) {
        my $label = $text;
        my $module = $text;
        if ($text =~ /\A(.+?)\|(.+::.+)/) {
            $label = $1;
            $module = $2;
        }

        $module = $self->_url_encode($module);
        my $url = "http://search.cpan.org/search?query=$module&mode=module";
        $text = qq{`$label <$url>`_};
    }
    
    return $text;
}

sub _url_encode {
    my ($self, $str) = @_;
    
    use bytes;
    $str =~ s{([^A-Za-z0-9_])}{sprintf("%%%02x", ord($1))}eg;
    return $str;
}


=pod

=head1 POD commands specifically for reStructuredText

The following sequences can be used in POD to request actions specifically for this module.

=head2 =Z<>for pod2rst next-code-block: I<lang>

This sets up the next verbatim section, i.e., the next indented
paragraph to be hilighted according to the syntax of the
programming/markup/config language I<lang>.  Verbatim sections
are assumed to be Perl code by default.  Sphinx uses Pygments to
do syntax hilighting in these sections, so you can use any value
for I<lang> that Pygments supports, e.g., Python, C, C++,
Javascript, SQL, etc.

=head1 EXAMPLES

=over 4

=item Converting a single file using C<pod2rst>

=for pod2rst next-code-block: bash

 pod2rst --infile=Restructured.pm --outfile=restructured.rst

=back

B<Need to document:>

=over 4

=item B<Document example of setting up sphinx build, generating rst from pod, and building>

=back


=head1 TODO

=over 4

=item code hilighting

Currently, a verbatim block (indented paragraph) gets output as a
Perl code block by default in reStructuredText. There should be
an option (e.g., in the constructor) to change the language for
hilighting purposes (for all verbatim blocks), or disable syntax
hilighting and just make it a preformatted paragraph.  There is a
way to do this in POD (see L</"POD commands specifically for reStructuredText">),
but there should also be an option in the constructor.

=item improve escaping

Text blocks are not escaped properly, so it is currently possible
to invoke a command in reStructuredText by accident.

=back

=head1 DEPENDENCIES

Inherits from L<Pod::POM::View::Text> that comes with the Pod::POM distribution.

=head1 AUTHOR

Don Owens <don@regexguy.com>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2010 Don Owens <don@regexguy.com>.  All rights reserved.

This is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.  See perlartistic.

This program is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE.

=head1 SEE ALSO

L<Pod::POM>

L<Pod::POM::View::HTML>

L<pod2rst> (distributed with Pod::POM::View::HTML)

reStructuredText: L<http://docutils.sourceforge.net/rst.html>

Sphinx (uses reStructuredText): L<http://sphinx.pocoo.org/>

Pygments (used by Sphinx for syntax highlighting): L<http://pygments.org/>

=head1 VERSION

0.02

=cut

1;

# Local Variables: #
# mode: perl #
# tab-width: 4 #
# indent-tabs-mode: nil #
# cperl-indent-level: 4 #
# perl-indent-level: 4 #
# End: #
# vim:set ai si et sta ts=4 sw=4 sts=4:
