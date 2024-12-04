process mosdepth {
    
    container="quay.io/biocontainers/mosdepth:0.3.3--h37c5b7d_2"
    publishDir "${params.out_dir}/reports/mosdepth_$out_name", mode: 'link', enabled: params.publish, pattern: '*.regions.bed.gz'
    tag "mosdepth $bam.baseName"
    label "mosdepth"

    input:
    tuple path(bam), path(bai)
    path bed
    val flag
    val qual
    val out_name

    output:
    path "*.dist.txt", emit: dist
    path "*.summary.txt", emit: summary
    path "*.bed.gz", emit: bed, optional: true

    script:
    def bedfile = bed.name != 'NO_BED' ? "-b $bed" : ""
    """
    mosdepth -n -F $flag -Q $qual $bedfile '${bam.baseName}_$out_name' $bam
    """
}