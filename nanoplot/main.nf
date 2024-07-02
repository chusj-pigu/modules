process nanoplot {
    publishDir "${params.out_dir}/reports", mode : "copy"
    
    input: 
    path fastq

    output: 
    path "nanoplot"

    script:
    """
    NanoPlot -t $task.cpus --fastq $fastq -o nanoplot
    """
}