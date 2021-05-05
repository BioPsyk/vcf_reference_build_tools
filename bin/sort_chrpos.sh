infile=$1
outfile=$2

# sort (using parallelisation)
LC_ALL=C sort -k 2,2 --parallel 8 ${infile} -o ${outfile}

