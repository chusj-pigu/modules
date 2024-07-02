process qs_filter {
    label "sam_sm"

    input:
    path ubam

    output:
    path "${params.sample_id}.bam", emit: ubam_pass
    path "${params.sample_id}_fail.bam", emit: ubam_fail

    script:
    """
    samtools view --no-PG -@ $params.threads -e '[qs] >=10' -b $ubam --output ${params.sample_id}.bam --unoutput ${params.sample_id}_fail.bam
    """
}