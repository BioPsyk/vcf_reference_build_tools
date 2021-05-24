#!/usr/bin/env bash

set -euo pipefail

test_script="select_overlap_type"
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

# prepare input, make rows so that:
#row1: Both RSIDs exactly same
#row2: Both RSIDs exists but not same
#row3: Only dbsnp exists
#row4: Only input exists
#row5: No RSID exists (Because it is easy to create, for the example below dbsnp has ref and alt info, but in a real case they will not)

cat <<EOF | gzip -c > ./input.map.gz
ROWINDEX CHR POS ID REF ALT CHROM_GRCh38 POS_GRCh38 ID_dbSNP151 REF_dbSNP151 ALT_dbSNP151
7 1 7845695 rs228729 T C 1 7785635 rs228729 T C
8 1 8473813 rs12754538 C T 1 8413753 rs99999 C T
9 1 10593296 . G T 1 10533239 rs2480782 G T
10 1 18420144 rs12565367 A G 1 18093650 . A G
11 1 20614452 . C T 1 20287959 . C T
EOF

_setup "Both_RSID_exists"

cat <<EOF > ./expected-result1.tsv
EOF

_run_script "Both_RSID_exists"

#---------------------------------------------------------------------------------
# Next case
