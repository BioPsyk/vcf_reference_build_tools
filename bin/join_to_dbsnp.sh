infile=$1
dbsnpref=$2
build=$3

# join to dbsnp
if [ ${build} == "GRCh38" ];then
  LC_ALL=C join -e "NA" -a1 -o 1.1 1.2 1.3 1.4 1.5 2.2 2.3 2.4 2.5 -1 2 -2 1 -t "$(printf ' ')" ${infile} ${dbsnpref}
else
  LC_ALL=C join -e "NA" -a1 -o 1.1 2.1 1.3 1.4 1.5 1.2 2.3 2.4 2.5 -1 2 -2 1 -t "$(printf ' ')" ${infile} ${dbsnpref}
fi

