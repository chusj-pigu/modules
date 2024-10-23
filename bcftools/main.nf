process bcf_selectFields {
    container="staphb/bcftools"
    label "bcf"
    tag "$type"
    executor 'slurm'
    array 3

    input:
    tuple val(type), path(vcf), val(fields)

    output:
    tuple val(type), path("${params.sample_id}_${type}.selected.vcf")

    script:
    """
    bcftools view -f '%CHROM %POS %ID %REF %ALT $fields \n' $vcf > ${params.sample_id}_${type}.selected.vcf
    """
}