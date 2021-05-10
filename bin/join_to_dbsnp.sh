infile=$1
dbsnpref=$2
build=$3

# Add header to files to know what exactly is in each column
# Then we can use the colnames to reorder using sumstat-tools in the final formatting
# And/Or we just convert the example data into GRCh37 and use different formatting depending on the build

# join to dbsnp
if [ ${build} == "GRCh38" ];then
  LC_ALL=C join -e "NA" -a1 -o 1.1 1.2 1.3 1.4 1.5 2.2 2.3 2.4 2.5 -1 2 -2 1 -t "$(printf ' ')" ${infile} ${dbsnpref}
else
  LC_ALL=C join -e "NA" -a1 -o 1.1 2.1 1.3 1.4 1.5 1.2 2.3 2.4 2.5 -1 2 -2 1 -t "$(printf ' ')" ${infile} ${dbsnpref}
fi

