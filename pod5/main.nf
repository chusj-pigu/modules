process pod5_channel {
    
    label "pod5"
    container="chrisamiller/pod5-tools:0.2.4"
    tag "$params.sample_id"
    
    input:
    tuple val(sample_id), path(pod5), path(ubam)

    
    output:
    tuple val(sample_id), path("pod5summary.tsv"), path(ubam)

    script:
    """
    pod5 view $pod5 --include "read_id, channel" --output pod5summary.tsv
    """
}

process subset {
    
    label "pod5"
    container="chrisamiller/pod5-tools:0.2.4"
    tag "$params.sample_id"

    input:
    tuple val(sample_id), path(pod5), path(ubam)
    tuple val(sample_id), path(tsv)
    
    output:
    tuple val(sample_id), path("split_by_channel"), path(ubam)

    script:
    """
    pod5 subset $pod5 --summary $tsv --columns channel --output split_by_channel
    """
}