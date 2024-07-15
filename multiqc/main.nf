process multiqc {
    publishDir "${params.out_dir}/reports"
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
