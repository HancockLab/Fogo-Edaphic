# Off-targets analysis for S1-1-*irt1*

## Requirements

* samtools (version 1.9)
* GATK (version 4.2.3.0)
* picard (version 2.21.1)
* python (version 3.8.3)
* bcftools (version 1.9)

## Search for potential off-targets

We used [Cas-OFFinder](http://www.rgenome.net/cas-offinder/) in this analysis.
We choose SpCas9 from Streptococcus pyogenes: 5'-NGG-3 as CRISPR/Cas-derived RNA-guided Endonucleases (RGENs) and set a maximum of 5 mismatches. 

The two crRNA sequences were the following (without PAM).

* ACTCGCTTCCACATTCTTC
* TCCTCATTGCAAGCATGAT

We obtained this [output](S1-1-irt1_sgRNA1-2_off-targets_Mis5.txt):
```bash
head S1-1-irt1_sgRNA1-2_off-targets_Mis5.txt
X	ACTCGCTTCCACATTCTTCNGG	AgTgaCTTCCAgAaTCTTCGGG	chr5	275346	+	5	0
X	ACTCGCTTCCACATTCTTCNGG	ACaaGCTctCACATTCTTtGGG	chr5	804217	-	5	0
X	ACTCGCTTCCACATTCTTCNGG	ACTCGCTTCCAaAccCgTaCGG	chr5	5157849	+	5	0
X	ACTCGCTTCCACATTCTTCNGG	tactGCTTCCAgATTCTTCTGG	chr5	5555552	-	5	0
X	ACTCGCTTCCACATTCTTCNGG	tgTCaCTTtCACATTCTTgAGG	chr5	5910976	+	5	0
X	ACTCGCTTCCACATTCTTCNGG	tCTCGCTTgCACATTCcaaGGG	chr5	6736553	+	5	0
X	ACTCGCTTCCACATTCTTCNGG	AtTCGaacCCACATTCTaCGGG	chr5	7727424	-	5	0
X	ACTCGCTTCCACATTCTTCNGG	AaTgGCTTCgACtTTCaTCGGG	chr5	8044263	+	5	0
X	ACTCGCTTCCACATTCTTCNGG	ACaCtCTTCCAtcTgCTTCTGG	chr5	9098012	-	5	0
```

## Directories

```bash
path2picard='/paht2picard/picard.jar'
path2gatk='/path2gatk/gatk'
path2ref='/path2ref/TAIR10_all.fa'
path2fastq='/path2fastq/fastq/'
path2bam='/path2bam/bam/'
path2output='/path2output/output/'
```

## Mapping raw data

```bash
for i in $path2fastq$1/$1*1.fq.gz
do
fastq=`basename $i 1.fq.gz`
bwa mem -R "@RG\tID:id\tSM:sample\tLB:lib" $path2ref $path2fastq${1}/${fastq}'1.fq.gz' $path2fastq${1}/${fastq}'2.fq.gz' | samtools view -Sb | samtools sort -o $workingDir${1}/${1}.sorted.bam
```
The first argument ($1) corresponds to the seqID. #S5262_A for example here.

## Preparing bam files

```bash
java -jar $path2picard MarkDuplicates I=$path2bam$1.sorted.bam O=$path2output$1.marked_duplicates.bam M=$path2output$1.marked_dup_metrics.txt
java -jar $path2picard SortSam I=$path2output$1.marked_duplicates.bam O=$path2output$1.markDuplicates_sortSam.bam SORT_ORDER=coordinate
samtools index $path2output$1.markDuplicates_sortSam.bam
```

## GATK call

#### Prepare the reference fasta file

Not necessary if already done

```bash
java -jar $path2picard CreateSequenceDictionary REFERENCE=$path2ref OUTPUT=/srv/netscratch/irg/grp_hancock/Manu/BSA/TAIR10_all.dict
```

#### Calling with in GVCF mode

```bash
$path2gatk HaplotypeCaller --java-options "-Xmx10G" -I $path2output$1.markDuplicates_sortSam.bam -R $path2ref --emit-ref-confidence GVCF -O $path2output$1.GATK.gvcfMode.vcf
```

#### Create a database with all samples 

We first need to create a mapfile like this

```bash
head map.file
2876_AL	/srv/netscratch/irg/grp_hancock/Manu/IRT1/offTargets/vcf/2876_A.GATK.gvcfMode.vcf
S5262_A	/srv/netscratch/irg/grp_hancock/Manu/IRT1/offTargets/vcf/S5262_A.GATK.gvcfMode.vcf
S5262_B	/srv/netscratch/irg/grp_hancock/Manu/IRT1/offTargets/vcf/S5262_B.GATK.gvcfMode.vcf
```

So we first create a samples.list 

```bash
head samples.list
2876_AL
S5262_A
S5262_B
```

To then create the map file

```bash
path2output='/srv/netscratch/irg/grp_hancock/Manu/IRT1/offTargets/vcf'
cat ${path2output}/samples.list | awk '{printf "%s\t'$DIR'/%s.GATK.gvcfMode.vcf\n",$1,$1}' > map.file
```

We also need an interval list which corresponds to each chromosome with the exact name used in the referene (TAIR10 here)

```bash
head interval.list
chr1
chr2
chr3
chr4
chr5
```

#### Create the database

```bash
$path2gatk GenomicsDBImport  --genomicsdb-workspace-path ${path2output}IRT1_DatabaseName --sample-name-map ${path2output}map.file -L ${path2output}interval.list
```

## Merge VCFs
```bash
$path2gatk GenotypeGVCFs -R $path2ref -V gendb://${path2output}IRT1_DatabaseName -O ${path2output}merged.vcf
```

### SNPs Filtering

#### Extract bi-allelic SNPs

```bash
$path2gatk SelectVariants -V ${path2output}merged.vcf -O ${path2output}only_SNPs.vcf -R $path2ref --select-type-to-include SNP --restrict-alleles-to BIALLELIC
```

#### Adding filters and marking heterozygous calls
```bash
$path2gatk VariantFiltration -R $path2ref -V ${path2output}only_SNPs.vcf -filter "QD < 2.0" --filter-name "QD2" -filter "QUAL < 30.0" --filter-name "QUAL30" -filter "SOR > 3.0" --filter-name "SOR3"  -filter "FS > 60.0" --filter-name "FS60" -filter "MQ < 40.0" --filter-name "MQ40" -filter "MQRankSum < -12.5" --filter-name "MQRankSum-12.5" -filter "ReadPosRankSum < -8.0" --filter-name "ReadPosRankSum-8" --genotype-filter-expression "isHet == 1" --genotype-filter-name "isHetFilter" -O ${path2output}only_SNPs_filters_added.vcf 
```

#### Convert Heterozygous calls to missing data (0/1 to ./.)
```bash
$path2gatk SelectVariants -V only_SNPs_filters_added.vcf -R $path2ref -O snps_withoutHTs.vcf --set-filtered-gt-to-nocall 
```

#### Exclude filtered snps
```bash
$path2gatk SelectVariants -V snps_withoutHTs.vcf -R $path2ref --output only_SNPs_Final.vcf --exclude-filtered true --exclude-non-variants true
```

### INDELs Filtering

#### Extract bi-allelic Indels
```bash
$path2gatk SelectVariants -V merged.vcf -O only_INDELs.vcf -R $path2ref --select-type-to-include INDEL --restrict-alleles-to BIALLELIC
```

#### Adding filters and marking heterozygous calls
```bash
$path2gatk VariantFiltration -V only_INDELs.vcf -filter "QD < 2.0" --filter-name "QD2" -filter "QUAL < 30.0" --filter-name "QUAL30" -filter "FS > 200.0" --filter-name "FS200" -filter "ReadPosRankSum < -20.0" --filter-name "ReadPosRankSum-20" --genotype-filter-expression "isHet == 1" --genotype-filter-name "isHetFilter" -O only_INDELs_filters_added.vcf
```

#### Convert Heterozygous calls to missing data (0/1 to ./.)
```bash
$path2gatk SelectVariants -V only_INDELs_filters_added.vcf -R $path2ref -O indels_withoutHTs.vcf --set-filtered-gt-to-nocall
```

#### Finally we exclude filtered indels
```bash
$path2gatk SelectVariants -V indels_withoutHTs.vcf -R $path2ref -O only_INDELs_Final.vcf --exclude-filtered true --exclude-non-variants true

```
#### And get the segregating ones
```bash
$path2gatk SelectVariants  -R $path2ref -V only_INDELs_Final.vcf -select "AF < 1.0" -O only_INDELs_Final.Segregating.vcf
```

#### Merging SNPs and INDELs vcfs

```bash
$bcftools concat only_INDELs_Final.Segregating.vcf only_SNPs_Final.Segregating.vcf
```

## Checking overlap between SNPs-INDELs and potential off-targets

```python
import pandas as pd
import numpy as np
import io
import time
start = time.time()


outputDir='/path2output/output/'
file='S1-1-irt1_sgRNA1-2_off-targets_Mis5.txt'
offTargets=pd.read_table(file)
offTargets=offTargets.sort_values(by=['Chromosome','Position'])
offTargets=offTargets.drop_duplicates(subset='Position',keep='first',ignore_index=True)


offTargets['Start']=np.select([offTargets['Direction'] == '+',offTargets['Direction'] == '-'],
								[offTargets['Position'],offTargets['Position']-23])
offTargets['End']=np.select([offTargets['Direction'] == '+',offTargets['Direction'] == '-'],
								[offTargets['Position']+23,offTargets['Position']])


Chr1=offTargets.loc[offTargets['Chromosome'] == 'chr1']
Chr2=offTargets.loc[offTargets['Chromosome'] == 'chr2']
Chr3=offTargets.loc[offTargets['Chromosome'] == 'chr3']
Chr4=offTargets.loc[offTargets['Chromosome'] == 'chr4']
Chr5=offTargets.loc[offTargets['Chromosome'] == 'chr5']

def iteration(dataframe):
	for i in dataframe.itertuples():
		if int(i.Start) <=  int(tmp[1]) <= int(i.End):
			print(tmp,i.Start,i.End)


with open(outputDir + 'SNPs_INDELs_Segregating.vcf', 'r') as vcf:
	for line in vcf:
		tmp = line.strip().split()
		if tmp[0] == 'chr1':
			iteration(Chr1)
		elif tmp[0] == 'chr2':
			iteration(Chr2)
		elif tmp[0] == 'chr3':
			iteration(Chr3)
		elif tmp[0] == 'chr4':
			iteration(Chr4)
		elif tmp[0] == 'chr5':
			iteration(Chr5)
end=time.time()
print(end-start)
```











