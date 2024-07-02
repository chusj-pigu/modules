process multiqc {
    publishDir "${params.out_dir}/reports", mode : "copy"
    
    input:
    path "*", stageAs: 'input??'

    output:
    path "multiqc_report.html"

    script:
    """
    multiqc .
    """

}
