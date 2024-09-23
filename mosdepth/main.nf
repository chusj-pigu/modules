process mosdepth {
    container="quay.io/biocontainers/mosdepth:0.3.3--h37c5b7d_2"
    publishDir "${params.out_dir}/reports/mosdepth", mode: 'copy'
    tag "mosdepth $bam.baseName"
    label "mosdepth"

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

process mosdepth_bed {
    container="quay.io/biocontainers/mosdepth:0.3.3--h37c5b7d_2"
    publishDir "${params.out_dir}/reports/mosdepth", mode: 'copy'
    tag "mosdepth $bam.baseName"
    label "mosdepth"

    input:
    tuple path(bam), path(bai)
    path(bed)

    output:
    path "${bam.baseName}.mosdepth.global.dist.txt"
    path "${bam.baseName}.mosdepth.summary.txt"
    path "${bam.baseName}.regions.bed.gz"

    script:
    """
    mosdepth -n '${bam.baseName}' -b $bed $bam
    """
}