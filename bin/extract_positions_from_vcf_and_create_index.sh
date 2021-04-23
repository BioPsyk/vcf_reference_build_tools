infile=$1

# extract all position from vcf and create indices
zcat ${infile} | awk '!/^#/{print $1":"$2, NR}'

