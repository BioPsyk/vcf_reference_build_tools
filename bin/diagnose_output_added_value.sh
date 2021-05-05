infile=$1
output=$2

# Count NA or . in respective column
awk '
BEGIN {
c1=c2=c3=c4=0
}
NR>1{
  if($4 != "." && $9 != "NA"){c1++}; 
  if($4 == "." && $9 != "NA"){c2++}; 
  if($4 != "." && $9 == "NA"){c3++}; 
  if($4 == "." && $9 == "NA"){c4++}
} 
END { 
  printf "%s%s", "Both_RSID_NA", OFS;
  printf "%s%s", "input_RSID_NA", OFS;
  printf "%s%s", "dbSNP_RSID_NA", OFS;
  printf "%s%s", "Both_RSID_exists", OFS;
  printf "%s\n", "Total_rows_excl_header";
  print c1,c2,c3,c4,NR-1
}' ${infile} > ${output}


