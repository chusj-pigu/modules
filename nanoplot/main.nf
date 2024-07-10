process nanoplot {
    publishDir "${params.out_dir}/workflows", mode : "copy"
    
    input: 
    path reads

    output: 
    path "${reads.simpleName}"

    script:
    def type = params.skip_basecall ? "--fastq" : "--ubam"
    """
    NanoPlot -t $task.cpus -p ${reads.simpleName} --huge $type $reads -o ${reads.simpleName}
    """
}