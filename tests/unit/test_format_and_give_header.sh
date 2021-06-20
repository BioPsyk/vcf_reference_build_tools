#!/usr/bin/env bash

set -euo pipefail

test_script="format_and_give_header"
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

  "${test_script}.sh" ./input.tsv ./observed-result1.tsv

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

_setup "missing dbsnp hit"

cat <<EOF > ./input.tsv
10 10:104573936 . T C NA NA NA NA
12 10:10616485 . T C 10:10616485 rs2025468 T C
15 10:108131461 . C A 10:108131461 rs1409409 C A
EOF

cat <<EOF > ./expected-result1.tsv
ROWINDEX CHR POS ID REF ALT CHROM_GRCh38 POS_GRCh38 ID_dbSNP151 REF_dbSNP151 ALT_dbSNP151
10 10 104573936 . T C NA NA NA NA NA
12 10 10616485 . T C 10 10616485 rs2025468 T C
15 10 108131461 . C A 10 108131461 rs1409409 C A
EOF

_run_script

#---------------------------------------------------------------------------------
# Next case


