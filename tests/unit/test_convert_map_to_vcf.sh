#!/usr/bin/env bash

set -euo pipefail

test_script="convert_map_to_vcf"
initial_dir=$(pwd)"/${test_script}"
curr_case=""

mkdir "${initial_dir}"
cd "${initial_dir}"

#=================================================================================
# Helpers
#=================================================================================

function _setup {
  mkdir "${1}"
  cd "${1}"
  curr_case="${1}"
}

function _check_results {
  obs=$1
  exp=$2
  if ! diff ${obs} ${exp} &> ./difference; then
    echo "- [FAIL] ${curr_case}"
    cat ./difference 
    exit 1
  fi

}

function _run_script {

  "${test_script}.sh" ./input1.txt.gz ./observed-result1.vcf.gz 

  _check_results <(gunzip -c ./observed-result1.vcf.gz) ./expected-result1.vcf

  if [ ! -f  ./observed-result1.vcf.gz.tbi ]; then
    echo "no tabix index genereated"
    exit 1;
  fi

  echo "- [OK] ${curr_case}"

  cd "${initial_dir}"
}

echo ">> Test ${test_script}"

#=================================================================================
# Cases
#=================================================================================

#---------------------------------------------------------------------------------
# Check that the final output is what we think it is

_setup "Simple test"

cat <<EOF | gzip -c > ./input1.txt.gz
ROWINDEX CHR POS ID REF ALT CHROM_GRCh38 POS_GRCh38 ID_dbSNP151 REF_dbSNP151 ALT_dbSNP151
4 1 7845695 rs228729 T C 1 7785635 rs228729 T C
5 1 8473813 rs12754538 C T 1 8413753 rs12754538 C T
6 1 10593296 rs2480782 G T 1 10533239 rs2480782 G T
7 1 18420144 rs12565367 A G 1 18093650 rs12565367 A G
8 1 20614452 rs12139607 C T 1 20287959 rs12139607 C T
9 1 21959590 rs9426772 T C 1 21633097 rs9426772 T C
10 1 24947948 rs4649005 C T 1 24621457 rs4649005 C T
11 1 27374218 rs537951 G A 1 27047727 rs537951 G A
12 1 39079150 rs3011199 A C 1 38613478 rs3011199 A C
EOF

cat <<EOF > ./expected-result1.vcf
##fileformat=VCFv4.3
##FILTER=<ID=PASS,Description="All filters passed">
##fileDate=20210505
##source=exampleTestData
##INFO=<ID=AN,Number=1,Type=Integer,Description="Total number of alleles in called genotypes">
#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO
1	7845695	rs228729	T	C	.	PASS	AN=5096
1	8473813	rs12754538	C	T	.	PASS	AN=5096
1	10593296	rs2480782	G	T	.	PASS	AN=5096
1	18420144	rs12565367	A	G	.	PASS	AN=5096
1	20614452	rs12139607	C	T	.	PASS	AN=5096
1	21959590	rs9426772	T	C	.	PASS	AN=5096
1	24947948	rs4649005	C	T	.	PASS	AN=5096
1	27374218	rs537951	G	A	.	PASS	AN=5096
1	39079150	rs3011199	A	C	.	PASS	AN=5096
EOF

_run_script

#---------------------------------------------------------------------------------
# Next case

