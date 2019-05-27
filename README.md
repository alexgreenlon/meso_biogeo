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
### Miniasm:
### camsa:

## Nodule-DNA libraries:
### Metagenomic assembly pipeline:
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
`RSCRIPT make-isric-taxousda-subsets.r`
### Bioclim data:

## Scripts to upload:
- peter's pipeline and accessory scripts
- `make-all-gene-lists-from-roary-output.py`
- `pull-seq-from-fasta.py`


To re-create r-generated figures and analyses for the manuscript, download the files from the below figshare repository to the same directory as the scripts and run with `rscript`. 

Data required to run r scripts is available at:

https://figshare.com/articles/Mesorhizobium_biogeograph_R-scripts_data/8131232
