#!/usr/bin/perl -w

################################################################################################
#
#  Usage: select_from_blastout6.pl -remove -blastout6 <BLASTOUT6> -fasta <FASTA> -percent_cutoff <percent> -absspan_cutoff <absspan>
#
################################################################################################

use strict;
use Getopt::Long;

use FASTA;

my $remove;
my $blastout6;
my $fasta;
my $percent = 95;
my $absspan = 250;

# Listing of possible options
GetOptions(
           'remove'      => \$remove,
           'blastout6=s' => \$blastout6,
           'fasta=s'     => \$fasta,
           'percent=s'   => \$percent,
           'absspan=s'   => \$absspan,
           );

( $blastout6 && $fasta ) or die "\nUsage: select_from_blastout6.pl -remove -blastout6 <BLASTOUT6> -fasta <FASTA> -percent_cutoff <percent> -absspan_cutoff <absspan>\n\n";

open(IN, $blastout6);

my %blastout6;

while(<IN>) {

   my @line = split(/\t/, $_);

   next if($line[9] < $percent);
   next if($line[8] < $absspan);

   $blastout6{$line[0]} = 1;

} close IN;

my %reference = FASTA::open_fasta($fasta);

foreach my $chr (keys %reference) {

   if(($remove && !exists $blastout6{$chr}) || (!$remove && exists $blastout6{$chr})) {

	$reference{$chr} =~ s/.{1,100}/$&\n/g;

        print ">$chr\n$reference{$chr}";

   }

}

