nextflow.enable.dsl=2

process create_rsid_replace_column {
    publishDir "${params.outdir}/intermediates/${id}", mode: 'rellink', overwrite: true
    input:
      tuple val(id), path(vcfin), path(vcfinIndex), path(map)
    output:
      tuple val(id), path(vcfin), path(vcfinIndex), path(map), path("map_replace_col_${id}")
    script:
      """
      gunzip -c ${map} > unzipped_map 
      create_rsid_replace_column.sh unzipped_map map_replace_col_${id}
      """
}

process convert_map_to_vcf {
    publishDir "${params.outdir}/intermediates/${id}", mode: 'rellink', overwrite: true
    input:
      tuple val(id), path(vcfin), path(vcfinIndex), path(map), path(mapreplace)
    output:
      tuple val(id), path(vcfin), path(vcfinIndex), path("map_${id}.gz"), path("map_${id}.gz.tbi")
    script:
      """
      convert_map_to_vcf.sh ${map} ${mapreplace} map_${id}.gz
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
 // Channel
 //  .fromPath("${params.input}")
 //  .splitCsv( header:false, sep:" " )
 //  .map { it1, it2 -> tuple(file(it1).getBaseName(),file(it1),file("${it1}.tbi"),file(it2)) }
 //  .set { vcf_filename_tracker_added }

  // read in metafile
  Channel.fromPath("${params.input}")
  .combine(Channel.fromPath("${params.mapfile}"))
  .map { it1, it2 -> tuple(file(it1).getBaseName(),file(it1),file("${it1}.tbi"),file(it2)) }
  .set { vcf_filename_tracker_added }

  // Replace input
  create_rsid_replace_column(vcf_filename_tracker_added)
  convert_map_to_vcf(create_rsid_replace_column.out)
  join_input_and_map_vcf(convert_map_to_vcf.out)

}

