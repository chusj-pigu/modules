process clean_countmx {
    publishDir "${params.out_dir}/reports", mode: 'copy'
    container 'rocker/tidyverse:latest'

    input:
    path tab

    output:
    path "readCounts_summary.xlsx"

    script:
    """
    clean_countmx.R
    """
}

process clean_cnvTable {
    publishDir "${params.out_dir}/variants", mode: 'copy'
    container 'rocker/tidyverse:latest'
    tag "$type"

    input:
    tuple val(type), path(table)
    path gene_file

    output:
    path "${params.sample_id}_${type}_summary.tsv"


    script:
    def genes = params.gene_list.endsWith('NO_FILE') ? "" : "$gene_file"
    """
    vcf_cnv.R $table ${params.sample_id}_${type}_summary.tsv $genes
    """
}

process clean_fusionTable {
    publishDir "${params.out_dir}/variants", mode: 'copy'
    container 'rocker/tidyverse:latest'
    tag "$type"

    input:
    tuple val(type), path(table)
    path gene_file

    output:
    path "${params.sample_id}_${type}_summary.tsv"


    script:
    def genes = params.gene_list.endsWith('NO_FILE') ? "" : "$gene_file"
    """
    vcf_fusion.R $table ${params.sample_id}_${type}_summary.tsv $genes
    """
}

process clean_translocTable {
    publishDir "${params.out_dir}/variants", mode: 'copy'
    container 'rocker/tidyverse:latest'
    tag "$type"

    input:
    tuple val(type), path(table)
    path gene_file

    output:
    path "${params.sample_id}_${type}_summary.tsv"

    script:
    def genes = params.gene_list.endsWith('NO_FILE') ? "" : "$gene_file"
    """
    vcf_transloc.R $table ${params.sample_id}_${type}_summary.tsv $genes
    """
}