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
    publishDir "${params.out_dir}/reads", mode: 'link', enabled: params.publish
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

process merge_barcode {
    publishDir "${params.out_dir}/reads", mode: 'link', enabled: params.publish
    label "cat"
    tag "merge $sample"

    input:
    tuple val(barcode), val(sample), path(fq)

    output:
    path "${sample}.fq.gz"

    script:
    """
    cat $fq > "${sample}.fq.gz"
    """
}

process vcf_to_table {
    label "grep" 
    tag "$type"

    input:
    tuple val(type), path(vcf)

    output:
    tuple val(type), path("${vcf.baseName}.table")

    when:
    type == 'qdnaseq'

    script:
    """
    grep -v '##' $vcf | sed 's/#//g' > ${vcf.baseName}.table
    """
}

process gzipd_vcf {
    label "gzip"
    tag "$type"

    input:
    tuple val(type), path(vcf)

    output:
    tuple val(type), path("${vcf.baseName}")

    script:
    """
    gzip -d -c $vcf > ${vcf.baseName}
    """
}


