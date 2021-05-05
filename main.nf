nextflow.enable.dsl=2

process extract_positions_from_vcf_and_create_index {
    publishDir "${params.intermediates}", mode: 'rellink', overwrite: true
    input:
      tuple val(id), path(vcfin)
    output:
      tuple val(id), path('extract_positions_from_vcf_and_create_index')
    script:
      """
      extract_positions_from_vcf_and_create_index.sh ${vcfin} > "extract_positions_from_vcf_and_create_index"
      """
}
process sort_chrpos {
    publishDir "${params.intermediates}", mode: 'rellink', overwrite: true
    cpus 4
    input:
      tuple val(id), path(infile)
    output:
      tuple val(id), path('sort_chrpos')
    script:
      """
      sort_chrpos.sh ${infile} "sort_chrpos"
      """
}
process join_to_dbsnp {
    publishDir "${params.intermediates}", mode: 'rellink', overwrite: true
    input:
      tuple val(id), path(infile)
      path(dbsnpfile)
      val build
    output:
      tuple val(id), path('join_to_dbsnp')
    script:
      """
      join_to_dbsnp.sh ${infile} ${dbsnpfile} ${build} > "join_to_dbsnp"
      """
}
process sort_rowindex {
    publishDir "${params.intermediates}", mode: 'rellink', overwrite: true
    cpus 4
    input:
      tuple val(id), path(infile)
    output:
      tuple val(id), path('sort_rowindex')
    script:
      """
      sort_rowindex.sh ${infile} "sort_rowindex"
      """
}
process format_and_give_header {
    publishDir "${params.intermediates}", mode: 'rellink', overwrite: true
    cpus 2
    input:
      tuple val(id), path(infile)
    output:
      tuple val(id), path('format_and_give_header')
    script:
      """
      format_and_give_header.sh ${infile} "format_and_give_header"
      """
}
process diagnosis_NA {
    publishDir "out/diagnosis", mode: 'copy', overwrite: false
    input:
      tuple val(id), path(infile)
    output:
      path("${id}.diagnosisNA.txt")
    script:
      """
      diagnose_output_count_NA.sh ${infile} "${id}.diagnosisNA.txt"
      """
}
process diagnosis_overlaps {
    publishDir "out/diagnosis", mode: 'copy', overwrite: false
    input:
      tuple val(id), path(infile)
    output:
      path("${id}.diagnosisOverlaps.txt")
    script:
      """
      diagnose_output_added_value.sh ${infile} "${id}.diagnosisOverlaps.txt"
      """
}
process gzip_results {
    publishDir "out", mode: 'copy', overwrite: false
    input:
      tuple val(id), path(infile)
    output:
      path("${id}.map.gz")
    script:
      """
      gzip -9c ${infile} > "${id}.map.gz"
      """
}

workflow {
  
  //set variable default to match example data
  if (params.build) { build = "${params.build}" }
  if (params.dbsnpdir) { dbsnpdir = "${params.dbsnpdir}" }
  
  // use build information to determine which dbsnp reference data to use
  if(params.dbsnpdir){
    if( "${build}" == "GRCh38"){
      dbsnpref=file("${dbsnpdir}/All_20180418_GRCh38_GRCh37.sorted.bed")
    }else {
      dbsnpref=file("${dbsnpdir}/All_20180418_${build}_GRCh38.sorted.bed")
    }
  }
  
  // the vcf input to create a map from
  if(params.input) {
    channel.fromPath("${params.input}")
      .map { file -> tuple(file.baseName - ~/\.gz/, file) }
      .transpose()
      .set { vcf_filename_tracker_added }
  }
  
  // Start processing
  extract_positions_from_vcf_and_create_index(vcf_filename_tracker_added)
  sort_chrpos(extract_positions_from_vcf_and_create_index.out)
  join_to_dbsnp(sort_chrpos.out, dbsnpref, build )
  sort_rowindex(join_to_dbsnp.out)
  format_and_give_header(sort_rowindex.out)

  // write output and diagnose the results
  gzip_results(format_and_give_header.out)
  diagnosis_overlaps(format_and_give_header.out)
  diagnosis_NA(format_and_give_header.out)
  
}



