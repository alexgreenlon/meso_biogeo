#!/usr/bin/perl -w

################################################################################################
#
#  Usage: select_from_bam.pl -remove -bam <BAM> -fastq <FASTQ>
#
################################################################################################

use strict;
use Getopt::Long;

my $remove;
my $bam;
my $fastq;

# Listing of possible options
GetOptions(
           'remove'  => \$remove,
           'bam=s'   => \$bam,
           'fastq=s' => \$fastq,
           );

( $bam && $fastq ) or die "\nUsage: select_from_bam.pl -remove -bam <BAM> -fastq <FASTQ>\n\n";

if($bam =~ /\.bam$/) {
   open(IN, "samtools view $bam | ");
} elsif($bam =~ /\.sam$/) {
   open(IN, $bam);
}

my %bam;

while(<IN>) {

   my @line = split(/\t/, $_);

   $bam{$line[0]} = 1;

} close IN;

if($fastq =~ /\.gz$/) {
   open(IN, "gunzip -c $fastq | ");
} else {
   open(IN, $fastq);
}

while(<IN>) {

   $_ =~ /^\@([^\/\s]+)/;

   my $select = 0;

   $select = 1 if($remove && !exists $bam{$1});
   $select = 1 if(!$remove && exists $bam{$1});

   print $_ if($select);

   foreach (1..3) {

	$_ = <IN>;
	print $_ if($select);

   }

} close IN;

