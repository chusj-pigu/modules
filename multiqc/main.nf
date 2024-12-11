process multiqc {
    
    publishDir "${params.out_dir}/reports", mode: 'link', enabled: params.publish
    container="multiqc/multiqc:v1.25.2"
    
    input:
    path '*'

    output:
    path "multiqc_report.html"

    script:
    """
    multiqc .
    """

}
