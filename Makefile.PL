#
# $Id: Makefile.PL,v 0.1.1.2 2001/03/20 10:33:58 ram Exp $
#
#  Copyright (c) 2000-2001, Raphael Manfredi
#  
#  You may redistribute only under the terms of the Artistic License,
#  as specified in the README file that comes with the distribution.
#
# HISTORY
# $Log: Makefile.PL,v $
# Revision 0.1.1.2  2001/03/20 10:33:58  ram
# patch3: added warning about interface change
#
# Revision 0.1.1.1  2001/03/15 00:13:33  ram
# patch2: added warning when using perl 5.6.0
#
# Revision 0.1  2001/03/01 18:37:19  ram
# Baseline for first alpha release.
#
# $EndLog$
#

use ExtUtils::MakeMaker;

print <<EOM if $] eq "5.006";

*************************************************
* Will raise a bug in Perl 5.6.0 -- see REAMDE  *
*************************************************

EOM

eval "require Getargs::Long";
print <<EOM if $@ eq "" && $Getargs::Long::VERSION < 0.103;

********************************************************
* WARNING: The interface changed at 0.1.3              *
*          You will need to update your client modules *
********************************************************

EOM

WriteMakefile(
    'NAME'	=> 'Getargs::Long',
    'VERSION_FROM' => 'Long.pm', # finds $VERSION
	'PREREQ_PM' => {
		'Log::Agent'		=> '0.105',
	},
    'LIBS'	=> [''],		# e.g., '-lm' 
    'DEFINE'	=> '',		# e.g., '-DHAVE_SOMETHING' 
    'INC'	=> '',			# e.g., '-I/usr/include/other' 
);

