infile=$1

# extract all position from vcf and create indices
zcat ${infile} | awk '!/^#/{print  NR, $1":"$2, $3, $4, $5}'

