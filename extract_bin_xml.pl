#!/usr/bin/perl
#
# extract_bin_xml
#
#==================================================
#
# Copyright (2015) Francesc Guasch
#
#License Information :
# This software has no warranty, it is provided 'as is'. It is your
# responsibility to validate the behavior of the routines and its accuracy
# using the code provided. Consult the GNU General Public license for further
# details (see GNU General Public License).
# http://www.gnu.org/licenses/gpl.html
# =============================================================================

use warnings;
use strict;

use Data::Dumper;
use MIME::Base64;
use XML::Simple;

my $FILE = $ARGV[0] or die "$0 file.xml [KEY]\n";
my $KEY = ($ARGV[1] or 'document');

sub search {
    my ($xml,$key) = @_;

    return if !ref$xml;

    return search_array($xml, $key) if ref($xml) eq 'ARRAY';

    return $xml->{$key} if exists $xml->{$key};
    for my $l (keys %$xml) {
        my $ret = search($xml->{$l}, $key);
        return $ret if $ret; 
    }
    return;
}

sub search_array {
    my ($xml,$key) = @_;
    for my $l (@$xml) {
        my $ret = search($l,$key);
        return $ret if $ret;
    }
    return;
}

####################################################################3

my $ref = XMLin($FILE) or die "$!";

my $pdf = search($ref,$KEY);
die "I can't find $KEY in $FILE\n" if !$pdf;

my $decoded = decode_base64($pdf);
open my $out ,'>','out' or die $!;
print $out $decoded;
close $out;
print "File 'out' extracted.\n";
