#!/usr/bin/perl

open(my $fl, '>', "runs.sh");

my @list = ("full","line","impline","rand2d","torus","3d");
my @nodes = (100,500,1000);
if (! (-d "runs")){
    print $fl "mkdir runs\n\n";
}

foreach my $top (@list) {
    foreach my $node (@nodes){
	print $fl "mix run lib/project2.ex $node $top gossip > runs/results_gossip_{$node}_$top.log\n";
    }

}

foreach my $top (@list) {
    foreach my $node (@nodes){
	print $fl "mix run lib/project2.ex $node $top push-sum > runs/results_pushsum_{$node}_$top.log\n";
    }
}


close($fl);
