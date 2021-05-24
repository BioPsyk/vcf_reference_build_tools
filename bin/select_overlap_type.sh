infile=$1
oltype=$2

# print header
gunzip -c $infile | head -n1 

# Count NA or . in respective column
if [ "$oltype" == "Both_RSID_exists"  ]; then
gunzip -c $infile | awk ' NR>1{
  if($4 != "." && $9 != "NA"){print $0}; 
  }'
elif [ "$oltype" == "only_dbSNP_RSID_exists"  ]; then
gunzip -c $infile | awk ' NR>1{
  if($4 == "." && $9 != "NA"){print $0}; 
  }'
elif [ "$oltype" == "only_input_RSID_exists"  ]; then
gunzip -c $infile | awk ' NR>1{
  if($4 != "." && $9 == "NA"){print $0}; 
  }'
elif [ "$oltype" == "No_RSID_exists"  ]; then
gunzip -c $infile | awk ' NR>1{
  if($4 == "." && $9 == "NA"){print $0}
  }'
elif [ "$oltype" == "Both_RSID_exists_and_same"  ]; then
gunzip -c $infile | awk ' NR>1{
  if(($4 != "." && $9 != "NA") && ($4 == $9)){print $0}
  }'
elif [ "$oltype" == "Both_RSID_exists_not_same"  ]; then
gunzip -c $infile | awk ' NR>1{
  if(($4 != "." && $9 != "NA") && ($4 != $9)){print $0}
  }'
else
  >&2 echo "Error: oltype doesnt exist"
  exit 1
fi

