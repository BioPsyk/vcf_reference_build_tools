infile=$1
outfile=$2

# Sort to get back original order (using parallelisation)
sort -nk 1,1 --parallel 8 ${infile} -o ${outfile}
