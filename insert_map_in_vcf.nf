nextflow.enable.dsl=2

process unzip_input {
    publishDir "${params.intermediates}/${id}", mode: 'rellink', overwrite: true
    input:
      tuple val(id), path(vcfin), path(map)
    output:
      tuple val(id), path('vcf_in_unzipped'), path('map_unzipped')
    script:
      """
      gunzip -c ${vcfin} > "vcf_in_unzipped"
      gunzip -c ${map} > "map_unzipped"
      """
}

workflow {

  // read in metafile
  Channel
   .fromPath("${params.input}")
   .splitCsv( header:false, sep:" " )
   .map { it1, it2 -> tuple(file(it1).getBaseName(),file(it1),file(it2)) }
   .set { vcf_filename_tracker_added }

  // Start processing
  unzip_input(vcf_filename_tracker_added)
  unzip_input.out.view()

}

