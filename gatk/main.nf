process gatk_table {
    container="broadinstitute/gatk"
    tag "$type"

    input:
    tuple val(type), path(vcf), val(field)

    output:
    tuple val(type), path("${params.sample_id}_${type}.table")

    script:
    """
    gatk VariantsToTable -V $vcf -F CHROM -F POS -F ID $field -O ${params.sample_id}_${type}.table --show-filtered
    """
}