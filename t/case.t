#!./perl

#
# $Id: case.t,v 0.1 2001/03/01 18:37:19 ram Exp $
#
#  Copyright (c) 2000-2001, Raphael Manfredi
#  
#  You may redistribute only under the terms of the Artistic License,
#  as specified in the README file that comes with the distribution.
#
# HISTORY
# $Log: case.t,v $
# Revision 0.1  2001/03/01 18:37:19  ram
# Baseline for first alpha release.
#
# $EndLog$
#

print "1..9\n";

require 't/code.pl';
sub ok;

package SENSITIVE;

use Getargs::Long;

sub f {
	my ($x, $X) = getargs(\@_, { -strict => 0 }, qw(x X));
	return ($x, $X);
}

package INSENSITIVE;

use Getargs::Long qw(ignorecase);

sub f {
	my ($x, $Y) = getargs(\@_, { -strict => 0 }, qw(x Y));
	return ($x, $Y);
}

package OPTION;

use Getargs::Long;

sub f {
	my ($x, $Y) = getargs(\@_, { -strict => 0, -ignorecase => 1 }, qw(x Y));
	return ($x, $Y);
}

package main;

my @a;

@a = SENSITIVE::f(-x => 1, -X => 2);
ok 1, @a == 2;
ok 2, $a[0] == 1;
ok 3, $a[1] == 2;

@a = INSENSITIVE::f(-x => 1, -y => 2);
ok 4, @a == 2;
ok 5, $a[0] == 1;
ok 6, $a[1] == 2;

@a = OPTION::f(-x => 1, -y => 2);
ok 7, @a == 2;
ok 8, $a[0] == 1;
ok 9, $a[1] == 2;

