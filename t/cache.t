#!./perl

#
# $Id: cache.t,v 0.1.1.1 2001/03/20 10:34:45 ram Exp $
#
#  Copyright (c) 2000-2001, Raphael Manfredi
#  
#  You may redistribute only under the terms of the Artistic License,
#  as specified in the README file that comes with the distribution.
#
# HISTORY
# $Log: cache.t,v $
# Revision 0.1.1.1  2001/03/20 10:34:45  ram
# patch3: updated all getargs() calls to new interface
#
# Revision 0.1  2001/03/01 18:37:19  ram
# Baseline for first alpha release.
#
# $EndLog$
#

print "1..17\n";

require 't/code.pl';
sub ok;

## same test case as t/nocache.t, only with c*() routines.

use Getargs::Long qw(ignorecase);

package BAR;

sub make { bless {}, shift }

package FOO;

@ISA = qw(BAR);

package main;

my $FOO = FOO->make;
my $BAR = BAR->make;

sub try {
	my ($x, $y, $z, $t, $o, @other) = cxgetargs(@_,
		{
			-strict => 0,
			-extra => 0,
			-inplace => 1,
		},
		'x'		=>	['i', 1],
		-y		=>	['ARRAY', ['a', 'b']],
		'z'		=>	[],
		't'		=>  ['FOO', $FOO],
		-o 		=>  'i',
	);
	return ([$x, $y, $z, $t, $o], \@other, [@_]);
}

sub tryw {
	my ($x, $y, $l, $z, $t) = cxgetargs(@_,
		'x'		=>	['i'],			# integer, non-mandatory
		'y'		=>	['ARRAY', ['a', 'b']],		# Type, non-mandatory, default
		'l'		=>	[],				# anything, non-mandatory

		'z'		=>	undef,			# anything, mandatory
		't'		=> 'BAR'			# Type, mandatory
	);
	return ($x, $y, $z, $t);
}

my @a;
my ($x, $y, $z, $t);
my @other;
my @args;

@a = try(-o => -2, -t => $FOO, -Other => 2, ONE => 3);
($x, $y, $z, $t, $o) = @{$a[0]};
ok 1, $x == 1;
ok 2, ref $y eq 'ARRAY' && $y->[0] eq 'a';
ok 3, !defined $z;
ok 4, ref $t eq 'FOO';
ok 5, $o == -2;

@other = @{$a[1]};
ok 6, @other == 0;

@args = @{$a[2]};
ok 7, @args == 4;
ok 8, "@args" eq "-Other 2 ONE 3";

eval { try(-t => $FOO) };
ok 9, $@ =~ /\bargument 'o' missing\b/;

@a = try(-o => 1, -z => 'z', y => [], x => 5);
($x, $y, $z, $t, $o) = @{$a[0]};
ok 10, $x == 5;
ok 11, $z eq 'z';
ok 12, ref $y eq 'ARRAY' && @$y == 0;

eval { try(-o => undef, -z => 'z', y => [], x => 5) };
ok 13, $@ =~ /'o' cannot be undef\b/;

eval { tryw(-Z => 'BIG Z', y => [], x => 5) };
ok 14, $@ =~ /\bargument 't' missing\b/;

($x, $y, $z, $t) = tryw(-Z => 'BIG Z', y => [], x => 5, -t => $FOO);
ok 15, ref $t eq 'FOO';

eval { tryw(-T => 1, -Z => 'BIG Z', y => [], x => 5) };
ok 16, $@ =~ /'t' must be of type BAR but/;

eval {
	tryw(-T => $BAR, -Z => 'BIG Z', y => [], x => 5,
		-ExtraArg => 'extra-VALUE')
};
ok 17, $@ =~ /\bswitch: -extraarg\b/;

