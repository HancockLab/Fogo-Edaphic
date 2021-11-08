# Genome Assembly

Pipeline used in this paper to assemble Arabidopsis genomes with Oxford Nanopore reads

## Requirements

```
java (1.8)
minimap (2-2.17)
miniasm (0.3)
bwa (0.7.15)
samtools (1.9)
pilon (1.23)
blast (2.9.0)
wget (1.18)
cat (8.26)
fold (8.26)
awk (4.1.4)
minidot
```   

## Create non-polished contigs

```
# All-vs-all reading mappings to identify overlaps 
minimap2 -x ava-ont sample.fastq sample.fastq > sample.paf

# Create assembly graph
miniasm -f sample.fastq sample.paf > sample.gfa

# Converting GFA file to fasta file
awk '/^S/{print ">"$2"\n"$3}' sample.gfa | fold > sample_unpolihsed.fa
```

## Polishing with original nanopore reads (2 times)
```
minimap2 -x map-ont sample_unpolihsed.fa sample.fastq > sample_polished_with_racon 
```
## Polishing with IIIumina reads (10 times)
```
#Index racon polished assembly
bwa index sample_polished_with_racon_2x

# Map Illumina reads then convert sam file to bam file
bwa mem sample_polished_with_racon_2x sample.R1.fastq sample.R2.fastq | samtools view -Sb -  > sample.bam

# Sort bam file
samtools sort sample.bam -o sample.sorted.bam

# Index sorted bam file
samtools index sample.sorted.bam

# Create Illumina polished assembly
java -jar pilon-1.23.jar  --genome sample_polished_with_racon_2x --frags sample.sorted.bam
```

## Scaffolding contigs based on TAIR10
```
# Retrieve TAIR10 Assembly
wget https://www.arabidopsis.org/download_files/Genes/TAIR10_genome_release/TAIR10_chromosome_files/TAIR10_chr_all.fas

# Map Contigs against TAIR10 Assembly
minimap2  -x asm5 TAIR10_chr_all.fas sample_contigs_polished.fasta > sample_to_tair10.paf

# Finally contigs that maps to TAIR10 chromosomes can be identified with dotplot 
minidot -f 4 sample_to_tair10.paf > sample_to_tair10.pdf
(Later they were oriented and scaffolded with inhouse scripts and named final assembly as sample_V1.fasta)
```
