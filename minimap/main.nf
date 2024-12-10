process mapping {
    
    label "minimap"
    tag "mapping $params.sample_id"
    container="ghcr.io/bwbioinfo/minimap2-docker-cwl:3dcd900155cddf797802bf4676545af87d9e0821"
    array 10

    input:
    path ref
    tuple val(sample_id), path(fastq)

    output:
    tuple val(sample_id), path("${sample_id}.${ref.simpleName}.sam")

    script:
    """
    minimap2 -y -ax map-ont -t $params.threads $ref $fastq > ${sample_id}.${ref.simpleName}.sam
    """
}

process mapping_amplicon {
    
    label "minimap"
    tag "mapping $sample"
    container="ghcr.io/bwbioinfo/minimap2-docker-cwl:3dcd900155cddf797802bf4676545af87d9e0821"

    input:
    tuple path(sample), path(ref)

    output:
    path "${sample.simpleName}-${ref.simpleName}.sam"

    script:
    """
    minimap2 -t $params.threads -ax map-ont $ref $sample > "${sample.simpleName}-${ref.simpleName}.sam"
    """
}