process nanoplot {
    publishDir "${params.out_dir}/workflows", mode: 'copy'
    container="nanozoo/nanoplot:1.42.0--547049c"
    tag "nanoplot $reads.simpleName"
    
    input: 
    path reads

    output: 
    path "Nanoplot/${reads.simpleName}"

    script:
    def type = params.skip_basecall ? "--fastq" : "--ubam"
    """
    NanoPlot -t $task.cpus -p ${reads.simpleName} --minqual 10 --huge $type $reads -o Nanoplot/${reads.simpleName}
    """
}