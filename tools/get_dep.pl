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
    case "-bp" {
        my $pkg = $ARGV[1];
        if (exists($pkg_dep_map{$pkg})) {
            my %pkg_info = %{$pkg_dep_map{$pkg}};
            %pkg_info = %{$pkg_info{$pkg}};

            print "package: [" . $pkg . "]\n";
            print "version: " . $pkg_info{"version"} . "\n";
            print "build dependenies:\n";

            my @deps;
            @deps = @{$pkg_info{'bdep'}};
            #print Dumper \@deps;
            print "bdep: {\n";
            for my $_dep (@deps) {
                print "\t$_dep\n";
            }
            print "}\n";

            @deps = @{$pkg_info{'rdep'}};
            #print Dumper \@deps;
            print "rdep: {\n";
            for my $_dep (@deps) {
                print "\t$_dep\n";
            }
            print "}\n";
        } else {
            print "Please make sure the parse_dep.pl has success. And the " .
                $pkg . " is in openEuler source repo.\n";
        }
    }
    case "-ba" {
        # check bdep of all packages then count top 10 pkgs for build env
        my @pkgs = keys(%pkg_dep_map);
        my %bdep_count;

        for my $pkg (@pkgs) {
            my %main_pkg = %{$pkg_dep_map{$pkg}};
            %main_pkg = %{$main_pkg{$pkg}};
            #print Dumper \%main_pkg;
            my @bdeps = @{$main_pkg{'bdep'}};
            for my $bd (@bdeps) {
                if (exists($bdep_count{$bd})) {
                    $bdep_count{$bd}++;
                } else {
                    $bdep_count{$bd} = 1;
                }
            }
        }

        my %rbdev_map;
        my @scores;
        for my $rd (keys(%bdep_count)) {
            my @deps;
            my $rkey = $bdep_count{$rd};
            if (exists($rbdev_map{$rkey})) {
                @deps = @{$rbdev_map{$rkey}};
            } else {
                push(@scores, ($rkey));
            }
            push(@deps, ($rd));
            $rbdev_map{$rkey} = [ @deps ];
        }

        my @sorted_scores = sort { $a <=> $b } @scores;
        #print Dumper \@sorted_scores;
        my $idx = scalar @sorted_scores - 1;
        while ($idx >= 0) {
            print "Refed " . $sorted_scores[$idx] . " times:\n";
            print Dumper \@{$rbdev_map{$sorted_scores[$idx]}};
            $idx--;
        }
    }
    case "-br" {
        my $pkg = $ARGV[1];
        my @alldep;
        my %depmap;
        my @queue;
        my %pkg_info = %{$pkg_dep_map{$pkg}};
        %pkg_info = %{$pkg_info{$pkg}};
        my @deps = @{$pkg_info{'bdep'}};

        for my $_d (@deps) {
            $depmap{$_d} = 1;
            push(@queue, ($_d));
        }

        while (scalar @queue > 0) {
            my $h = shift(@queue);
            push(@alldep, ($h));
            #print "$h\n";
            my %pinfo = %{$pkg_dep_map{$h}};
            %pinfo = %{$pinfo{$h}};
            for my $nd (@{$pinfo{'rdep'}}) {
                unless (exists($depmap{$nd})) {
                    push(@queue, ($nd));
                    $depmap{$nd} = 1;
                } else {
                    $depmap{$nd}++;
                }
            }
        }

        print "\nThere are [ " . scalar @alldep . " ] deps.\n";
        for my $k (@alldep) {
            print $k . " -> " . $depmap{$k} . "\n";
        }
    }
    else {
        _print_help($0);
    }
}

exit(0);
