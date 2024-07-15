process mapping {
    label "minimap"
    tag "mapping $params.sample_id"
    container="ghcr.io/bwbioinfo/minimap2-docker-cwl:latest"

    input:
    path ref
    path fastq

    output:
    path "${params.sample_id}.${ref.simpleName}.sam"

    script:
    """
    minimap2 -y -ax map-ont -t $params.threads $ref $fastq > "${params.sample_id}.${ref.simpleName}.sam"
    """
}

process mapping_amplicon {
    label "minimap"
    tag "mapping $sample"
    container="ghcr.io/bwbioinfo/minimap2-docker-cwl:latest"

    input:
    tuple path(sample), path(ref)

    output:
    path "${sample.simpleName}-${ref.simpleName}.sam"

    script:
    """
    minimap2 -t $params.threads -ax map-ont $ref $sample > "${sample.simpleName}-${ref.simpleName}.sam"
    """
}