#!/usr/bin/perl

use strict;
use inc::Module::Install;

die "This module is known to exercise a bug in 5.6.0. Please upgrade your perl.\n"
  if $] eq '5.006';

Check_Custom_Installation();

print "\n", '-'x78, "\n\n";

name            ('Getargs-Long');
author          ('David Coppit <david@coppit.org>');
abstract_from   ('lib/Getargs/Long.pm');
version_from    ('lib/Getargs/Long.pm');
license         ('gpl');

requires        (
                  'Log::Agent' => '0.105',
                );

include         ('ExtUtils/AutoInstall.pm');
auto_install    ( -default => 0 );

WriteAll();

print "\n", '-'x78, "\n\n";

exit;
