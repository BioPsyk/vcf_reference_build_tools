# vcf_reference_build_tools
A tool to update or add reference build information such as position, rsid, etc


## Introduction
Right now this tool is built to add information to an in-house imputation project, but it is written to be used on any vcf file. For speed purposes, we use the dbsnp reference data from the cleansumstats pipeline. If necessary, I will add in this package how to create the used dbsnp reference data format from scratch.

## Run the script
It is possible to submit a set of vcf files, each will be given a map file with all coordinates according to dbsnp151

```
# install nextflow using mamba (requires conda/mamba)
mamba create -n vcf_reference_build_tools_env nextflow==20.10.0 --channel bioconda

# Activate environment
conda activate vcf_reference_build_tools_env

# Run a single file
nextflow main.nf --input 'data/1kgp/1kg_example_data.vcf.gz'

# Run a multiple files (using *)
nextflow main.nf --input 'data/1kgp/1kg_example_data*.vcf.gz'

# Check output
zcat out/1kg_example_data.vcf.map.gz | head | column -t
```

The output looks like this:
```
ROWINDEX  CHR  POS        ID  REF  ALT  CHROM_GRCh38  POS_GRCh38  ID_dbSNP151  REF_dbSNP151  ALT_dbSNP151
42        10   100157763  .   C    T    NA            NA          NA           NA            NA
43        10   101966771  .   T    C    NA            NA          NA           NA            NA
44        10   102814179  .   T    C    10            104573936   rs284858     T             C
45        10   104355789  .   T    C    NA            NA          NA           NA            NA
46        10   10574522   .   T    C    10            10616485    rs2025468    T             C
47        10   105905360  .   A    G    NA            NA          NA           NA            NA
48        10   106322887  .   C    T    NA            NA          NA           NA            NA
49        10   106371703  .   C    A    10            108131461   rs1409409    C             A
50        10   106524737  .   G    A    NA            NA          NA           NA            NA
```

# Diagnostics
If you have datamash installed it can be nice for visualisation, example give here below. Otherwise it is fine to just open the file using `cat`.
```
cat out/diagnosis/1kg_example_data.vcf.diagnosisNA.txt | sed -e 's/ /\t/g' | datamash transpose | column -t
cat out/diagnosis/1kg_example_data.vcf.diagnosisOverlaps.txt | sed -e 's/ /\t/g' | datamash transpose | column -t
```

## Example data
### Dbsnp reference data
The data is not only formatted, but also filtered to exclude indels and non unique positions. Location is : `data/dbsnp`


### Examle 1kg vcf file
For simplicity we use a set of variants from the 1kg data that also exists in the example dbsnp. Location is : `data/1kgp`


