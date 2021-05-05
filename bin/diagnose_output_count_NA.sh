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
  print "ROWINDEX", c1;
  print "CHR", c2;
  print "POS", c3;
  print "ID", c4;
  print "REF", c5;
  print "ALT", c6;
  print "CHROM_GRCh38", c7;
  print "POS_GRCh38", c8;
  print "ID_dbSNP151", c9;
  print "REF_dbSNP151", c10;
  print "ALT_dbSNP151", c11;
  print "Total rows (excl. header)", NR-1

}' ${infile} > ${output}


