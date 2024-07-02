process nanoplot {
    publishDir "${params.out_dir}/reports", mode : "copy"
    
    input: 
    path reads

    output: 
    path "nanoplot"

    script:
    def type = params.skip_basecall ? "--fastq" : "--ubam"
    """
    NanoPlot -t $task.cpus --minqual 10 $in_type $reads -o nanoplot 
    """
}