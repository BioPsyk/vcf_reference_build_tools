#!/usr/bin/env bash

set -euo pipefail

test_script="extract_positions_from_vcf_and_create_index"
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
  build=${1}

  "${test_script}.sh" ./input1.tsv.gz > ./observed-result1.tsv

  _check_results ./observed-result1.tsv ./expected-result1.tsv

  echo "- [OK] ${curr_case}"

  cd "${initial_dir}"
}

echo ">> Test ${test_script}"

#=================================================================================
# Cases
#=================================================================================

#---------------------------------------------------------------------------------
# Check that the final output is what we think it is

_setup "Extract positions and other info from vcf"

cat <<EOF | gzip -c > ./input1.tsv.gz
##fileformat=VCFv4.3
##FILTER=<ID=PASS,Description="All filters passed">
##fileDate=11032019_15h52m43s
##source=IGSRpipeline
##INFO=<ID=EX_TARGET,Number=0,Type=Flag,Description="indicates whether a variant is within the exon pull down target boundaries">
##INFO=<ID=DP,Number=1,Type=Integer,Description="Approximate read depth; some reads may have been filtered">
#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO
10	100157763	.	C	T	.	PASS	AC=415;AN=5096;DP=20612;AF=0.08;EAS_AF=0.04;EUR_AF=0.07;AFR_AF=0.01;AMR_AF=0.05;SAS_AF=0.26;VT=SNP;NS=2548
10	101966771	.	T	C	.	PASS	AC=459;AN=5096;DP=20740;AF=0.09;EAS_AF=0.07;EUR_AF=0.17;AFR_AF=0.01;AMR_AF=0.17;SAS_AF=0.07;VT=SNP;NS=2548
10	102814179	.	T	C	.	PASS	AC=2793;AN=5096;DP=20193;AF=0.55;EAS_AF=0.4;EUR_AF=0.59;AFR_AF=0.54;AMR_AF=0.58;SAS_AF=0.64;VT=SNP;NS=2548
10	104355789	.	T	C	.	PASS	AC=763;AN=5096;DP=23195;AF=0.15;EAS_AF=0.08;EUR_AF=0.28;AFR_AF=0.06;AMR_AF=0.18;SAS_AF=0.2;VT=SNP;NS=2548
10	10574522	.	T	C	.	PASS	AC=1180;AN=5096;DP=20409;AF=0.23;EAS_AF=0.33;EUR_AF=0.18;AFR_AF=0.24;AMR_AF=0.11;SAS_AF=0.25;VT=SNP;NS=2548
10	105905360	.	A	G	.	PASS	AC=3254;AN=5096;DP=16605;AF=0.64;EAS_AF=0.7;EUR_AF=0.46;AFR_AF=0.88;AMR_AF=0.59;SAS_AF=0.48;VT=SNP;NS=2548
10	106322887	.	C	T	.	PASS	AC=695;AN=5096;DP=19936;AF=0.14;EAS_AF=0;EUR_AF=0.16;AFR_AF=0.28;AMR_AF=0.08;SAS_AF=0.1;VT=SNP;NS=2548
10	106371703	.	C	A	.	PASS	AC=906;AN=5096;DP=19871;AF=0.18;EAS_AF=0.13;EUR_AF=0.16;AFR_AF=0.28;AMR_AF=0.21;SAS_AF=0.09;VT=SNP;NS=2548
10	106524737	.	G	A	.	PASS	AC=2570;AN=5096;DP=18067;AF=0.5;EAS_AF=0.44;EUR_AF=0.37;AFR_AF=0.71;AMR_AF=0.35;SAS_AF=0.54;VT=SNP;NS=2548
EOF

cat <<EOF > ./expected-result1.tsv
8 10:100157763 . C T
9 10:101966771 . T C
10 10:102814179 . T C
11 10:104355789 . T C
12 10:10574522 . T C
13 10:105905360 . A G
14 10:106322887 . C T
15 10:106371703 . C A
16 10:106524737 . G A
EOF

_run_script "GRCh38"

#---------------------------------------------------------------------------------
# Next case

#_setup "valid_rows_missing_afreq"
#
#cat <<EOF > ./acor.tsv
#0	A1	A2	CHRPOS	RSID	EffectAllele	OtherAllele	EMOD
#1	A	G	12:126406434	rs1000000	G	A	-1
#EOF
#
#cat <<EOF > ./stat.tsv
#0	B	SE	Z	P
#1	-0.0143	0.0156	-0.916667	0.3604
#EOF
#
#_run_script
