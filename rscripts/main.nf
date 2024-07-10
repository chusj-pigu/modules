process clean_countmx {
    publishDir "${params.out_dir}/reports", mode : "copy"

    input:
    path tab

    output:
    path "readCounts_summary.xlsx"

    script:
    """
    Rscript ${projectDir}/subworkflows/countmx_amplicon/clean_countmx.R
    """
}