infile=$1
output=$2

# Count NA or . in respective column
awk '
BEGIN {
c1=c2=c3=c4=c5=c6=0
}
NR>1{
  if($4 != "." && $9 != "NA"){c1++}; 
  if($4 == "." && $9 != "NA"){c2++}; 
  if($4 != "." && $9 == "NA"){c3++}; 
  if($4 == "." && $9 == "NA"){c4++}
  if(($4 != "." && $9 != "NA") && ($4 == $9)){c5++}
  if(($4 != "." && $9 != "NA") && ($4 != $9)){c6++}
} 
END { 
  printf "%s%s", "Both_RSID_exists", OFS;
  printf "%s%s", "only_dbSNP_RSID_exists", OFS;
  printf "%s%s", "only_input_RSID_exists", OFS;
  printf "%s%s", "No_RSID_exists", OFS;
  printf "%s%s", "Both_RSID_exists_and_same", OFS;
  printf "%s%s", "Both_RSID_exists_not_same", OFS;
  printf "%s\n", "Total_rows_excl_header";
  print c1,c2,c3,c4,c5,c6,NR-1
}' ${infile} > ${output}

