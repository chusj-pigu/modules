process multiBamSummary {
    
    container="ghcr.io/bwbioinfo/deeptools-docker-cwl:latest"
    label "deeptools"
    tag "multibam $fasta"
    publishDir "${params.out_dir}/reports", mode: 'link'

    input:
    tuple val(fasta), path(bam), path(bai)

    output:
    tuple path("${fasta}_readCounts.npz"), path("${fasta}_readCounts.tab")

    script:
    """
    multiBamSummary bins --binSize 50 -b $bam --minMappingQuality 30 -out ${fasta}_readCounts.npz --outRawCounts ${fasta}_readCounts.tab
    """
}