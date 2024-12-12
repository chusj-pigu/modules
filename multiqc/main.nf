process multiqc {
    
    publishDir "${params.out_dir}/reports", mode: 'link', enabled: params.publish, saveAs: { "multiqc_report${params.multiqc_name ?: ''}.html" }
    container="staphb/multiqc:1.25"
    
    input:
    path '*'

    output:
    path "multiqc_report.html"

    script:
    """
    multiqc .
    """
}
