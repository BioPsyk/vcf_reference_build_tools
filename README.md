# vcf_reference_build_tools
A tool to update or add reference build information such as position, rsid, etc.


## Introduction
Right now this tool is built to add information to an in-house imputation project, but it is written to be used on any vcf file. For speed purposes, we use the dbsnp reference data from the cleansumstats pipeline. If necessary, I will add in this package how to create the used dbsnp reference data format from scratch.

## Run the script
It is possible to submit a set of vcf files, each will be given a map file with all coordinates according to dbsnp151

```
# Run a single file
./vcf_reference_build_tools.sh \
  make_map \
  -i data/1kgp/GRCh37/GRCh37_example_data.vcf.gz \
  -r data/dbsnp \
  -b GRCh37 \
  -o out

# Check output
zcat out/mapfiles/GRCh37_example_data.vcf.map.gz | head | column -t
```

The output looks like this:
```
ROWINDEX  CHR  POS       ID          REF  ALT  CHROM_GRCh38  POS_GRCh38  ID_dbSNP151  REF_dbSNP151  ALT_dbSNP151
7         1    7845695   rs228729    T    C    1             7785635     rs228729     T             C
8         1    8473813   rs12754538  C    T    1             8413753     rs12754538   C             T
9         1    10593296  rs2480782   G    T    1             10533239    rs2480782    G             T
10        1    18420144  rs12565367  A    G    1             18093650    rs12565367   A             G
11        1    20614452  rs12139607  C    T    1             20287959    rs12139607   C             T
12        1    21959590  rs9426772   T    C    1             21633097    rs9426772    T             C
13        1    24947948  rs4649005   C    T    1             24621457    rs4649005    C             T
14        1    27374218  rs537951    G    A    1             27047727    rs537951     G             A
15        1    39079150  rs3011199   A    C    1             38613478    rs3011199    A             C
```

# Diagnostics
If you have datamash installed it can be nice for visualisation, example give here below. Otherwise it is fine to just open the file using `cat`.
```
cat out/diagnosis/1kg_example_data.vcf.diagnosisNA.txt | sed -e 's/ /\t/g' | datamash transpose | column -t
cat out/diagnosis/1kg_example_data.vcf.diagnosisOverlaps.txt | sed -e 's/ /\t/g' | datamash transpose | column -t
```

## Reintroduce the mapped snpIDs in vcf


```
./vcf_reference_build_tools.sh \
  insert_map_in_vcf \
  -i data/1kgp/GRCh37/GRCh37_example_data.vcf.gz \
  -m out/mapfiles/GRCh37_example_data.vcf.map.gz \
  -b GRCh37 \
  -o out
```

## Example data
### Dbsnp reference data
The data is not only formatted, but also filtered to exclude indels and non unique positions. Location is : `data/dbsnp`


### Examle 1kg vcf file
For simplicity we use a set of variants from the 1kg data that also exists in the example dbsnp. Location is : `data/1kgp`


