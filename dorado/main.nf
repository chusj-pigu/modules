process basecall {
    container="ghcr.io/bwbioinfo/dorado-docker-cwl:latest"
    label "dorado"
    tag "basecalling $params.sample_id"

    input:
    path pod5
    val model

    output:
    path "${params.sample_id}_unaligned.bam"

    script:
    def call = params.duplex ? "duplex" : "basecaller"
    def mod = params.no_mod ? "" : (params.m_bases_path ? "--modified-bases-models ${params.m_bases_path}" : "--modified-bases ${params.m_bases}")
    def dev = params.dorado_cpu ? '-x "cpu"' : ""
    def b = params.batch ? "-b $params.batch" : ""
    """
    dorado $call $b $dev $model $pod5 $mod > ${params.sample_id}_unaligned.bam
    """
}

