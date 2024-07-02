process qs_filter {
    label "sam_sm"

    input:
    path ubam

    output:
    path "${ubam.baseName}.bam", emit: ubam_pass
    path "${ubam.baseName}_fail.bam", emit: ubam_fail

    script:
    """
    samtools view --no-PG -@ $params.threads -e '[qs] >=10' -b $ubam --output ${ubam.baseName}.bam --unoutput ${ubam.baseName}_fail.bam
    """
}