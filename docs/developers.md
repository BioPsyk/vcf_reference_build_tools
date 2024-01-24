# Developer guide
This is only intended for people contributing code to this repository


## Create example data
The 1kgp vcf and all dbsnp references are from the cleansumstats pipeline example data. However, right now the GRCh37 vcf reference is the GRCh38 vcf but directly replaced with coordinates and SNPs from the dbsnp reference

```
PROOT="../../.."

# make vcf header (mandatory fields are CHROM,POS,ID,REF,LT,QUAL,FILTER,INFO)
cat <<EOF > GRCh37_example_data_header.vcf.tmp
##fileformat=VCFv4.3
##FILTER=<ID=PASS,Description="All filters passed">
##fileDate=20210505
##source=exampleTestData
##INFO=<ID=AN,Number=1,Type=Integer,Description="Total number of alleles in called genotypes">
#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO
EOF

# Format the dbsnp and sort (required by tabix)
awk -vOFS="\t" '{split($1,gr,":"); print gr[1], gr[2], $3, $4, $5, ".", "PASS", "AN=5096"}' ${PROOT}/data/dbsnp/All_20180418_GRCh37_GRCh38.sorted.bed > GRCh37_example_data_body.vcf.tmp
sort -t "$(printf '\t')" -k1,1 -k2,2n GRCh37_example_data_body.vcf.tmp > GRCh37_example_data_body_sorted.vcf.tmp

# merge with header
cat GRCh37_example_data_header.vcf.tmp GRCh37_example_data_body_sorted.vcf.tmp > GRCh37_example_data.vcf.tmp

# bgzip and tabix (so that we can use bcftools)
bgzip -c GRCh37_example_data.vcf.tmp > GRCh37_example_data.vcf.gz
tabix -p vcf GRCh37_example_data.vcf.gz

# remove temp files
rm *tmp

# make a copy with different name
cp GRCh37_example_data.vcf.gz GRCh37_example_data2.vcf.gz
cp GRCh37_example_data.vcf.gz.tbi GRCh37_example_data2.vcf.gz.tbi

```

Might be good to bgzip and tabix the GRCh38 input as well.

