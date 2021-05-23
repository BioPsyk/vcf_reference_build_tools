nextflow.enable.dsl=2

process convert_map_to_vcf {
    publishDir "${params.outdir}/intermediates/${id}", mode: 'rellink', overwrite: true
    input:
      tuple val(id), path(vcfin), path(vcfinIndex), path(map)
    output:
      tuple val(id), path(vcfin), path(vcfinIndex), path("map_${id}.gz"), path("map_${id}.gz.tbi")
    script:
      """
      convert_map_to_vcf.sh ${map} map_${id}.gz
      """
}

process join_input_and_map_vcf {
    publishDir "${params.outdir}/updated_vcf", mode: 'copy', overwrite: false
    input:
      tuple val(id), path("vcfin.gz"), path("vcfin.gz.tbi"), path("map.gz"), path("map.gz.tbi")
    output:
      tuple val(id), path("${id}.gz"), path("${id}.gz.tbi")
    script:
      """
      join_input_and_map.sh vcfin.gz map.gz ${id}.gz
      """
}

workflow {

  // read in metafile
  Channel
   .fromPath("${params.input}")
   .splitCsv( header:false, sep:" " )
   .map { it1, it2 -> tuple(file(it1).getBaseName(),file(it1),file("${it1}.tbi"),file(it2)) }
   .set { vcf_filename_tracker_added }

  // Replace input
  convert_map_to_vcf(vcf_filename_tracker_added)
  join_input_and_map_vcf(convert_map_to_vcf.out)

}

