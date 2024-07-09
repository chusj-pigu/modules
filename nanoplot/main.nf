process nanoplot {
    publishDir "${params.out_dir}/workflows", mode : "copy"
    
    input: 
    path reads

    output: 
    path "${reads.simpleName}"

    script:
    def type = params.skip_basecall ? "--fastq" : "--ubam"
    def qual = (params.model == 'sup') ? "10" : (params.model == 'hac') ? "9"
    """
    NanoPlot -t $task.cpus -p ${reads.simpleName} --minqual $qual $type $reads -o ${reads.simpleName}
    """
}