## Scripts related to manuscript Greenlon et al., 2019, PNAS (hopefully)

## Mesorhizobium culture libraries:
### Read trimming:
```
mkdir results/trimmomatic/"$SAMPLE"

java -jar bin/Trimmomatic-0.36/trimmomatic-0.36.jar PE -phred33 \
data/atsede-redo-libs/"$SAMPLE"_L006_R1_001.fastq.gz \
data/atsede-redo-libs/"$SAMPLE"_L006_R2_001.fastq.gz \
results/trimmomatic/"$SAMPLE"/"$SAMPLE".R1.paired.fastq.gz \
results/trimmomatic/"$SAMPLE"/"$SAMPLE".R1.unpaired.fastq.gz \
results/trimmomatic/"$SAMPLE"/"$SAMPLE".R2.paired.fastq.gz \
results/trimmomatic/"$SAMPLE"/"$SAMPLE".R2.unpaired.fastq.gz \
ILLUMINACLIP:bin/Trimmomatic-0.36/adapters/NexteraPE-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
```
### Assembly:
```
./bin/SPAdes-3.10.1-Linux/bin/spades.py --careful --pe1-1 results/trimmomatic/"$SAMPLE"/"$SAMPLE".R1.paired.fastq.gz --pe1-2 results/trimmomatic/"$SAMPLE"/"$SAMPLE".R2.paired.fastq.gz --s1 results/trimmomatic/"$SAMPLE"/"$SAMPLE".R1.unpaired.fastq.gz --s2 results/trimmomatic/"$SAMPLE"/"$SAMPLE".R2.unpaired.fastq.gz -o results/spades-assemblies/"$SAMPLE"
```

## Pacbio libraries:
### HGAP:
Write a list of input file names to a single file
```
ls *.bax.h5 >input_"$SAMPLE".fofn
```
Convert this fofn file to xml format
```
fofnToSmrtpipeInput.py input_"$SAMPLE".fofn >input.xml
```
Add a copy of the settings.xml file to folder. This can be obtained through smrtportal (an empty job can be run, then by looking under userdata/jobs … one can fetch the settings.xml file)

Run HGAP
```
smrtpipe.py -D TMP=./ -D SHARED_DIR=./ -D NPROC=16 -D MAX_THREADS=16 --params=setting_Alexs.xml xml:input.xml >smrtpipe.out 2>&1
```
### Miniasm:
Run minimap to map (fastq-formatted) PacBio reads to itself
```
minimap -Sw5 -L100 -m 0 -t 24  "$SAMPLE".fastq | gzip -1 >reads_"$SAMPLE".paf.gz
```
Run miniasm 
```
miniasm -f data/Hyd7_L2.fastq reads_"$SAMPLE".paf.gz >asm_"$SAMPLE".gfa
```
### [CAMSA](https://github.com/compbiol/CAMSA):
Create consensus assembly from two PacBio-only contigs (from HGAP and MiniASM) and Illumina-only scaffolds for the same strain. 

