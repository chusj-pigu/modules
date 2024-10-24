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
    label "rscript"
    executor 'slurm'

    input:
    tuple val(type), path(table)

    output:
    path "${params.sample_id}_${type}_summary.tsv"
    
    when:
    table.size() > 0

    script:
    """
    vcf_cnv.R $table ${params.sample_id}_${type}_summary.tsv
    """
}

process clean_svTable {
    publishDir "${params.out_dir}/variants", mode: 'copy'
    container 'rocker/tidyverse:latest'
    tag "$type"
    label "rscript"
    executor 'slurm'

    input:
    tuple val(type), path(table)

    output:
    path "${params.sample_id}_${type}_summary.tsv"

    when:
    table.size() > 0

    script:
    """
    vcf_sv.R $table ${params.sample_id}_${type}_summary.tsv
    """
}

process clean_snpTable {
    publishDir "${params.out_dir}/variants", mode: 'copy'
    container 'rocker/tidyverse:latest'
    tag "$type"
    label "rscript"
    executor 'slurm'

    input:
    tuple val(type), path(table)

    output:
    path "${params.sample_id}_${type}_summary.tsv"

    when:
    table.size() > 0

    script:
    """
    vcf_snp.R $table ${params.sample_id}_${type}_summary.tsv
    """
}