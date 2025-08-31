# Ejercicio 1: Nextflow Básico

## Objetivo
Aprender los conceptos fundamentales de Nextflow:
- Procesos (process)
- Canales (channels) 
- Workflows
- Contenedores básicos

## Estructura del Pipeline

Este pipeline procesa archivos FASTA y:
1. **Valida** que sean archivos FASTA válidos
2. **Cuenta** el número de secuencias (headers)  
3. **Resume** los resultados en un CSV

## Código Explicado

```nextflow
params.input = "data/*.fasta"    // Parámetro de entrada
```

### Proceso 1: Validación
```nextflow
process validateFasta {
    container 'python:latest'    // Contenedor Docker
    
    input:
    path fasta_file              // Archivo de entrada
    
    output:
    path "${fasta_file.simpleName}.valid.fasta"  // Archivo de salida
    
    script:
    """
    grep -E '^>.*' $fasta_file > /dev/null || (echo "Invalid FASTA"; exit 1)
    cp $fasta_file ${fasta_file.simpleName}.valid.fasta
    """
}
```

### Conceptos Clave:
- **container**: Especifica qué imagen Docker usar
- **input**: Define qué datos recibe el proceso
- **output**: Define qué archivos genera
- **script**: Código que se ejecuta (bash en este caso)

## Ejecutar el Pipeline

```bash
# Desde la carpeta del ejercicio 1
nextflow run main.nf -profile docker --input "../../data/test_data/*.fasta"
```

## Resultados Esperados

```
results/
├── summary.csv           # Resumen con conteo de secuencias
└── work/                # Archivos temporales de Nextflow
```

## Ejercicios Propuestos

1. **Modificar parámetros**: Cambiar el patrón de archivos de entrada
2. **Agregar validación**: Validar que las secuencias no estén vacías
3. **Cambiar contenedor**: Usar `ubuntu:latest` en lugar de `python:latest`
4. **Debug**: Agregar prints para ver qué está pasando

## Conceptos Aprendidos

✅ Sintaxis básica de Nextflow  
✅ Estructura process-workflow  
✅ Uso de contenedores Docker  
✅ Manejo de archivos y parámetros  
✅ Ejecución de comandos shell

## Próximo Paso
→ **Ejercicio 2**: Modularización y uso de BioContainers