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

process clean_vcf {
    publishDir "${params.out_dir}", mode: 'copy'
    container 'rocker/tidyverse:latest'
    tag "$type"
    label "rscript"
    executor 'slurm'
    array 5

    input:
    tuple val(type), path(table)
    output:
    path "*.tsv", optional:true
    
    when:
    table.size() > 0

    script:
    """
    vcf_arrange.R $table $params.gene_list $params.gene_tsv
    """
}