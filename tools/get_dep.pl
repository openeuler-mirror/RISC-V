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
    print $app  . " -bp/dp/br/ba/be/pg app_name\n";
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
    push(@proa, $pvdm);
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

sub _get_pkg_by_provider
{
    my ($pvd) = @_;
    my $mpkg = "unknown";
    my @wild_matches;

    for my $pd (@all_provides) {
        if ($pd =~ /$pvd/) {
            my @pvds = @{$p2pm{$pd}};
            #print Dumper \@pvds;
            $mpkg = $pvds[0];
            #return early for now. by pass the 'multple provider' case.
            return $mpkg;
        }
        if ($pd =~ /($pvd)/) {
            #print "Wildcard match: $pd\n";
            push(@wild_matches, $pd);
        }
    }

    if (scalar(@wild_matches) > 0) {
        my @pvds = @{ $p2pm{$wild_matches[0]} };
        $mpkg = $pvds[0];
        if ($mpkg =~ /-static/) {
            #$mpkg =~ s/-static//;
        }
    }
    return $mpkg;
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
    print "build dependencies:\n";

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
    my @pkgs = keys(%pkg_dep_map);
    my %bdep_count;

    for my $pkg (@pkgs) {
        my %main_pkg = %{ $pkg_dep_map{$pkg} };

        %main_pkg = %{ $main_pkg{'pkgs'} };
        %main_pkg = %{ $main_pkg{$pkg} };

        unless (exists($main_pkg{'bdep'})) {
            #print Dumper \%{ $pkg_dep_map{$pkg} };
            print "- skip $pkg -\n";
            #return;
        } else {
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
        print "Refed " . $sorted_scores[$idx] . " times: $rbdev_map{$sorted_scores[$idx]}[0]\n";
        #print Dumper \@{$rbdev_map{$sorted_scores[$idx]}};
        $idx++;
    }
}

sub __format_str
{
    my ($fstr) = @_;

    $fstr =~ s/\+/\\\+/g;
    $fstr =~ s/\./\\\./g;
    $fstr =~ s/\*/\\\*/g;
    $fstr =~ s/\?/\\\?/g;
    $fstr =~ s/\[/\\\[/g;
    $fstr =~ s/\]/\\\]/g;
    $fstr =~ s/\(/\\\(/g;
    $fstr =~ s/\)/\\\)/g;
    $fstr =~ s/\{/\\\{/g;
    $fstr =~ s/\}/\\\}/g;

    return $fstr;
}

sub _guess_provider
{
    my ($rq) = @_;

    if (exists($p2pm{$rq})) {
        my @pvds = @{$p2pm{$rq}};
        return $pvds[0];
    }

    my $rrq = "unknown";
    my $rrv = "unknown";

    $rq = __format_str($rq);

    if ($rq =~ /(.*)>=(.*)/ or
        $rq =~ /(.*)>(.*)/ or
        $rq =~ /(.*)<=(.*)/ or
        $rq =~ /(.*)<(.*)/ or
        $rq =~ /(.*)=(.*)/) {
        $rrq = $1;
        $rrv = $2;
    } elsif ($rq =~ /^(.*?)($rq)$/) {
        $rrq = "$1$2";
    } else {
        $rrq = $rq;
    }
    
    unless (exists($pkg_rmap{$rrq})) {
        # means No spkg provided the $rrq
        my $spkg = _get_pkg_by_provider($rrq);
        if ($spkg =~ /unknown/) {
            print STDERR "[$rrq] has No provider.\n";
            $rrq = "unknown";
        } else {
            #print "Best try: $spkg\n";
            $rrq = $spkg;
        }
    }

    return $rrq;
}

sub _process_br
{
    my ($pkg) = @_;

    _check_subpkg($pkg);

    my $mpkg = $pkg_rmap{$pkg};
    my %pkg_info = %{$pkg_dep_map{$mpkg}};

    %pkg_info = %{$pkg_info{'pkgs'}};
    %pkg_info = %{$pkg_info{$pkg}};

    unless (exists($pkg_info{bdep})) {
        print STDERR "[$pkg] has NO build deps. Plain data: \n";
        print STDERR Dumper \%pkg_info;
        return ();
    }

    return __get_rdeps(@{$pkg_info{'bdep'}});
}

sub __get_rdeps
{
    my @alldep;
    my %depmap;
    my @queue;
    for my $bd (@_) {
        my $gbd = _guess_provider($bd);
        if ($gbd =~ /unknown/) {
            print STDERR "#0 skipped [$bd]\n";
            next;
        }
        $bd = $gbd;
        $depmap{$bd} = 1;
        push(@queue, $bd);
    }

    print STDERR Dumper \@queue;

    while (scalar @queue > 0) {
        my $h = shift(@queue);
        unless(exists($pkg_dep_map{$h})) {
            my $gh = _guess_provider($h);
            if ($gh =~ /unknown/) {
                print STDERR "skipped [$h]\n";
                next;
            }
            $h = $gh;
        }
        push(@alldep, $h);

        my $mh = $pkg_rmap{$h};
        my %pinfo = %{ $pkg_dep_map{$mh} };
        %pinfo = %{ $pinfo{'pkgs'} };
        %pinfo = %{ $pinfo{$h} };

        for my $nd (@{$pinfo{'rdep'}}) {
            #print "$h (rdep to) -> $nd\n";
            unless (exists($depmap{$nd})) {
                push(@queue, $nd);
                $depmap{$nd} = 1;
            } else {
                $depmap{$nd}++;
            }
        }
        for my $nd (@{$pinfo{'bdep'}}) {
            #print "$h (rdep to) -> $nd\n";
            #$nd =~ s/-devel//g;
            unless (exists($depmap{$nd})) {
                push(@queue, $nd);
                $depmap{$nd} = 1;
            } else {
                $depmap{$nd}++;
            }
        }
    }

    print STDERR "\nThere are [ " . scalar @alldep . " ] deps.\n";
    for my $k (@alldep) {
        my $version = _get_version($k);
        if ($version =~ /unknown/) {
            $version = "";
        } else {
            $version = "-$version";
        }
        print STDERR "$k$version -> " . $depmap{$k} . "\n";
    }

    return @alldep;
}

sub _get_pkg_all_rdep
{
    my (%pkg_info) = @_;
    my @deps = ();

    unless (exists($pkg_info{rdep})) {
        print STDERR "[pkg] has NO runtime deps. Plain data: \n";
        #print Dumper \%pkg_info;
    } else {
        push(@deps, @{$pkg_info{rdep}});
    }
    unless (exists($pkg_info{bdep})) {
        print STDERR "[pkg] has NO build deps. Plain data: \n";
        #print Dumper \%pkg_info;
    } else {
        push(@deps, @{$pkg_info{bdep}});
        for my $brb (@{$pkg_info{bdep}}) {
            if ($brb =~ /^(.*?)-devel/) {
                push(@deps, "$1-libs");
            }
        }
    }

    my @rrdeps = __get_rdeps(@deps);
    my $i = 0;
    while ($i < scalar @rrdeps) {
        if ($rrdeps[$i] =~ /\%\(/) {
            $rrdeps[$i] =~ s/\%\(/\$\(/g;
        }
        $i++;
    }
    return @rrdeps;
}

sub _process_be
{
    my ($pkg) = @_;

    _check_subpkg($pkg);

    my $mpkg = $pkg_rmap{$pkg};
    my %pkg_info = %{$pkg_dep_map{$mpkg}};

    %pkg_info = %{$pkg_info{'pkgs'}};
    %pkg_info = %{$pkg_info{$pkg}};

    return _get_pkg_all_rdep(%pkg_info);
}

sub uniq_merge (@) {
    # From CPAN List::MoreUtils, version 0.22
    my %h;
    map { $h{$_}++ == 0 ? $_ : () } @_;
}

switch($ARGV[0]) {
    case "-h" {
        _print_help($0);
    }
    case "-bp" {
        print "check build req of $ARGV[1], also print the 'provides' of the $ARGV[1]\n";
        resume_data();
        _process_bp($ARGV[1]);
    }
    case "-dp" {
        print "Dump meta data for $ARGV[1].\n";
        resume_data();
        _process_dp($ARGV[1]);
    }
    case "-ba" {
        print "check bdep of all packages then count top 15 pkgs for build env.\n";
        resume_data();
        _process_ba();
    }
    case "-br" {
        print STDERR "Get/provide build environment for $ARGV[1].\n";
        resume_data();
        my @bes = _process_be($ARGV[1]);
        print "------\n";
        for (@bes) {
            print "$_\n";
        }
    }
    case "-be" {
        print STDERR "Get/provide build environment.\n";
        resume_data();
        my @all_pkgs = ("glibc");
        my @fs1_pkgs = _process_be("bash");
        push(@fs1_pkgs, 'bash');
        @all_pkgs = uniq_merge(@all_pkgs, @fs1_pkgs);

        my @fs2_pkgs = _process_be('rpm-build');
        push(@fs2_pkgs, 'rpm-build');
        @all_pkgs = uniq_merge(@all_pkgs, @fs2_pkgs);

        my @fs3_pkgs = _process_be('rpm');
        push(@fs3_pkgs, 'rpm');
        @all_pkgs = uniq_merge(@all_pkgs, @fs3_pkgs);

        print STDERR "\nThe build env should be installed with below packages:\n";
        for my $b (@all_pkgs) {
            print STDOUT " $b ";
        }
        print STDOUT "\n";
    }
    case "-pg" {
        resume_data();
        my $q = $ARGV[1];
        print "guest provider for $q\n";
        print "query: [$q]\n";
        if (exists($p2pm{$q})) {
            print Dumper \@{$p2pm{$ARGV[1]}};
        }
        my $mpkg = _guess_provider(($q));
        if ($mpkg =~ /unknown/) {
            print "Could not find provider for [$q]\n";
        } else {
            print STDERR "mpkg: $mpkg\n";
            #print STDERR Dumper \%{$pkg_dep_map{$pkg_rmap{$mpkg}}};
        }
    }
    else {
        _print_help($0);
    }
}

exit(0);
