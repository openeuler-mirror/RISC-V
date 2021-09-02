#!/usr/bin/env perl
use strict;

use Switch;
use Storable;
use Data::Dumper;

sub _print_help
{
    my ($app) = @_;
    print "Usage:\n";
    print $app  . " -h\n";
    print "  for this help menu.\n";
    print $app  . "-bp app_name\n";
    print "  for example:\n";
    print $app  . " -bp bash\n";
    print "  to fetch dependency of package [bash].\n";
}

#####################################################
my %pkg_dep_map = ();

# the sub-pkg -> pkg pack map.
my %pkg_rmap;

# the reversed build dep map
my %rbdm;

# the provided to pkg-name map
my %p2pm;
my @all_provides;

sub _update_p2pm
{
    my ($pvd, $pvdm) = @_;
    my @proa;
    if (exists($p2pm{$pvd})) {
        @proa = @{ $p2pm{$pvd} };
    } else {
        push(@all_provides, $pvd);
    }
    push(@proa, [ $pvdm]);
    $p2pm{$pvd} = [ @proa ];
}

sub _save_p2pm
{
    my ($fn) = @_;
    open(P2PM, ">$fn") || die "can not open: $fn";
    print P2PM Dumper \%p2pm;
    close(P2PM) || die "error closing file: $fn!";
}

sub resume_data
{
    open DEPS, "<.deps" or die "error reading: $1!";
    {
        local $/;
        no strict;
        %pkg_dep_map = % { eval <DEPS> };
    }
    close(DEPS) or die "error closing file: $1!";

    for my $k (keys(%pkg_dep_map)) {
        my %pkg = %{ $pkg_dep_map{$k} };
        my %pkgs = %{ $pkg{'pkgs'} };
        my @spks = keys(%pkgs);

        for my $sk (@spks) {
            $pkg_rmap{$sk} = $k;
        }

        for my $sk (@spks) {
            _update_p2pm($sk, $sk);
            my %spkg = %{ $pkgs{$sk} };
            if (exists($spkg{provides})) {
                for my $procan (@{ $spkg{provides} }) {
                    _update_p2pm($procan, $sk);
                }
            }
        }

        #_save_p2pm("p2pm");

        # get bdep from 'mpkg'
        my %mpkg = %{ $pkgs{$k} };
        my @bdeps = [];
        if (exists($mpkg{'bdep'})) {
            @bdeps = @{ $mpkg{bdep} };
        }

        for my $bd (@bdeps) {
            my @rbdeps = ();
            if (exists($rbdm{$bd})) {
                @rbdeps = @{ $rbdm{$bd} };
            }
            push(@rbdeps, ($k));
            $rbdm{$bd} = [ @rbdeps ];
        }
    }

=for
    open(DEPS, ">.bdeps") || die "can not open: $1";
    print DEPS Dumper(\%rbdm);
    close(DEPS) || die "error closing file: $1!";
=cut
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

sub _check_subpkg
{
    my ($pkg) = @_;

    unless (exists($pkg_rmap{$pkg})) {
        print "Please make sure the parse_dep.pl has success. And the " .
            $pkg . " is included in openEuler.\n";

        exit 0;
    }
}

sub _process_dp
{
    my ($pkg) = @_;

    _check_subpkg($pkg);
    $pkg = $pkg_rmap{$pkg};

    print "Package: [ $pkg ]\n";
    print Dumper \%{ $pkg_dep_map{$pkg} };
}

sub _process_bp
{
    my ($pkg) = @_;

    unless (exists($pkg_rmap{$pkg})) {
        print "Please make sure the parse_dep.pl has success. And the " .
            $pkg . " is included in openEuler.\n";

        exit 0;
    }

    $pkg = $pkg_rmap{$pkg};
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
}

sub _process_ba
{
    # check bdep of all packages then count top 15 pkgs for build env
    my @pkgs = keys(%pkg_dep_map);
    my %bdep_count;

    for my $pkg (@pkgs) {
        my %main_pkg = %{ $pkg_dep_map{$pkg} };

        %main_pkg = %{ $main_pkg{'pkgs'} };
        %main_pkg = %{ $main_pkg{$pkg} };

        #print Dumper \%main_pkg;
        my @bdeps = @{ $main_pkg{'bdep'} };
        #print Dumper \@bdeps;
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

sub _guess_provider
{
    my ($rq) = @_;

    my $rrq = "unknown";
    my $rrv = "unknown";

    if ($rq =~ /(.*)>=(.*)/) {
        $rrq = $1;
        $rrv = $2;
    } elsif ($rq =~ /(.*)>(.*)/) {
        $rrq = $1;
        $rrv = $2;
    } elsif ($rq =~ /(.*)<=(.*)/) {
        $rrq = $1;
        $rrv = $2;
    } elsif ($rq =~ /(.*)<(.*)/) {
        $rrq = $1;
        $rrv = $2;
    } elsif ($rq =~ /(.*)=(.*)/) {
        $rrq = $1;
        $rrv = $2;
    } else {
        $rrq = $rq;
    }
    
    unless (exists($pkg_rmap{$rrq})) {
        print "[$rrq] has No provider.\n";
        $rrq = "unknown";
    } else {
        $rrq = $pkg_rmap{$rrq};
    }

    return $rrq;
}

sub _process_br
{
    my ($pkg) = @_;

    _check_subpkg($pkg);

    my $mpkg = $pkg_rmap{$pkg};
    my @alldep;
    my %depmap;
    my @queue;
    my %pkg_info = %{$pkg_dep_map{$mpkg}};

    %pkg_info = %{$pkg_info{'pkgs'}};
    %pkg_info = %{$pkg_info{$pkg}};

    unless (exists($pkg_info{bdep})) {
        print "[$pkg] has NO build deps. Plain data: \n";
        print Dumper \%pkg_info;
        exit -2;
    }
    my @rdeps = @{$pkg_info{'bdep'}};

    #Note, the 'rdep' of the specifed pkg also need be *build*.
    for my $_d (@rdeps) {
        $depmap{$_d} = 1;
        push(@queue, ($_d));
    }

    while (scalar @queue > 0) {
        my $h = shift(@queue);
        push(@alldep, ($h));
        #print "$h\n";
        unless(exists($pkg_dep_map{$h})) {
            $h = _guess_provider($h);
            if ($h =~ /unknown/) {
                next;
            }
        }
        my %pinfo = %{ $pkg_dep_map{$h} };
        %pinfo = %{ $pinfo{'pkgs'} };
        %pinfo = %{ $pinfo{$h} };
        for my $nd (@{$pinfo{'rdep'}}) {
            #print "$h (rdep to) -> $nd\n";
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
        if ($version =~ /unknown/) {
            $version = "";
        } else {
            $version = "-$version";
        }
        print "$k$version -> " . $depmap{$k} . "\n";
    }
}

switch($ARGV[0]) {
    case "-h" {
        _print_help($0);
    }
    case "-bp" {
        resume_data();
        _process_bp($ARGV[1]);
    }
    case "-dp" {
        resume_data();
        _process_dp($ARGV[1]);
    }
    case "-ba" {
        resume_data();
        _process_ba();
    }
    case "-br" {
        resume_data();
        _process_br($ARGV[1]);
    }
    else {
        _print_help($0);
    }
}

exit(0);
