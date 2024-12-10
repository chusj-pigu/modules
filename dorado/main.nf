process basecall {
    
    container="ghcr.io/bwbioinfo/dorado-docker-cwl:latest"
    label "dorado"
    tag "basecalling $params.sample_id"

    input:
    tuple val(sample_id), path(pod5), val(ubam), val(model)

    output:
    tuple val(sample_id), path("*.bam")

    script:
    def call = params.duplex ? "duplex" : "basecaller"
    def mod = params.no_mod ? "" : (params.m_bases_path ? "--modified-bases-models ${params.m_bases_path}" : "--modified-bases ${params.m_bases}")
    def dev = params.dorado_cpu ? '-x "cpu"' : ""
    def b = params.batch ? "-b $params.batch" : ""
    def resume = ubam != 'null' ? "--resume-from $ubam > ${sample_id}_unaligned_final.bam" : "> ${sample_id}_unaligned.bam"
    """
    dorado $call $b $dev $model $pod5 $mod $resume
    """
}

