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
    publishDir "${params.out_dir}/reads", mode: 'copy'
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
    label "cat"
    tag "merge $sample"

    input:
    tuple val(sample), val(barcode)

    output:
    path "${sample}.fq.gz"

    script:
    """
    find ${params.in_dir}/${barcode} -type f | xargs cat > ${sample}.fq.gz
    """
}

process grep_vcfIDs {
    label "grep" 
    tag "$type"

    input:
    tuple val(type), path(vcf), val(pattern)

    output:
    tuple val(type), path("${params.sample_id}_${type}.ids")

    script:
    """
    grep -oE "${pattern}" $vcf > ${params.sample_id}_${type}.ids || touch ${params.sample_id}_${type}.ids
    """
}

process grep_fusion {
    label "grep" 
    tag "$type"

    input:
    tuple val(type), path(vcf)

    output:
    tuple val(type), path("${params.sample_id}_${type}.vcf"), optional:true

    when:
    type == 'fusion'

    script:
    """
    grep 'gene_fusion' $vcf > ${params.sample_id}_${type}.vcf || touch ${params.sample_id}_${type}.vcf
    """
}

process grep_vcfGenes {
    label "grep" 
    tag "$type"

    input:
    tuple val(type), path(vcf)

    output:
    tuple val(type), path("${params.sample_id}_${type}.genes.vcf"), optional: true

    script:
    def genes_filter = params.gene_list.endsWith('NO_FILE') ? "-v -f $params.gene_list" : "-f $params.gene_list"
    """
    grep $genes_filter $vcf > ${params.sample_id}_${type}.genes.vcf || touch ${params.sample_id}_${type}.genes.vcf
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

process publish_artifact {
    publishDir "${params.out_dir}/${params.out_sub}", mode: 'copy', pattern: "*"
   
    input:
    path fname
   
    output:
    path fname

    script:
    """
    echo "Writing output files"
    """
}
