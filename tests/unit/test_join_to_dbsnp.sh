#!/usr/bin/env bash

set -euo pipefail

test_script="join_to_dbsnp"
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

  "${test_script}.sh" ./input1.tsv ./input2.tsv ${build} > ./observed-result1.tsv

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

_setup "Join vcf and dbsnp on chrpos"

cat <<EOF > ./input1.tsv
10:100157763 42
10:101966771 43
10:102814179 44
10:104355789 45
10:10574522 46
10:105905360 47
10:106322887 48
10:106371703 49
10:106524737 50
10:106970202 51
EOF

cat <<EOF > ./input2.tsv
10:102814179 10:104573936 rs284858 T C
10:10574522 10:10616485 rs2025468 T C
10:106371703 10:108131461 rs1409409 C A
EOF

cat <<EOF > ./expected-result1.tsv
10:100157763 42 NA NA NA NA
10:101966771 43 NA NA NA NA
10:102814179 44 10:104573936 rs284858 T C
10:104355789 45 NA NA NA NA
10:10574522 46 10:10616485 rs2025468 T C
10:105905360 47 NA NA NA NA
10:106322887 48 NA NA NA NA
10:106371703 49 10:108131461 rs1409409 C A
10:106524737 50 NA NA NA NA
10:106970202 51 NA NA NA NA
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
