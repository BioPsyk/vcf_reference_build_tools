map=$1
out=$2

#out should have extension .vcf.gz

# prepare mapfile as tabix sorted vcf
cat <<EOF > tmp1
##fileformat=VCFv4.3
##FILTER=<ID=PASS,Description="All filters passed">
##fileDate=20210505
##source=exampleTestData
##INFO=<ID=AN,Number=1,Type=Integer,Description="Total number of alleles in called genotypes">
#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO
EOF
gunzip -c ${map} | awk -vOFS='\t' 'NR>1{ print $2, $3, $4, $5, $6, ".", "PASS", "AN=5096" }' > tmp2

# sort and make tabix index
sort -t "$(printf '\t')" -k1,1 -k2,2n tmp2 > tmp2b

# merge with header
cat tmp1 tmp2b > tmp3

# bgzip and tabix (so that we can use bcftools)
bgzip -c tmp3 > ${out}
tabix -p vcf ${out}

