process predict {
    
    publishDir "${params.out_dir}/sturgeon", mode: 'link'
    container="ghcr.io/charlenelawdes/sturgeon-docker:latest"
    tag "sturgeon predict $params.sample_id"

    input: 
    path calls
    path model

    output:
    path 'sturgeon'

    script:
    """
    /sturgeon/venv/bin/sturgeon predict -i $calls -o sturgeon --model-files $model --plot-results
    """
}

process inputtobed {
    
    container="ghcr.io/charlenelawdes/sturgeon-docker:latest"
    tag "sturgeon bed $params.sample_id"

    input: 
    path modkit

    output:
    path 'sturgeon'

    script:
    """
    /sturgeon/venv/bin/sturgeon inputtobed -i $modkit -o sturgeon -s modkit
    """
}