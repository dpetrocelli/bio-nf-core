/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    PARAMETERS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

params.input = "data/*.fasta"
params.outdir = "results"

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES/SUBWORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

// include { FASTQC } from '../../modules/local/fastqc/main'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    WORKFLOW PRINCIPAL
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

// Pipeline original reorganizado
process VALIDATE_FASTA {
    tag "$meta.id"
    
    input:
    tuple val(meta), path(fasta_file)
    
    output:
    tuple val(meta), path("*.valid.fasta"), emit: validated
    
    container 'python:latest'
    
    script:
    """
    grep -E '^>.*' $fasta_file > /dev/null || (echo "Invalid FASTA"; exit 1)
    cp $fasta_file ${meta.id}.valid.fasta
    """
}

process COUNT_FASTA_HEADERS {
    tag "$meta.id"
    publishDir "${params.outdir}/counts", mode: 'copy'
    
    input:
    tuple val(meta), path(validated_file)
    
    output:
    tuple val(meta), path("*.count.txt"), emit: counts
    
    container 'python:latest'
    
    script:
    """
    grep -c '^>' $validated_file > ${meta.id}.count.txt
    """
}

process ANALYZE_COMPOSITION {
    tag "$meta.id"
    publishDir "${params.outdir}/composition", mode: 'copy'
    
    input:
    tuple val(meta), path(fasta_file)
    
    output:
    tuple val(meta), path("*.composition.txt"), emit: composition
    
    container 'ubuntu:latest'
    
    script:
    """
    # Contar nucleótidos usando herramientas bash
    echo "Sample: ${meta.id}" > ${meta.id}.composition.txt
    
    # Extraer solo secuencias (sin headers)
    grep -v "^>" $fasta_file | tr -d '\\n' > sequences.txt
    
    # Contar cada nucleótido
    total_length=\$(wc -c < sequences.txt)
    count_A=\$(grep -o "A\\|a" sequences.txt | wc -l)
    count_T=\$(grep -o "T\\|t" sequences.txt | wc -l)
    count_G=\$(grep -o "G\\|g" sequences.txt | wc -l)
    count_C=\$(grep -o "C\\|c" sequences.txt | wc -l)
    count_N=\$(grep -o "N\\|n" sequences.txt | wc -l)
    
    # Calcular porcentajes
    if [ \$total_length -gt 0 ]; then
        echo "Total length: \$total_length" >> ${meta.id}.composition.txt
        echo "A: \$count_A (\$(echo "scale=2; \$count_A * 100 / \$total_length" | bc -l)%)" >> ${meta.id}.composition.txt
        echo "T: \$count_T (\$(echo "scale=2; \$count_T * 100 / \$total_length" | bc -l)%)" >> ${meta.id}.composition.txt
        echo "G: \$count_G (\$(echo "scale=2; \$count_G * 100 / \$total_length" | bc -l)%)" >> ${meta.id}.composition.txt
        echo "C: \$count_C (\$(echo "scale=2; \$count_C * 100 / \$total_length" | bc -l)%)" >> ${meta.id}.composition.txt
        echo "GC content: \$(echo "scale=2; (\$count_G + \$count_C) * 100 / \$total_length" | bc -l)%" >> ${meta.id}.composition.txt
        echo "N/Unknown: \$count_N (\$(echo "scale=2; \$count_N * 100 / \$total_length" | bc -l)%)" >> ${meta.id}.composition.txt
    else
        echo "Empty file" >> ${meta.id}.composition.txt
    fi
    
    rm sequences.txt
    """
}

process SUMMARIZE {
    publishDir "${params.outdir}", mode: 'copy'
    
    input:
    path count_files
    
    output:
    path "summary.csv"
    
    container 'python:latest'
    
    script:
    """
    echo "file,sequences" > summary.csv
    for f in ${count_files}; do
        count=\$(cat \$f)
        name=\$(basename \$f .count.txt)
        echo "\$name.fasta,\$count" >> summary.csv
    done
    """
}

workflow BIO_PIPELINE {
    
    take:
    ch_input    // channel: [ val(meta), path(fasta) ]
    
    main:
    
    // Validar archivos FASTA
    VALIDATE_FASTA(ch_input)
    
    // Analizar composición de nucleótidos con BioContainer
    ANALYZE_COMPOSITION(VALIDATE_FASTA.out.validated)
    
    // Contar headers
    COUNT_FASTA_HEADERS(VALIDATE_FASTA.out.validated)
    
    // Crear resumen
    SUMMARIZE(COUNT_FASTA_HEADERS.out.counts.collect{it[1]})
    
    emit:
    composition = ANALYZE_COMPOSITION.out.composition
    summary     = SUMMARIZE.out
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow {
    
    // Crear canal de entrada con metadatos
    ch_input = Channel
        .fromPath(params.input)
        .map { file ->
            def meta = [:]
            meta.id = file.simpleName
            [ meta, file ]
        }
    
    // Ejecutar pipeline principal
    BIO_PIPELINE(ch_input)
}