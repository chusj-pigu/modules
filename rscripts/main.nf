process clean_countmx {
    publishDir "${params.out_dir}/reports", mode: 'copy'

    input:
    path tab

    output:
    path "readCounts_summary.xlsx"

    script:
    """
    Rscript ${projectDir}/modules/rscripts/clean_countmx.R
    """
}

process clean_cnvTable {
    publishDir "${params.out_dir}/variants", mode: 'copy'
    tag "$type"

    input:
    tuple val(type), path(table)

    output:
    path "${params.sample_id}_${type}_summary.tsv"

    when:
    type == 'cnv'

    script:
    def genes = params.gene_list.endsWith('NO_FILE') ? "" : "$params.gene_list"
    """
    Rscript ${projectDir}/modules/rscripts/vcf_cnv.R $table ${params.sample_id}_${type}_summary.tsv $genes
    """
}

process clean_fusionTable {
    publishDir "${params.out_dir}/variants", mode: 'copy'
    tag "$type"

    input:
    tuple val(type), path(table)

    output:
    path "${params.sample_id}_${type}_summary.tsv"

    when:
    type == 'fusion'

    script:
    def genes = params.gene_list.endsWith('NO_FILE') ? "" : "$params.gene_list"
    """
    Rscript ${projectDir}/modules/rscripts/vcf_fusion.R $table ${params.sample_id}_${type}_summary.tsv $genes
    """
}

process clean_translocTable {
    publishDir "${params.out_dir}/variants", mode: 'copy'
    tag "$type"

    input:
    tuple val(type), path(table)

    output:
    path "${params.sample_id}_${type}_summary.tsv"

    when:
    type == 'translocation'

    script:
    def genes = params.gene_list.endsWith('NO_FILE') ? "" : "$params.gene_list"
    """
    Rscript ${projectDir}/modules/rscripts/vcf_transloc.R $table ${params.sample_id}_${type}_summary.tsv $genes
    """
}