First requires running a multiple-sequence aligment of each of the assemblies using [progressiveCactus](https://github.com/glennhickey/progressiveCactus). ProgressiveCactus takes as input a tab-delimited file that gives the name for each assembly and the path to the fasta-formatted assembly file (`"$SAMPLE".paths.txt` in the example below):
```
bin/runProgressiveCactus.sh /home/agreensp/chickpea-rhizo-geo-div/sequencing/data/pacbio/"$SAMPLE"/"$SAMPLE".paths.txt /home/agreensp/chickpea-rhizo-geo-div/sequencing/data/pacbio/"$SAMPLE"/progressiveCactus.2.24.17 /home/agreensp/chickpea-rhizo-geo-div/sequencing/data/pacbio/"$SAMPLE"/progressiveCactus.2.24.17/"$SAMPLE".hal
hal2mafMP.py /home/agreensp/chickpea-rhizo-geo-div/sequencing/data/pacbio/"$SAMPLE"/progressiveCactus.2.24.17/"$SAMPLE".hal /home/agreensp/chickpea-rhizo-geo-div/sequencing/data/pacbio/"$SAMPLE"/progressiveCactus.2.24.17/"$SAMPLE".hal.maf
```

Then to run camsa to create consensus assembly:
```
./bin/ragout-1.2-macosx-x86_64/lib/ragout-maf2synteny -o data/pacbio/camsa/"$SAMPLE"/"$SAMPLE".maf2synteny data/pacbio/camsa/"$SAMPLE"/"$SAMPLE".hal.maf
ragout_coords2camsa_points.py data/pacbio/camsa/"$SAMPLE"/"$SAMPLE".maf2synteny/5000/blocks_coords.txt --bad-genomes "Anc0" -o data/pacbio/camsa/"$SAMPLE"/"$SAMPLE".camsa.points
ragout_coords2camsa_seqi.patch.py data/pacbio/camsa/"$SAMPLE"/"$SAMPLE".maf2synteny/5000/blocks_coords.txt --bad-genomes "Anc0" -o data/pacbio/camsa/"$SAMPLE"/"$SAMPLE".camsa.seqi --genomes-order "hgap,miniasm,illumina"
run_camsa.py -o data/pacbio/camsa/"$SAMPLE"/"$SAMPLE".camsa data/pacbio/camsa/"$SAMPLE"/"$SAMPLE".camsa.points
camsa_points2fasta.py  --points data/pacbio/camsa/"$SAMPLE"/"$SAMPLE".camsa/merged/merged.camsa.points --seqi data/pacbio/camsa/"$SAMPLE"/"$SAMPLE".camsa.seqi --fasta data/pacbio/camsa/"$SAMPLE"/"$SAMPLE".hgap-miniasm-illumina.fasta --fill-gaps --extend-ends -o data/pacbio/camsa/"$SAMPLE"/"$SAMPLE".merged.fasta
```
## Nodule-DNA libraries:
### Metagenomic assembly pipeline:
Requires `scriptEstimatedCovMulti.py`, `select_from_bam.pl`, and `select_from_blastout6.pl` (found in scripts directory of this repo). Written to submit jobs to a computing cluster with PBS. 

`.scripts/nodule-metagenome-wrapper.pl`

## All geneome assemblies:
### Annotation:
```
prokka --kingdom Bacteria --outdir data/gene-predictions/prokka.1.13/"$SAMPLE" --locustag $SEED --prefix $SEED results/spades-assemblies/"$SAMPLE"/scaffolds.fasta
```
### Phylophlan:
Where `bin/phylophlan/species-tree/` contains prokka faa's of genomes to be included in phylogeny.
```
cd bin/phylophlan/
./phylophlan.py -u species-tree --nproc 4
```
### Pangenome:
```
roary -i 90 -p 24 -f results/pangenome/roary/all-rhizobiales-comp90-cont10-pacbio/results.w.pb -e -n -v results/pangenome/roary/all-rhizobiales-comp90-cont10-pacbio/gffs/*.gff
```
### ANI analysis:
Generate lists of phylophlan marker genes from assemblies included in phylophlan anlaysis:
```
cat data/ani/obviously-meso-assemblies/meso-nods.list.txt | while read line
do
        cat bin/phylophlan/marker-list.txt | while read marker
        do
                grep "$line" bin/phylophlan/data/phyllos-and-meso-nods-and-cultures/"$marker".aln | sed 's/>//' >> data/ani/obviously-meso-assemblies/phylophlan-gene-lists/"$line".list.txt
        done
done

cat data/ani/obviously-meso-assemblies/meso-cultures.list.txt | while read line
do
        cat bin/phylophlan/marker-list.txt | while read marker
        do
                grep "$line" bin/phylophlan/data/phyllos-and-meso-nods-and-cultures/"$marker".aln | sed 's/>//' >> data/ani/obviously-meso-assemblies/phylophlan-gene-lists/"$line".list.txt
        done
done

cat data/ani/obviously-meso-assemblies/minimum-mesorhizobium-phylogenetic-reference-set.txt | while read line
do
        cat bin/phylophlan/marker-list.txt | while read marker
        do
                grep "$line" bin/phylophlan/data/minimum-meso-set-prokka/"$marker".aln | sed 's/>//' >> data/ani/obviously-meso-assemblies/phylophlan-gene-lists/"$line".list.txt
        done
done
```
Generate fastas for each genome of only marker-gene sequences:
```
cat data/ani/obviously-meso-assemblies/obviously-meso-assemblies-and-min-meso-refs.list.txt | while read line
do
        ./bin/pull-seqs-from-fasta.old.py data/ani/obviously-meso-assemblies/phylophlan-gene-lists/"$line".list.txt data/gene-predictions/prokka/"$line"/"$line".ffn > data/ani/obviously-meso-assemblies/phylophlan-ffns/"$line".phylophlan.ffn
done
```
Generate pairwise ANI comparisons on phylophlan marker genes between genome `$A` and `$B`:
```
mkdir data/ani/obviously-meso-assemblies/phylophlan-markers.results/"$A".vs."$B"
./bin/ANIcalculator_v1/ANIcalculator -genome1fna data/ani/obviously-meso-assemblies/phylophlan-ffns/"$A".phylophlan.ffn -genome2fna data/ani/obviously-meso-assemblies/phylophlan-ffns/"$B".phylophlan.ffn -outdir data/ani/obviously-meso-assemblies/phylophlan-markers.results/"$A".vs."$B"
```
### Sym-island analysis:
Generate sym-gene lists from roary pangenome table:
With list of genes in symbiosis island in reference strain (included in roary pangenome analysis):
```
cat results/pangenome/roary/meso-assembly-refs/results/"$strain".sym-genes.list.txt | while read gene; do grep $gene results/pangenome/roary/"$clade"/results*/gene_presence_absence.csv >> results/pangenome/roary/"$clade"/gene_presence_absence.sym-genes.csv ; done
```
then make lists of genes for each genome included in the pangenome analysis.
```
./bin/make-all-gene-lists-from-roary-output.py -i results/pangenome/roary/"$clade"/gene_presence_absence.sym-genes.csv -o results/pangenome/roary/"$clade"/sym-gene-lists/"$clade" -n 10
```
then for each gene list:
```
cat $symlistfile | while read
do
  sample=${line::-6}
  gene=$( echo $file | cut -f8 -d"/" | sed 's/txt//')
  ./bin/pull-seq-from-fasta.py "$line" data/gene-predictions/prokka/"$sample"/"$sample".faa >> results/pangenome/roary/obviously-meso-assemblies-90pct-comp-clades/obviously-meso-assemblies/sym-genes/sym-gene-faas/"$gene"faa
  ./bin/pull-seq-from-fasta.py "$line" data/gene-predictions/prokka/"$sample"/"$sample".ffn >> results/pangenome/roary/obviously-meso-assemblies-90pct-comp-clades/obviously-meso-assemblies/sym-genes/sym-gene-ffns/"$gene"ffn
done
```
#### Phylogenetic concordance:
Run Phylogenies
```
cd /home/agreensp/chickpea-rhizo-geo-div/sequencing/data/pacbio/merged-reordered-fastas/pangenome/sym-island/rast-full-sym/single-gene-fastas/

for file in *fna
do
        gene=$(echo $file | sed 's/'.cult-ids.aln.fna'//')

        mkdir ../trees/"$gene"
        cd ../trees/"$gene"

        raxmlHPC-PTHREADS -T 4 -n "$gene" -s ../../single-gene-fastas/"$file" -x 12345 -N 100 -c 25 -p 12345 -f a -m GTRCAT
        cd ../../single-gene-fastas/
done
```
Compute all pairwise noramlized Robinson-Foulds' distances between all symbiosis island gene trees:
```
cd data/pacbio/merged-reordered-fastas/pangenome/sym-island/phylogenies

echo "# source        ref     E.size  nRF     RF      maxRF   src-branches    ref-branches    subtrees        treekoD" > core-gene-phylogenies.all-by-all.txt

cat ../sample_intersection/pangenome_matrix_t0__core_list.gene-pairs.txt | while read pair
do
        a=$(echo $pair | cut -f1 -d,)
        b=$(echo $pair | cut -f2 -d,)
        ete3 compare -t "$SAMPLE"/RAxML_bestTree.*.fna -r "$b"/RAxML_bestTree.*.fna --unrooted --taboutput | tail -n 1 >> core-gene-phylogenies.all-by-all.txt
done
```
## Gathering metadata:
### ISRIC:
`Rscript make-isric-taxousda-subsets.r`
### Bioclim data:
`Rscript extract-bioclim-mean-temp-mean-prec.9.27.18.R`

To re-create r-generated figures and analyses for the manuscript, download the files from the below figshare repository to the same directory as the scripts and run with `rscript`.

Data required to run r scripts is available at:

https://figshare.com/articles/Mesorhizobium_biogeograph_R-scripts_data/8131232

The trees from the manuscript can be visualized interactively at iTol:
Figure 1A: https://itol.embl.de/tree/13615214321176431555448182
Figure 4A: https://itol.embl.de/tree/13615214321248111555453004
Figure S1: https://itol.embl.de/tree/13615214321199181559855453
Figure S12: https://itol.embl.de/tree/1361521435206081555286300
Figure S13: https://itol.embl.de/tree/136152143676081554915683
