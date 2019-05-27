#!/usr/bin/perl -w

################################################################################################
#
#  Usage: set_batch <clean> <trimmomatic> <EC> <A5> <SPADES> <velvet> <trinity> <CAP3>
#
#                   -readfolder <readfolder>
#                   -reference_dirty <reference_dirty> -reference_clean <reference_clean>
#
#                   -ppn <ppn> -mem <mem> -vmem <vmem>
#
#                   -help
#
################################################################################################

use strict;
use Getopt::Long;

my $readfolder = "";
my $reference_dirty = "/panfs/cmb-panasas2/peterc/rawdata/chickpea/genome/CDCFrontier_GA_v1.0/CDCFrontier_GA_v1.0.fa";
my $reference_clean = "/staging/sn1/peterc/SOL_MESORHIZOBIA/rawdata/genome/nod-and-culture.meso-db.concat.fasta";
my $ppn = 6;
my $mem = "12000mb";
my $pmem;
my $vmem;

my $help;

# Listing of possible options
GetOptions(
           'readfolder=s'      => \$readfolder,
           'reference_dirty=s' => \$reference_dirty,
           'reference_clean=s' => \$reference_clean,
           'ppn=s'             => \$ppn,
           'mem=s'             => \$mem,
           'vmem=s'            => \$vmem,
           'help'              => \$help,
          );

die "
#  Usage: set_batch <clean> <trimmomatic> <EC> <A5> <SPADES> <velvet> <trinity> <CAP3>
#
#                   -readfolder <readfolder>
#                   -reference_dirty <reference_dirty> -reference_clean <reference_clean>
#
#                   -ppn <ppn> -mem <mem> -vmem <vmem>
#
#                   -help
#

" if($help);

my %ARGV;
$ARGV{$_} = 1 foreach (@ARGV);

my $pwd = `pwd`;
chomp $pwd;
$pwd =~ s/\/auto/\/home/;

$mem = 2000*$ppn . "mb" unless($mem);
$pmem = "2000mb" unless($pmem);
$vmem = $mem unless($vmem);

