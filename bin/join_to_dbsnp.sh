infile=$1
dbsnpref=$2
build=$3

# The output order will be so that the input build format will be placed to the left and then dbsnp join will be on the right
# In that way we will never have missing values in the first two columns, as all input rows all have chr pos information

# join to dbsnp
if [ ${build} == "GRCh38" ];then
  LC_ALL=C join -e "NA" -a1 -o 1.1 1.2 1.3 1.4 1.5 2.2 2.3 2.4 2.5 -1 2 -2 1 -t "$(printf ' ')" ${infile} ${dbsnpref}
else
  LC_ALL=C join -e "NA" -a1 -o 1.1 1.2 1.3 1.4 1.5 2.2 2.3 2.4 2.5 -1 2 -2 1 -t "$(printf ' ')" ${infile} ${dbsnpref}
fi

