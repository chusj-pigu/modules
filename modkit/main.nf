process adjust_mods {
    container="ontresearch/modkit"
    publishDir "${params.out_dir}/modkit", mode: 'copy'
    label "modkit"
    tag "adjust_mod $params.sample_id"

    input:
    path bam

    output:
    path "${params.sample_id}.mod_adj.bam"

    script:
    """
    modkit adjust-mods -t $params.threads --convert h m $bam ${params.sample_id}.mod_adj.bam
    """
}

process extract {
    container="ontresearch/modkit"
    publishDir "${params.out_dir}/modkit", mode: 'copy'
    label "modkit"
    tag "extract $params.sample_id"

    input: 
    path adj_bam

    output:
    path "${params.sample_id}.mod_scores.txt"

    script:
    """
    modkit extract -t $params.threads $adj_bam ${params.sample_id}.mod_scores.txt
    """
}