process multiqc {
    publishDir "${params.out_dir}", mode : "copy"
    
    input:
    path "${params.out_dir}/*"

    output:
    path "multiqc_report.html"

    script:
    """
    multiqc . 
    """

}