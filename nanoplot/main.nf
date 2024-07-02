process nanoplot {
    publishDir "${params.out_dir}", mode : "copy"
    
    input: 
    path fastq

    output: 
    path "reports"

    script:
    """
    NanoPlot -t $task.cpus --fastq $fastq -o reports
    """
}