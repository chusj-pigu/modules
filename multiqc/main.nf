process multiqc {
    
    publishDir "${params.out_dir}/reports", mode: 'link', enabled: params.publish
    container="staphb/multiqc:sha256:631572ea2c9f1335f138b36f37bf996d047d5dda5e4b73e722e4543147cffc6b"
    
    input:
    path '*'

    output:
    path "multiqc_report.html"

    script:
    """
    multiqc .
    """

}
