process mosdepth {
    container="quay.io/biocontainers/mosdepth:0.3.3--h37c5b7d_2"
    publishDir "${params.out_dir}/reports/mosdepth", mode : "copy"
    tag "mosdepth $bam.baseName"

    input:
    tuple path(bam), path(bai)

    output:
    path "${bam.baseName}.mosdepth.global.dist.txt"
    path "${bam.baseName}.mosdepth.summary.txt"

    script:
    """
    mosdepth -n '${bam.baseName}' $bam
    """
}