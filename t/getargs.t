#!./perl

#
# $Id: getargs.t,v 0.1.1.1 2001/03/20 10:34:49 ram Exp $
#
#  Copyright (c) 2000-2001, Raphael Manfredi
#  
#  You may redistribute only under the terms of the Artistic License,
#  as specified in the README file that comes with the distribution.
#
# HISTORY
# $Log: getargs.t,v $
# Revision 0.1.1.1  2001/03/20 10:34:49  ram
# patch3: updated all getargs() calls to new interface
#
# Revision 0.1  2001/03/01 18:37:19  ram
# Baseline for first alpha release.
#
# $EndLog$
#

print "1..12\n";

require 't/code.pl';
sub ok;

use Getargs::Long;

package BAR;

sub make { bless {}, shift }

package FOO;

@ISA = qw(BAR);

package main;

my $FOO = FOO->make;
my $BAR = BAR->make;

sub try {
	my ($x, $y, $z, $t) = getargs(@_, qw(x=i y=ARRAY z t=FOO));
	return ($x, $y, $z, $t);
}

sub tryw {
	my ($x, $y, $z, $t) = getargs(@_, [qw(x=i y=ARRAY z t=FOO)]);
	return ($x, $y, $z, $t);
}

my ($x, $y, $z, $t);

eval { try(-x => -2, -t => $FOO, -Other => 1, -y => [], -z => undef) };
ok 1, $@ =~ /switch: -Other\b/;

eval { try(-x => -2, -t => $FOO, -Y => [], -z => undef) };
ok 2, $@ =~ /\bargument 'y' missing\b/;

($x, $y, $z, $t) = try(-x => -2, -t => $FOO, -y => [qw(A C)], -z => undef);
ok 3, $x == -2;
ok 4, ref $y eq 'ARRAY' && $y->[1] eq 'C';
ok 5, !defined $z;
ok 6, ref $t eq 'FOO';

eval { tryw(-x => -2, -t => $FOO, -Other => 1, -y => [], -z => undef) };
ok 7, $@ =~ /switch: -Other\b/;

eval { tryw(-x => -2, -t => $FOO, -Y => [], -z => undef) };
ok 8, $@ =~ /switch: -Y\b/;

($x, $y, $z, $t) = tryw(-t => $FOO, -z => []);
ok 9, !defined $x;
ok 10, !defined $y;
ok 11, ref $z eq 'ARRAY';
ok 12, ref $t eq ref $FOO;

