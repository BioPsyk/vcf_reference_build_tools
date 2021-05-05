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
  print "Both RSID NA", c1;
  print "input RSID NA", c2;
  print "dbSNP RSID NA", c3;
  print "Both RSID exists", c4
  print "Total rows (excl. header)", NR-1
}' ${infile} > ${output}


