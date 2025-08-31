params.input = "data/*.fasta"

process validateFasta {
    input:
    path fasta_file
    output:
    path "${fasta_file.simpleName}.valid.fasta"

    container 'python:latest'

    script:
    """
    grep -E '^>.*' $fasta_file > /dev/null || (echo "Invalid FASTA"; exit 1)
    cp $fasta_file ${fasta_file.simpleName}.valid.fasta
    """
}

process count_fasta_headers {
    input:
    path validated_file
    output:
    path "${validated_file.simpleName}.count.txt"

    container 'python:latest'

    script:
    """
    grep -c '^>' $validated_file > ${validated_file.simpleName}.count.txt
    """
}

process summarize {
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

workflow {
    fasta_files = Channel.fromPath(params.input)
    validated = validateFasta(fasta_files)
    counts = count_fasta_headers(validated)
    summarize(counts.collect())
}
