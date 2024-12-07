process sam_sort {

    publishDir "${params.out_dir}/alignments", mode: 'link', enabled: params.publish
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

    publishDir "${params.out_dir}/reads", mode: 'link', enabled: params.publish
    label "sam_long"
    container="ghcr.io/bwbioinfo/samtools-docker-cwl:latest"
    tag "bam-fastq $ubam.baseName"

    input:
    path ubam

    output:
    path "${ubam.baseName}.fq.gz"

    script:
    def mod = params.no_mod ? "" : "-T '*'" 
    """
    samtools fastq $mod -@ $params.threads $ubam > ${ubam.baseName}.fq.gz
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
    samtools view --no-PG -@ $params.threads -e '[qs] >=$params.minqs' -b $ubam --output ${params.sample_id}_pass.bam --unoutput ${params.sample_id}_fail.bam
    """
}

process mergeChunks {
    
    container="ghcr.io/bwbioinfo/samtools-docker-cwl:latest"
    tag "merge $chunk"
    label "sam_mid"
    executor 'slurm'
    array 22
    
    input:
    tuple val(chunk), path(bam)
    
    output:
    path "${chunk}.bam"

    script:
    """
    samtools merge -@ ${params.threads} --no-PG "${chunk}.bam" $bam
    """
}

process mergeFinal {
    
    container="ghcr.io/bwbioinfo/samtools-docker-cwl:latest"
    publishDir "${params.out_dir}/alignments", mode: 'link', enabled: params.publish
    label "sam_big"

    input:
    path merged_bams

    output:
    tuple path("${params.sample_id}.hg38.bam"), path("${params.sample_id}.hg38.bam.bai")

    script:
    """
    samtools merge -@ $params.threads $merged_bams | samtools sort -@ $params.threads --write-index -o ${params.sample_id}.hg38.bam##idx##${params.sample_id}.h38.bam.bai
    """
}

process separate_panel {
    
    container="ghcr.io/bwbioinfo/samtools-docker-cwl:latest"
    publishDir "${params.out_dir}/alignments", mode: 'link', enabled: params.publish
    label "sam_mid"

    input:
    path bam
    path bed

    output:
    tuple path("${bam.baseName}_panel.bam"), path("${bam.baseName}_panel.bam.bai"), emit: panel
    tuple path("${bam.baseName}_bg.bam"), path("${bam.baseName}_bg.bam.bai"), emit: bg
    
    script:
    """
    samtools view -b -@ $params.threads -x MM,ML -L $bed --write-index -o ${bam.baseName}_panel.bam##idx##${bam.baseName}_panel.bam.bai -U ${bam.baseName}_bg.bam##idx##${bam.baseName}_bg.bam.bai $bam
    """
}