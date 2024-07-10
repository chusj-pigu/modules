process multiqc {
    publishDir "${params.out_dir}/reports", mode : "copy"
    container="staphb/multiqc:latest"
    
    input:
    path '*'

    output:
    path "multiqc_report.html"

    script:
    """
    multiqc .
    """

}
