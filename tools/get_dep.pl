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

my %pkg_rmap;
for my $k (keys(%pkg_dep_map)) {
    my %pkg = %{ $pkg_dep_map{$k} };
    my %pkgs = %{ $pkg{'pkgs'} };

    for my $sk (keys(%pkgs)) {
        $pkg_rmap{$sk} = $k;
    }
}

sub _get_version
{
    my ($k) = @_;
    my $version = "unknown";

    if (exists($pkg_rmap{$k})) {
        my $pn = $pkg_rmap{$k};
        my %pkg = %{ $pkg_dep_map{$pn} };
        my %pinfo = %{ $pkg{'info'} };
        #print Dumper \%pinfo;
        $version = $pinfo{'version'};
    }

    return $version;
}

switch($ARGV[0]) {
    case "-h" {
        _print_help($0);
        exit(0);
    }
    case "-bp" {
        my $pkg = $ARGV[1];
        if (exists($pkg_dep_map{$pkg})) {
            my %pkg_info = %{ $pkg_dep_map{$pkg} };
            %pkg_info = %{ $pkg_info{'info'} };

            print "package: [" . $pkg . "]\n";
            print "version: " . $pkg_info{"version"} . "\n";
            print "build dependenies:\n";

            %pkg_info = %{ $pkg_dep_map{$pkg} };
            %pkg_info = %{ $pkg_info{'pkgs'} };
            %pkg_info = %{ $pkg_info{$pkg} };

            my @bdeps = @{$pkg_info{'bdep'}};
            #print Dumper \@bdeps;
            print "bdep: {\n";
            for my $_dep (@bdeps) {
                print "\t$_dep\n";
            }
            print "}\n";

            my @rdeps = @{$pkg_info{'rdep'}};
            #print Dumper \@rdeps;
            print "rdep: {\n";
            for my $_dep (@rdeps) {
                print "\t$_dep\n";
            }
            print "}\n";

            my @provides = @{$pkg_info{'provides'}};
            #print Dumper \@deps;
            print "provides: {\n";
            for my $_prov (@provides) {
                print "\t$_prov\n";
            }
            print "}\n";
        } else {
            print "Please make sure the parse_dep.pl has success. And the " .
                $pkg . " is in openEuler source repo.\n";
        }
    }
    case "-ba" {
        # check bdep of all packages then count top 15 pkgs for build env
        my @pkgs = keys(%pkg_dep_map);
        my %bdep_count;

        for my $pkg (@pkgs) {
            my %main_pkg = %{$pkg_dep_map{$pkg}};
            %main_pkg = %{ $main_pkg{'pkgs'} };
            %main_pkg = %{ $main_pkg{$pkg} };
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

        my @sorted_scores = sort { $b <=> $a } @scores;
        #print Dumper \@sorted_scores;
        my $max_idx = scalar @sorted_scores - 1;
        my $idx = 0;
        while ($idx <= $max_idx and $idx < 15) {
            print "Refed " . $sorted_scores[$idx] . " times:\n";
            print Dumper \@{$rbdev_map{$sorted_scores[$idx]}};
            $idx++;
        }
    }
    case "-br" {
        my $pkg = $ARGV[1];
        unless (exists($pkg_rmap{$pkg})) {
            print "$pkg is not valid.\n";
            exit 0;
        } else {
            $pkg = $pkg_rmap{$pkg};
        }

        my @alldep;
        my %depmap;
        my @queue;
        my %pkg_info = %{$pkg_dep_map{$pkg}};
        %pkg_info = %{$pkg_info{'pkgs'}};
        %pkg_info = %{$pkg_info{$pkg}};

        my @rdeps = @{$pkg_info{'bdep'}};
=for
        Note, the 'rdep' of the specifed pkg also need be *build*.
=cut
        for my $_d (@rdeps) {
            $depmap{$_d} = 1;
            push(@queue, ($_d));
        }

        while (scalar @queue > 0) {
            my $h = shift(@queue);
            push(@alldep, ($h));
            #print "$h\n";
            my %pinfo = %{$pkg_dep_map{$h}};
            %pinfo = %{$pinfo{'pkgs'}};
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
            my $version = _get_version($k);
            print "$k-$version -> " . $depmap{$k} . "\n";
        }
    }
    else {
        _print_help($0);
    }
}

exit(0);
