/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    SIMPLIFIED BIOPIPELINE - nf-core concepts without official modules
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow BIOPIPELINE {

    take:
    ch_samplesheet // channel: [ val(meta), path(reads) ]

    main:

    ch_versions = Channel.empty()
    
    //
    // PROCESS: FASTA validation with version tracking
    //
    VALIDATE_FASTA_NF (
        ch_samplesheet
    )
    ch_versions = ch_versions.mix(VALIDATE_FASTA_NF.out.versions.first())

    //
    // PROCESS: Analyze composition with version tracking
    //
    ANALYZE_COMPOSITION_NF (
        VALIDATE_FASTA_NF.out.validated
    )
    ch_versions = ch_versions.mix(ANALYZE_COMPOSITION_NF.out.versions.first())

    //
    // PROCESS: Count FASTA headers with version tracking
    //
    COUNT_FASTA_HEADERS_NF (
        VALIDATE_FASTA_NF.out.validated
    )
    ch_versions = ch_versions.mix(COUNT_FASTA_HEADERS_NF.out.versions.first())

    //
    // PROCESS: Create summary report (nf-core style)
    //
    SUMMARIZE_NF (
        COUNT_FASTA_HEADERS_NF.out.counts.collect{it[1]},
        ANALYZE_COMPOSITION_NF.out.composition.collect{it[1]}
    )
    ch_versions = ch_versions.mix(SUMMARIZE_NF.out.versions.first())

    //
    // PROCESS: Collect software versions (nf-core standard)
    //
    DUMP_VERSIONS (
        ch_versions.unique().collectFile(name: 'collated_versions.yml')
    )

    emit:
    composition = ANALYZE_COMPOSITION_NF.out.composition
    summary     = SUMMARIZE_NF.out.summary
    versions    = ch_versions                
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    LOCAL PROCESSES WITH NF-CORE STANDARDS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

process VALIDATE_FASTA_NF {
    tag "$meta.id"
    label 'process_single'

    conda "conda-forge::python=3.8.3"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/python:3.8.3' :
        'python:latest' }"

    input:
    tuple val(meta), path(fasta_file)

    output:
    tuple val(meta), path("*.valid.fasta"), emit: validated
    path "versions.yml",                    emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    grep -E '^>.*' $fasta_file > /dev/null || (echo "Invalid FASTA"; exit 1)
    cp $fasta_file ${prefix}.valid.fasta

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version | sed 's/Python //g')
        grep: \$(grep --version | head -n1 | sed 's/^.* //g')
    END_VERSIONS
    """
}

process ANALYZE_COMPOSITION_NF {
    tag "$meta.id"
    label 'process_single'
    publishDir "${params.outdir}/composition", mode: params.publish_dir_mode

    conda "conda-forge::bc"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/ubuntu:20.04' :
        'ubuntu:latest' }"

    input:
    tuple val(meta), path(fasta_file)

    output:
    tuple val(meta), path("*.composition.txt"), emit: composition
    path "versions.yml",                        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    # Install bc for calculations
    apt-get update > /dev/null 2>&1 && apt-get install -y bc > /dev/null 2>&1
    
    # Analyze nucleotide composition
    echo "Sample: ${meta.id}" > ${prefix}.composition.txt
    
    # Extract sequences without headers
    grep -v "^>" $fasta_file | tr -d '\\n' > sequences.txt
    
    # Count nucleotides
    total_length=\$(wc -c < sequences.txt)
    count_A=\$(grep -o "A\\|a" sequences.txt | wc -l)
    count_T=\$(grep -o "T\\|t" sequences.txt | wc -l)
    count_G=\$(grep -o "G\\|g" sequences.txt | wc -l)
    count_C=\$(grep -o "C\\|c" sequences.txt | wc -l)
    
    if [ \$total_length -gt 0 ]; then
        echo "Total length: \$total_length" >> ${prefix}.composition.txt
        echo "A: \$count_A (\$(echo "scale=2; \$count_A * 100 / \$total_length" | bc -l)%)" >> ${prefix}.composition.txt
        echo "T: \$count_T (\$(echo "scale=2; \$count_T * 100 / \$total_length" | bc -l)%)" >> ${prefix}.composition.txt
        echo "G: \$count_G (\$(echo "scale=2; \$count_G * 100 / \$total_length" | bc -l)%)" >> ${prefix}.composition.txt
        echo "C: \$count_C (\$(echo "scale=2; \$count_C * 100 / \$total_length" | bc -l)%)" >> ${prefix}.composition.txt
        echo "GC content: \$(echo "scale=2; (\$count_G + \$count_C) * 100 / \$total_length" | bc -l)%" >> ${prefix}.composition.txt
    else
        echo "Empty file" >> ${prefix}.composition.txt
    fi
    
    rm sequences.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        ubuntu: \$(cat /etc/os-release | grep VERSION_ID | cut -d'"' -f2)
        bc: \$(bc --version | head -n1 | sed 's/^.* //g')
    END_VERSIONS
    """
}