$readfolder = "$pwd/$readfolder" unless($readfolder =~ /^\//);

open(BATCH, ">run.sh");

my @readfile = `ls $readfolder/*.txt*`; chomp @readfile;

for(my $i=0; $i<=$#readfile; $i++) {

   my $base = $readfile[$i];

   $base = $1 if($readfile[$i] =~ /([^\/]+)((.txt)|(.fasta))/);

   my $PE = 0;
   if($base =~ /\.1$/ && $readfile[$i+1] =~ /\.2.txt/) {
	$base =~ s/\.1$//;
	$PE = 1;
   }

   my $SE = "";

   open(OUT, ">$base.assembly.sh");

   print OUT "#!/bin/tcsh\n";
   print OUT "#PBS -l walltime=300:00:00\n";
   print OUT "#PBS -l nodes=1:ppn=$ppn\n";
   print OUT "#PBS -l mem=$mem,pmem=$pmem,vmem=$vmem\n";
   print OUT "#PBS -q cegs\n\n";

   print OUT "setenv HOME /home/cmb-07/sn1/peterc\n\n";

   if(exists $ARGV{clean} && $reference_dirty) {

	print OUT "mkdir -p $pwd/$base/trimmomatic\n";
	print OUT "cd $pwd/$base/trimmomatic\n\n";

	if($PE) {

		print OUT "bwa aln -t $ppn -n 8 -f $base.1 $reference_dirty $readfile[$i]\n";
		print OUT "bwa aln -t $ppn -n 8 -f $base.2 $reference_dirty $readfile[$i+1]\n";
		print OUT "bwa sampe $reference_dirty $base.1 $base.2 $readfile[$i] $readfile[$i+1] | awk '\$3!=\"*\"' | samtools view -bS -o $base.mapped_to_dirty.bam -\n";
		print OUT "rm $base.1 $base.2\n\n";

		print OUT "perl ~/bin/sam/select_from_bam.pl -remove -bam $base.mapped_to_dirty.bam -fastq $readfile[$i] | gzip > $base.cleaned.1.fastq.gz\n";
		print OUT "perl ~/bin/sam/select_from_bam.pl -remove -bam $base.mapped_to_dirty.bam -fastq $readfile[$i+1] | gzip > $base.cleaned.2.fastq.gz\n\n";

		$readfile[$i]   = "$pwd/$base/trimmomatic/$base.cleaned.1.fastq.gz";
		$readfile[$i+1] = "$pwd/$base/trimmomatic/$base.cleaned.2.fastq.gz";

	} else {

		print OUT "bwa aln -t $ppn -n 8 $reference_dirty $readfile[$i] | bwa samse $reference_dirty - $readfile[$i] | awk '\$3!=\"*\"' | samtools view -bS -o $base.mapped_to_dirty.bam -\n\n";

		print OUT "perl ~/bin/sam/select_from_bam.pl -remove -bam $base.mapped_to_dirty.bam -fastq $readfile[$i] | gzip > $base.cleaned.fastq.gz\n\n";

		$readfile[$i] = "$pwd/$base/trimmomatic/$base.cleaned.fastq.gz";

	}	

   }

   if(exists $ARGV{trimmomatic}) {

	print OUT "mkdir -p $pwd/$base/trimmomatic\n";
	print OUT "cd $pwd/$base/trimmomatic\n\n";

	if($PE) {

		print OUT "java -jar ~/bin/trimmomatic-0.32/trimmomatic-0.32.jar PE -threads $ppn -phred33 $readfile[$i] $readfile[$i+1] $base.trimmed.PE.1.fastq $base.trimmed.SE.1.fastq $base.trimmed.PE.2.fastq $base.trimmed.SE.2.fastq ILLUMINACLIP:/home/cmb-07/sn1/peterc/bin/trimmomatic-0.32/adapters/adapters.fa:1:30:10 LEADING:30 TRAILING:30 SLIDINGWINDOW:24:30 MINLEN:72\n";
		print OUT "cat $base.trimmed.SE.1.fastq $base.trimmed.SE.2.fastq > $base.trimmed.SE.fastq\n";
		print OUT "rm $base.trimmed.SE.1.fastq $base.trimmed.SE.2.fastq\n";

		$readfile[$i]   = "$pwd/$base/trimmomatic/$base.trimmed.PE.1.fastq.gz";
		$readfile[$i+1] = "$pwd/$base/trimmomatic/$base.trimmed.PE.2.fastq.gz";
		$SE = "$pwd/$base/trimmomatic/$base.trimmed.SE.fastq.gz";

	} else {

		print OUT "java -jar ~/bin/trimmomatic-0.32/trimmomatic-0.32.jar SE -threads $ppn -phred33 $readfile[$i] $base.trimmed.fastq ILLUMINACLIP:/home/cmb-07/sn1/peterc/bin/trimmomatic-0.32/adapters/adapters.fa:1:30:10 LEADING:30 TRAILING:30 SLIDINGWINDOW:24:30 MINLEN:72\n";

		$readfile[$i] = "$pwd/$base/trimmomatic/$base.trimmed.fastq.gz";

	}

	print OUT "gzip *fastq\n\n";

   }

   if(exists $ARGV{EC}) {

	print OUT "mkdir -p $pwd/$base/EC\n";
	print OUT "cd $pwd/$base/EC\n\n";

	print OUT "perl ~/bin/allpathslg-44837/bin/ErrorCorrectReads.pl PHRED_ENCODING=33 THREADS=$ppn KEEP_KMER_SPECTRA=1 READS_OUT=$base \\\n";

	if($PE) {

		print OUT "UNPAIRED_READS_IN=$SE \\\n" if($SE);
		print OUT "PAIRED_READS_A_IN=$readfile[$i] \\\n";
		print OUT "PAIRED_READS_B_IN=$readfile[$i+1]\n";

		print OUT "rm $base.fastq\n";

		$readfile[$i]   = "$pwd/$base/EC/$base.paired.A.fastq.gz";
		$readfile[$i+1] = "$pwd/$base/EC/$base.paired.B.fastq.gz";
		$SE = "$pwd/$base/EC/$base.unpaired.fastq.gz";

	} else {

		print OUT "UNPAIRED_READS_IN=$readfile[$i]\n";

		$readfile[$i] = "$pwd/$base/EC/$base.fastq.gz";

	}

	print OUT "gzip *fastq\n\n";

   }

   print OUT "mkdir -p $pwd/$base/VelvetOptimiser\n";
   print OUT "cd $pwd/$base/VelvetOptimiser\n\n";

   print OUT "foreach k (`seq 21 2 75`)\n\n";
   print OUT "   perl ~/bin/velvet_1.2.10/contrib/VelvetOptimiser-2.2.4/VelvetOptimiser.pl --t $ppn --s \$k --e \$k --p VelvetOptimiser_\$k --d VelvetOptimiser_\$k -f '-fastq.gz -shortPaired $pwd/$base/trimmomatic/$base.trimmed.cleaned.PE.fastq.gz -short $pwd/$base/trimmomatic/$base.trimmed.cleaned.SE1.fastq.gz $pwd/$base/trimmomatic/$base.trimmed.cleaned.SE2.fastq.gz' -o '-min_contig_lgth 300'\n";
   print OUT "   mv VelvetOptimiser_\$k/VelvetOptimiser_*_logfile.fastq .\n";
   print OUT "   rm -rf VelvetOptimiser_\$k VelvetOptimiser_*data*\n\n";
   print OUT "end\n\n";

   print OUT "perl ~/bin/symbiosis/optimise_VelvetOptimiser.pl\n\n";

   print OUT "set kmer = `ls kmer_* | sed 's/kmer_//'`\n";
   print OUT "set gapl = `ls length_* | sed 's/length_//'`\n\n";

   print OUT "cd $pwd/$base\n\n";

   print OUT "~/bin/velvet_1.2.10/velveth metavelvet1 \$kmer -fastq.gz -shortPaired -separate $readfile[$i] $readfile[$i+1] ";
   print OUT "-short $SE" if($SE);
   print OUT "\n~/bin/velvet_1.2.10/velvetg metavelvet1 -exp_cov auto\n";
   print OUT "~/bin/MetaVelvet-1.2.02/meta-velvetg metavelvet1\n";
   print OUT "rm -f metavelvet1/contigs.fa metavelvet1/stats.fastq metavelvet1/Sequences metavelvet1/Roadmaps metavelvet1/Graph* metavelvet1/*Graph\n\n";

   print OUT "set cov = `python ~/bin/symbiosis/scriptEstimatedCovMulti.py metavelvet1/meta-velvetg.Graph2-stats.txt | tail -n 1`\n";
   print OUT "touch metavelvet1/cov_\$cov\n\n";

   print OUT "~/bin/velvet_1.2.10/velveth metavelvet2 \$kmer -fastq.gz -shortPaired -separate $readfile[$i] $readfile[$i+1] ";
   print OUT "-short $SE" if($SE);
   print OUT "\n~/bin/velvet_1.2.10/velvetg metavelvet2 -exp_cov auto\n";
   print OUT "~/bin/MetaVelvet-1.2.02/meta-velvetg metavelvet2 -exp_covs \$cov -valid_connections 0 -noise_connections 0\n";
   print OUT "rm -f metavelvet2/contigs.fa metavelvet2/stats.fastq metavelvet2/Sequences metavelvet2/Roadmaps metavelvet2/Graph* metavelvet2/*Graph\n\n";

   print OUT "mkdir -p $pwd/$base/blast\n";
   print OUT "cd $pwd/$base/blast\n\n";

   print OUT "~/bin/ncbi-blast-2.2.30+/bin/blastn -db $reference_clean -query $pwd/$base/metavelvet2/meta-velvetg.contigs.fa -evalue 1e-5 -num_threads $ppn -out $base.blastout6 -outfmt '6 qseqid qlen qstart qend sseqid slen sstart send length pident bitscore evalue'\n";

   print OUT "perl ~/bin/blast/select_from_blastout6.pl -blastout $base.blastout6 -fasta $pwd/$base/metavelvet2/meta-velvetg.contigs.fa > $base.blastout6.fa\n\n";

   print OUT "bwa index $base.blastout6.fa\n";
   print OUT "bwa aln -t $ppn -n 8 -f $base.1 $base.blastout6.fa $readfile[$i]\n";
   print OUT "bwa aln -t $ppn -n 8 -f $base.2 $base.blastout6.fa $readfile[$i+1]\n";
   print OUT "bwa sampe $base.blastout6.fa $base.1 $base.2 $readfile[$i] $readfile[$i+1] | awk '\$3!=\"*\"' | samtools view -bS -o $base.blastout6.fa.PE.bam -\n";
   print OUT "bwa aln -t $ppn -n 8 $base.blastout6.fa $SE | bwa samse $base.blastout6.fa - $SE | awk '\$3!=\"*\"' | samtools view -bS -o $base.blastout6.fa.SE.bam -\n" if($SE);
   print OUT "rm $base.1 $base.2\n\n";

   print OUT "perl ~/bin/sam/select_from_bam.pl -bam $base.blastout6.fa.PE.bam -fastq $readfile[$i] | gzip > $base.blastout6.fa.PE.1.fastq.gz\n";
   print OUT "perl ~/bin/sam/select_from_bam.pl -bam $base.blastout6.fa.PE.bam -fastq $readfile[$i+1] | gzip > $base.blastout6.fa.PE.2.fastq.gz\n";
   print OUT "perl ~/bin/sam/select_from_bam.pl -bam $base.blastout6.fa.SE.bam -fastq $SE | gzip > $base.blastout6.fa.SE.fastq.gz\n" if($SE);

   $readfile[$i] = "$pwd/$base/blast/$base.blastout6.fa.PE.1.fastq.gz";
   $readfile[$i+1]= "$pwd/$base/blast/$base.blastout6.fa.PE.2.fastq.gz";
   $SE = "$pwd/$base/blast/$base.blastout6.fa.SE.fastq.gz" if($SE);

   print OUT "rm *.fa.?? *.fa.???\n\n";

   if(exists $ARGV{A5}) {

	print OUT "mkdir -p $pwd/$base/A5\n";
	print OUT "cd $pwd/$base/A5\n\n";

	print OUT "touch $base.lib\n";
	print OUT "echo \"[LIB]\" >> $base.lib\n";
	print OUT "echo \"p1=$readfile[$i]\" >> $base.lib\n";
	print OUT "echo \"p2=$readfile[$i+1]\" >> $base.lib\n";
	print OUT "echo \"[LIB]\" >> $base.lib\n" if($SE);
	print OUT "echo \"up=$SE\" >> $base.lib\n\n" if($SE);

	print OUT "~/bin/A5_miseq_linux_20160825/bin/a5_pipeline.pl --end=5 $base.lib $base\n\n";

#	print OUT "~/bin/A5_linux-x64_20130326/bin/a5_pipeline.pl $base.lib $base\n\n";

	print OUT "rm $pwd/$base/blast/*a5unzipped*\n\n";

	print OUT "mv $pwd/$base/A5 $pwd/$base/A5_old\n";
	print OUT "mkdir $pwd/$base/A5\n";
	print OUT "mv $pwd/$base/A5_old/*fasta $pwd/$base/A5\n";
	print OUT "rm -rf $pwd/$base/A5_old\n\n";

   }

   if(exists $ARGV{SPADES}) {

	print OUT "mkdir -p $pwd/$base/SPADES\n";
	print OUT "cd $pwd/$base/SPADES\n\n";

	$mem =~ /000mb/;

	print OUT "python /home/cmb-07/sn1/peterc/bin/SPAdes-3.11.0-Linux/bin/spades.py --careful -t $ppn -m $` -o $pwd/$base/SPADES \\\n";
	print OUT "--s1 $SE \\\n" if($SE);
	print OUT "--pe1-1 $readfile[$i] \\\n";
	print OUT "--pe1-2 $readfile[$i+1]\n\n";

   }

   close OUT;

   print BATCH "qsub $pwd/$base.assembly.sh\n";
   `chmod 755 $pwd/$base.assembly.sh`;

   $i++ if($PE);

}

close BATCH;
`chmod 755 run.sh`;

