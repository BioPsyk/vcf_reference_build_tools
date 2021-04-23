infile=$1
outfile=$2

# Add header and cut of rownindex
echo -e "CHR_GRCh38\tPOS_GRCh38\tCHR_GRCh37\tPOS_GRCh37\tRSID_dbsnp151\tREF\tALT" > ${outfile}
awk '{split($1,gr38,":"); if($3=="NA"){$3="NA NA"}else{split($3,gr3x,":")}; print gr38[1], gr38[2],gr3x[1], gr3x[2],$4,$5,$6}' ${infile} >> ${outfile}

