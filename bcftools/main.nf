process bcf_filterIDs {
    container="staphb/bcftools"
    label "bcf"
    tag "$type"

    input:
    tuple val(type), path(vcf), path(ids)

    output:
    tuple val(type), path("${params.sample_id}_${type}.filtered.vcf")

    script:
    """
    bcftools view --include ID==@$ids $vcf > ${params.sample_id}_${type}.filtered.vcf
    """
}