# *NRAMP1* expression analysis

## Description

Statistical tests used in the *NRAMP1* expression analysis by dPCR

## Requirements

#### Software

* R

#### Packages

* dplyr (version 1.2.1)
* agricolale (version 1.3.5)

## Code

#### Load data

```R
library(dplyr)
df = read.csv(file = 'dataset.csv',header = TRUE,sep='\t')
df = df %>% filter(Sample != 'NTC')
```

#### Comparison between samples

```R
library(agricolae)
kru = kruskal(df$Ratio_N, df$X4stats, alpha=0.05, p.adj=c("bonferroni"), group=TRUE)
kru

```

### Effect of *NRAMP1* copy number

```R
test=lm(Ratio_N ~ CNV + IRT1 + Condition, df)
summary(test)
```
