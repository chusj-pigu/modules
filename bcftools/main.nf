process bcf_filterIDs {
    container="staphb/bcftools"
    label "bcf"
    tag "filter vcf"

    input:
    tuple val(tpye), path(vcf)
    tuple val(type), path(ids)

    output:
    tuple val(type), path("${params.sample_id}_${type}.filtered.vcf")

    script:
    """
    bcftools view --include ID==@$ids $vcf > ${params.sample_id}_${type}.filtered.vcf
    """
}

process bcf_selectFields {
    container="staphb/bcftools"
    label "bcf"
    tag "select fields vcf"

    input:
    tuple val(tpye), path(vcf)
    tuple val(type), val(fields)

    output:
    tuple val(type), path("${params.sample_id}_${type}.selected.vcf")

    script:
    """
    bcftools view -f '%CHROM %POS %ID $fields \n' $vcf > ${params.sample_id}_${type}.selected.vcf
    """
}