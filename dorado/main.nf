process basecall {
    
    container="ghcr.io/bwbioinfo/dorado-docker-cwl:30bacb4dc96d82915eba9588eb1b38ea7c6cb91a"
    label "dorado"
    tag "basecalling $sample_id"

    input:
    tuple val(sample_id), path(pod5), path(ubam), val(model)

    output:
    tuple val(sample_id), path("*.bam")

    script:
    def call = params.duplex ? "duplex" : "basecaller"
    def mod = params.no_mod ? "" : (params.m_bases_path ? "--modified-bases-models ${params.m_bases_path}" : "--modified-bases ${params.m_bases}")
    def kit = params.demux != null ? "--kit-name $params.demux" : ""
    def b = params.batch ? "-b $params.batch" : ""
    def resume = ubam.name != 'NO_UBAM' ? "--resume-from $ubam > ${sample_id}_unaligned_final.bam" : "> ${sample_id}_unaligned.bam"
    """
    dorado $call $b $model $pod5 $mod $kit $resume
    """
}

process demultiplex {
    
    container="ghcr.io/bwbioinfo/dorado-docker-cwl:30bacb4dc96d82915eba9588eb1b38ea7c6cb91a"
    label "dorado"
    tag "demultiplexing $sample_id"

    input:
    tuple val(sample_id), path(bam)

    output:
    tuple val(sample_id), path("*.bam")

    script:
    """
    dorado demux --output_dir $sample_id --no_classify $bam
    """
}

