#!/usr/bin/env bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
project_dir=$(dirname "${script_dir}")

function format_mount_flags() {
  flag="${1}"

  for mount in "${mounts[@]}"
  do
    echo "${flag} ${project_dir}/${mount}:/vcf_reference_build_tools/${mount}"
  done
}

cd "${project_dir}"

mounts=(
  "docs" "assets" "bin" "conf"
  "insert_map_in_vcf.nf" "make_map.nf" "nextflow.config" "tests" "tmp"
  "VERSION"
)

image_tag="ibp-vcf_reference_build_tools-base:"$(cat "docker/VERSION")
deploy_image_tag="ibp-vcf_reference_build_tools:"$(cat "docker/VERSION")

#singularity build
singularity_image_tag="ibp-vcf_reference_build_tools-base_version-$(cat "docker/VERSION").sif"

mkdir -p tmp

