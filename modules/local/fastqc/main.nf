// Proceso FastQC usando BioContainer
process FASTQC {
    tag "$meta.id"
    label 'process_medium'
    
    publishDir "${params.outdir}/fastqc", mode: 'copy'

    input:
    tuple val(meta), path(reads)

    output:
    tuple val(meta), path("*.html"), emit: html
    tuple val(meta), path("*.zip"),  emit: zip
    path "versions.yml",             emit: versions

    when:
    task.ext.when == null || task.ext.when

    container 'biocontainers/fastqc:v0.11.9_cv8'

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    
    """
    fastqc \\
        $args \\
        --threads $task.cpus \\
        $reads

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        fastqc: \$(echo \$(fastqc --version 2>&1) | sed 's/^.*FastQC v//' ))
    END_VERSIONS
    """
}