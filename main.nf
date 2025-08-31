#!/usr/bin/env nextflow

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Bio-NF-Core Pipeline Principal
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

nextflow.enable.dsl = 2

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT WORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    WORKFLOW PRINCIPAL - SELECTOR DE EJERCICIOS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow {
    
    println """
    
    =====================================
     Bio-NF-Core - Selector de Ejercicios
    =====================================
    
    Para ejecutar los ejercicios, usa:
    
    📚 EJERCICIO 1 - Nextflow Básico:
    cd workflows/ejercicio_1_basico/
    nextflow run main.nf -profile docker --input "../../data/test_data/*.fasta"
    
    📚 EJERCICIO 2 - Nextflow Modular:  
    cd workflows/ejercicio_2_modular/
    nextflow run main.nf -profile docker --input "../../data/test_data/*.fasta"
    
    📚 EJERCICIO 3 - nf-core Completo:
    cd workflows/ejercicio_3_nfcore/
    nextflow run main.nf -profile docker --input "../../data/test_data/*.fasta"
    
    📖 Ver documentación completa: README.md
    
    =====================================
    """
    
    // Salir sin ejecutar nada
    exit 0
}