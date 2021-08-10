#!/usr/bin/env perl
#use strict;

use Switch;
use Storable;
use Data::Dumper;

sub _print_help
{
    my ($app) = @_;
    print "Usage:\n";
    print $app  . " -h\n";
    print "  for this help menu.\n";
    print $app  . "-p app_name\n";
    print "  for example:\n";
    print $app  . " -p bash\n";
    print "  to fetch dependency of package [bash].\n";
}

#####################################################
my %pkg_dep_map;
open DEPS, "<.deps" or die "error reading: $1!";
{
    local $/;
    %pkg_dep_map = % { eval <DEPS> };
}
close(DEPS) or die "error closing file: $1!";

switch($ARGV[0]) {
    case "-h" {
        _print_help($0);
        exit(0);
    }
    case "-p" {
        my $pkg = $ARGV[1];
        if (exists($pkg_dep_map{$pkg})) {
            my %pkg_info = %{$pkg_dep_map{$pkg}};

            print "package: [" . $pkg . "]\n";
            print "version: " . $pkg_info{"version"} . "\n";
            print "build dependenies:\n";

            my @deps = @{$pkg_info{'bdep'}};
            #print "@{$pkg_info{'bdep'}}";
            print "{\n";
            for my $_dep (@deps) {
                print "\t$_dep\n";
            }
            print "}\n";
        } else {
            print "Please make sure the parse_dep.pl has success. And the " .
                $pkg . " is in openEuler source repo.\n";
        }
    }
    else {
        _print_help($0);
    }
}

exit(0);
