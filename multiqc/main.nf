process multiqc {
    
    publishDir "${params.out_dir}/reports", mode: 'link', enabled: params.publish
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
