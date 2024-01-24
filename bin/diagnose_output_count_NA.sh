infile=$1
output=$2

# Count NA or . in respective column
awk '
BEGIN{
 c1=c2=c3=c4=c5=c6=c7=c8=c9=c10=c11=0;
}

NR>1{
  if($1 == "NA"){c1++}; 
  if($2 == "NA"){c2++}; 
  if($3 == "NA"){c3++}; 
  if($4 == "."){c4++}; 
  if($5 == "NA"){c5++}; 
  if($6 == "NA"){c6++}; 
  if($7 == "NA"){c7++}; 
  if($8 == "NA"){c8++}; 
  if($9 == "NA"){c9++}; 
  if($10 == "NA"){c10++}; 
    if($11 == "NA"){c11++}
  } END { 
  printf "%s%s", "ROWINDEX", OFS;
  printf "%s%s", "CHR", OFS;
  printf "%s%s", "POS", OFS;
  printf "%s%s", "ID", OFS;
  printf "%s%s", "REF", OFS;
  printf "%s%s", "ALT", OFS;
  printf "%s%s", "CHROM_GRCh38", OFS;
  printf "%s%s", "POS_GRCh38", OFS;
  printf "%s%s", "ID_dbSNP151", OFS;
  printf "%s%s", "REF_dbSNP151", OFS;
  printf "%s%s", "ALT_dbSNP151", OFS;
  printf "%s\n", "Total_rows_excl_header";
  print c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,NR-1

}' ${infile} > ${output}


