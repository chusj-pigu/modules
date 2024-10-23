process gatk_table {
    container="broadinstitute/gatk"
    tag "$type"
    executor 'slurm'
    array 3

    input:
    tuple val(type), path(vcf), val(field)

    output:
    tuple val(type), path("${params.sample_id}_${type}.table")

    script:
    """
    gatk VariantsToTable -V $vcf -F CHROM -F POS -F ID -F REF -F ALT $field -O ${params.sample_id}_${type}.table --show-filtered
    """
}