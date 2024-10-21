process bcf_selectFields {
    container="staphb/bcftools"
    label "bcf"
    tag "select fields vcf"

    input:
    tuple val(tpye), path(vcf)
    tuple val(type), val(info)
    tuple val(type), val(format)

    output:
    tuple val(type), path("${params.sample_id}_${type}.selected.vcf")

    script:
    """
    bcftools view -f '%CHROM %POS %ID $fields \n' $vcf > ${params.sample_id}_${type}.selected.vcf
    """
}