process COUNT_FASTA_HEADERS_NF {
    tag "$meta.id"
    label 'process_single'
    publishDir "${params.outdir}/counts", mode: params.publish_dir_mode

    conda "conda-forge::grep"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/ubuntu:20.04' :
        'ubuntu:latest' }"

    input:
    tuple val(meta), path(validated_file)

    output:
    tuple val(meta), path("*.count.txt"), emit: counts
    path "versions.yml",                  emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    grep -c '^>' $validated_file > ${prefix}.count.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        grep: \$(grep --version | head -n1 | sed 's/^.* //g')
    END_VERSIONS
    """
}

process SUMMARIZE_NF {
    label 'process_single'
    publishDir "${params.outdir}", mode: params.publish_dir_mode

    conda "conda-forge::python=3.8.3"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/python:3.8.3' :
        'python:latest' }"

    input:
    path count_files
    path composition_files

    output:
    path "summary_report.html", emit: summary
    path "summary.csv"
    path "versions.yml",        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    # Create CSV summary
    echo "file,sequences" > summary.csv
    for f in ${count_files}; do
        count=\$(cat \$f)
        name=\$(basename \$f .count.txt)
        echo "\$name.fasta,\$count" >> summary.csv
    done

    # Create HTML report (nf-core style)
    cat <<-EOF > summary_report.html
    <!DOCTYPE html>
    <html>
    <head>
        <title>Bio-NF-Core Pipeline Report</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 40px; }
            .header { background: #2E86AB; color: white; padding: 20px; border-radius: 5px; }
            .section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
            table { border-collapse: collapse; width: 100%; }
            th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
            th { background-color: #f2f2f2; }
        </style>
    </head>
    <body>
        <div class="header">
            <h1>🧬 Bio-NF-Core Pipeline Results</h1>
            <p>Ejercicio 3 - nf-core completo con reportes y versionado</p>
        </div>
        
        <div class="section">
            <h2>📊 Sequence Counts</h2>
            <table>
                <tr><th>File</th><th>Sequences</th></tr>
    EOF
    
    # Add count data to HTML
    while IFS=, read -r file count; do
        if [[ "\$file" != "file" ]]; then  # Skip header
            echo "                <tr><td>\$file</td><td>\$count</td></tr>" >> summary_report.html
        fi
    done < summary.csv
    
    cat <<-EOF >> summary_report.html
            </table>
        </div>
        
        <div class="section">
            <h2>🔬 Nucleotide Composition</h2>
    EOF
    
    # Add composition data
    for f in ${composition_files}; do
        echo "            <h3>\$(basename \$f .composition.txt)</h3>" >> summary_report.html
        echo "            <pre>" >> summary_report.html
        cat \$f >> summary_report.html
        echo "            </pre>" >> summary_report.html
    done
    
    cat <<-EOF >> summary_report.html
        </div>
        
        <div class="section">
            <h2>⚙️ Pipeline Info</h2>
            <p><strong>Generated by:</strong> Bio-NF-Core Ejercicio 3</p>
            <p><strong>Date:</strong> \$(date)</p>
            <p><strong>Nextflow version:</strong> \$NXF_VER</p>
        </div>
    </body>
    </html>
    EOF

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version | sed 's/Python //g')
    END_VERSIONS
    """
}

process DUMP_VERSIONS {
    label 'process_single'
    publishDir "${params.outdir}/pipeline_info", mode: params.publish_dir_mode

    conda "conda-forge::python=3.8.3"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/python:3.8.3' :
        'python:latest' }"

    input:
    path versions_yml

    output:
    path "software_versions.yml", emit: yml
    path "software_versions.txt", emit: txt
    path "versions.yml",          emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    # Copy versions file
    cp $versions_yml software_versions.yml
    
    # Create human readable versions
    echo "SOFTWARE VERSIONS" > software_versions.txt
    echo "=================" >> software_versions.txt
    python3 -c "
import yaml
import sys
with open('software_versions.yml', 'r') as f:
    data = yaml.safe_load(f)
for process, versions in data.items():
    print(f'{process}:')
    for tool, version in versions.items():
        print(f'  {tool}: {version}')
" >> software_versions.txt 2>/dev/null || echo "YAML parsing failed, raw versions:" >> software_versions.txt && cat software_versions.yml >> software_versions.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version | sed 's/Python //g')
    END_VERSIONS
    """
}