vcfin=$1
build=$2
im=$3
mkdir -p ${im}

# extract all position from vcf and create indices
zcat $vcfin | awk '!/^#/{print $1":"$2, NR}' > ${im}/chrpos_format

# sort (using parallelisation)
LC_ALL=C sort -k 1,1 --parallel 8 ${im}/chrpos_format > ${im}/chrpos_sorted

# join to dbsnp
if [ ${build} == "GRCh38" ];then
  dbsnpref="data/dbsnp/All_20180418_${build}_GRCh37.sorted.bed"
  LC_ALL=C join -e "NA" -a1 -o 1.1 1.2 2.2 2.3 2.4 2.5 -1 1 -2 1 -t "$(printf ' ')" ${im}/chrpos_sorted ${dbsnpref} > ${im}/chrpos_joined
else
  dbsnpref="data/dbsnp/All_20180418_${build}_GRCh38.sorted.bed"
  LC_ALL=C join -e "NA" -a1 -o 2.2 1.2 1.1 2.3 2.4 2.5 -1 1 -2 1 -t "$(printf ' ')" ${im}/chrpos_sorted ${dbsnpref} > ${im}/chrpos_joined
fi

# Sort to get back original order (using parallelisation)
sort -nk 2,2 --parallel 8 ${im}/chrpos_joined > ${im}/chrpos_joined_sorted

# Add header and cut of rownindex
echo -e "CHR_GRCh38\tPOS_GRCh38\tCHR_GRCh37\tPOS_GRCh37\tRSID_dbsnp151\tREF\tALT" > out/All_20180418.vcf.map
awk '{split($1,gr38,":"); if($3=="NA"){$3="NA NA"}else{split($3,gr3x,":")}; print gr38[1], gr38[2],gr3x[1], gr3x[2],$4,$5,$6}' ${im}/chrpos_joined_sorted >> out/All_20180418.vcf.map


