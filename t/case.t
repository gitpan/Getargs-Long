#!./perl

#
# $Id: case.t,v 1.1.1.1 2004/09/22 17:32:58 coppit Exp $
#
#  Copyright (c) 2000-2001, Raphael Manfredi
#  
#  You may redistribute only under the terms of the Artistic License,
#  as specified in the README file that comes with the distribution.
#
# HISTORY
# $Log: case.t,v $
# Revision 1.1.1.1  2004/09/22 17:32:58  coppit
# initial import
#
# Revision 0.1.1.1  2001/03/20 10:34:48  ram
# patch3: updated all getargs() calls to new interface
#
# Revision 0.1  2001/03/01 18:37:19  ram
# Baseline for first alpha release.
#
# $EndLog$
#

use Test::More tests => 9;

require 't/code.pl';

package SENSITIVE;

use Getargs::Long;

sub f {
	my ($x, $X) = getargs(@_, { -strict => 0 }, qw(x X));
	return ($x, $X);
}

package INSENSITIVE;

use Getargs::Long qw(ignorecase);

sub f {
	my ($x, $Y) = getargs(@_, { -strict => 0 }, qw(x Y));
	return ($x, $Y);
}

package OPTION;

use Getargs::Long;

sub f {
	my ($x, $Y) = getargs(@_, { -strict => 0, -ignorecase => 1 }, qw(x Y));
	return ($x, $Y);
}

package main;

my @a;

@a = SENSITIVE::f(-x => 1, -X => 2);
is(@a,2);
is($a[0],1);
is($a[1],2);

@a = INSENSITIVE::f(-x => 1, -y => 2);
is(@a,2);
is($a[0],1);
is($a[1],2);

@a = OPTION::f(-x => 1, -y => 2);
is(@a,2);
is($a[0],1);
is($a[1],2);

