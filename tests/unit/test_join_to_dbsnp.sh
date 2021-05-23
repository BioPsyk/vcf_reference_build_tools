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

_setup "Join vcf and dbsnp on chrpos GRCh38"

cat <<EOF > ./input1.tsv
16 10:100157763 . C T
9 10:101966771 . T C
10 10:102814179 . T C
11 10:104355789 . T C
12 10:10574522 . T C
13 10:105905360 . A G
14 10:106322887 . C T
15 10:106371703 . C A
8 10:106524737 . G A
EOF
#GRCh38 to GRCh37
cat <<EOF > ./input2.tsv
10:102814179 10:104573936 rs284858 T C
10:10574522 10:10616485 rs2025468 T C
10:106371703 10:108131461 rs1409409 C A
EOF

cat <<EOF > ./expected-result1.tsv
16 10:100157763 . C T NA NA NA NA
9 10:101966771 . T C NA NA NA NA
10 10:102814179 . T C 10:104573936 rs284858 T C
11 10:104355789 . T C NA NA NA NA
12 10:10574522 . T C 10:10616485 rs2025468 T C
13 10:105905360 . A G NA NA NA NA
14 10:106322887 . C T NA NA NA NA
15 10:106371703 . C A 10:108131461 rs1409409 C A
8 10:106524737 . G A NA NA NA NA
EOF

_run_script "GRCh38"

#---------------------------------------------------------------------------------
# Next case

_setup "Join vcf and dbsnp on chrpos GRCh37"

cat <<EOF > ./input1.tsv
16 10:100157763 . C T
9 10:101966771 . T C
11 10:104355789 . T C
10 10:104573936 . T C
13 10:105905360 . A G
12 10:10616485 . T C
14 10:106322887 . C T
8 10:106524737 . G A
15 10:108131461 . C A
EOF

#GRCh37 to GRCh38
cat <<EOF > ./input2.tsv
10:104573936 10:102814179 rs284858 T C
10:10616485 10:10574522 rs2025468 T C
10:108131461 10:106371703 rs1409409 C A
EOF

cat <<EOF > ./expected-result1.tsv
16 10:100157763 . C T NA NA NA NA
9 10:101966771 . T C NA NA NA NA
11 10:104355789 . T C NA NA NA NA
10 10:104573936 . T C 10:102814179 rs284858 T C
13 10:105905360 . A G NA NA NA NA
12 10:10616485 . T C 10:10574522 rs2025468 T C
14 10:106322887 . C T NA NA NA NA
8 10:106524737 . G A NA NA NA NA
15 10:108131461 . C A 10:106371703 rs1409409 C A
EOF

_run_script "GRCh37"

