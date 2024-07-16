process sam_sort {
    publishDir "${params.out_dir}/alignments", mode: 'copy'
    label "sam_big"
    container="ghcr.io/bwbioinfo/samtools-docker-cwl:latest"
    tag "sam_sort $sam.baseName"

    input: 
    path sam

    output:
    tuple path("${sam.baseName}.bam"), path("${sam.baseName}.bam.bai")
    
    script:
    """
    samtools view --no-PG -@ $params.threads -Sb $sam \
    | samtools sort -@ $params.threads --write-index -o ${sam.baseName}.bam##idx##${sam.baseName}.bam.bai
    """
}

process ubam_to_fastq {
    publishDir "${params.out_dir}/reads", mode: 'copy'
    label "sam_long"
    container="ghcr.io/bwbioinfo/samtools-docker-cwl:latest"
    tag "bam-fastq $ubam.baseName"

    input:
    path ubam

    output:
    path "${params.sample_id}_pass.fq.gz"

    script:
    def mod = params.no_mod ? "" : "-T '*'" 
    """
    samtools fastq $mod -@ $params.threads $ubam | gzip > "${params.sample_id}_pass.fq.gz" 
    """
}

process qs_filter {
    label "sam_sm"
    container="ghcr.io/bwbioinfo/samtools-docker-cwl:latest"
    tag "qc $ubam.baseName"

    input:
    path ubam

    output:
    path "${params.sample_id}_pass.bam", emit: ubam_pass
    path "${params.sample_id}_fail.bam", emit: ubam_fail

    script:
    """
    samtools view --no-PG -@ $params.threads -e '[qs] >=10' -b $ubam --output ${params.sample_id}_pass.bam --unoutput ${params.sample_id}_fail.bam
    """
}