infile=$1
outfile=$2

# Add header and cut of rownindex
echo -e "CHR_GRCh38 POS_GRCh38 CHR_GRCh37 POS_GRCh37 RSID_dbsnp151 REF ALT" > ${outfile}
#echo -e "CHR POS ID REF ALT CHROM_GRCh38 POS_GRCh38 ID_dbSNP151" > ${outfile}
awk '
{
  if($1=="NA"){pos1="NA"; pos2="NA"
  }else{split($1,gr,":"); pos1=gr[1]; pos2=gr[2]};
  if($3=="NA"){pos3="NA"; pos4="NA"
  }else{split($3,gr,":"); pos3=gr[1]; pos4=gr[2]};
  print pos1, pos2, pos3, pos4, $4, $5, $6
}' ${infile} >> ${outfile}

