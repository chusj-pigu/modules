process gather_sturgeon {
    memory '5G'
    tag "gather $params.sample_id"

    input:
    path adj
    path scores

    output:
    path "modkit"

    script :
    """
    mkdir -p modkit
    cp $adj modkit
    cp $scores modkit
    """
}

process merge_amplicon {
    label "cat"
    publishDir "${params.out_dir}/reads"
    tag "merge $sample"

    input:
    tuple val(sample), val(fasta), val(barcode)

    output:
    tuple path("${sample}.fq.gz"), path("${fasta}.fq.gz")

    script:
    """
    cat ${params.in_dir}/${barcode}/* > "${sample}.fq.gz"
    if [ -d ${params.ref_dir}/${fasta} ]; then
        cat ${params.ref_dir}/${fasta}/* > ${fasta}.fq.gz
    else
        mv ${params.ref_dir}/${fasta} ${fasta}.fq.gz
    fi
    """
}

process merge_cDNA {
    label "cat"
    publishDir "${params.out_dir}/reads", mode : "copy"
    tag "merge $sample"

    input:
    tuple val(sample), val(barcode)

    output:
    path "${sample}.fq.gz"

    script:
    """
    cat ${params.in_dir}/${barcode}/* > "${sample}.fq.gz"
    """
}

process merge_glob {
    label "cat"
    publishDir "${params.out_dir}/reads", mode : "copy"

    input:
    path fq_pass_files

    output:
    path '${params.sample_id}_merged.fq.gz'

    script:
    """
    cat ${fq_pass_files.join(' ')} > ${params.sample_id}_merged.fq.gz
    """
}