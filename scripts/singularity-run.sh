#!/usr/bin/env bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "${script_dir}/init-containerization.sh"

mount_flags=$(format_mount_flags "-B")

FAKE_HOME="tmp/fake-home"
export SINGULARITY_HOME="/vcf_reference_build_tools/${FAKE_HOME}"
mkdir -p "${FAKE_HOME}"

exec singularity run \
     --contain \
     --cleanenv \
     ${mount_flags} \
     "tmp/${singularity_image_tag}" \
     "$@"
