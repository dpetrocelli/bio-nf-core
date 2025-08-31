# Ejercicio 2: Nextflow Modular con BioContainers

## Objetivo
Aprender modularización y uso de contenedores especializados:
- Workflows anidados
- Metadatos en canales
- BioContainers especializados
- Configuración avanzada de procesos

## Novedades vs Ejercicio 1

### 1. Metadatos en Canales
```nextflow
// Antes (Ejercicio 1)
Channel.fromPath(params.input)

// Ahora (Ejercicio 2) 
Channel.fromPath(params.input)
    .map { file ->
        def meta = [:]
        meta.id = file.simpleName
        [ meta, file ]
    }
```

**¿Por qué?** Permite trackear información adicional de cada muestra.

### 2. Contenedor Especializado para Análisis
```nextflow
// Análisis de composición con contenedor Ubuntu
process ANALYZE_COMPOSITION {
    container 'ubuntu:latest'  // Contenedor diferente por proceso
    
    input:
    tuple val(meta), path(fasta_file)     // Metadatos + archivo
    
    output:
    tuple val(meta), path("*.composition.txt"), emit: composition
}
```

**Nota**: Originalmente planeamos usar FastQC, pero FastQC es para archivos FASTQ (reads), no FASTA. Por eso creamos un análisis de composición de nucleótidos más apropiado.

### 3. Workflow Modular
```nextflow
workflow BIO_PIPELINE {
    take:
    ch_input    // Define qué recibe el workflow
    
    main:
    VALIDATE_FASTA(ch_input)
    FASTQC(VALIDATE_FASTA.out.validated)
    
    emit:
    fastqc_html = FASTQC.out.html    // Define qué exporta
}
```

## Estructura del Pipeline

```
ejercicio_2_modular/
├── main.nf           # Workflow principal
└── README.md         # Esta documentación
```

**Usa módulos de**: `../../modules/local/fastqc/main.nf`

## Pipeline Flow

```
Archivos FASTA → Validación → FastQC → Conteo → Resumen
                      ↓           ↓        ↓
                 .valid.fasta  .html/.zip .count.txt
```

## Ejecutar el Pipeline

```bash
# Desde la carpeta del ejercicio 2
nextflow run main.nf -profile docker --input "../../data/test_data/*.fasta"
```

## Resultados Esperados

```
results/
├── composition/
│   ├── sample1.composition.txt  # Análisis de nucleótidos
│   └── sample2.composition.txt  # A, T, G, C, GC content
├── counts/
│   ├── sample1.count.txt        # Número de secuencias
│   └── sample2.count.txt
└── summary.csv                  # Resumen consolidado
```

### Ejemplo de análisis de composición:
```
Sample: sample1
Total length: 287
A: 71 (24.73%)
T: 72 (25.08%)
G: 72 (25.08%)
C: 72 (25.08%)
GC content: 50.17%
N/Unknown: 0 (0%)
```

## Conceptos Nuevos

### BioContainers
- **Especializados**: Cada herramienta tiene su contenedor optimizado
- **Versionado**: `v0.11.9_cv8` garantiza reproducibilidad
- **Mantenidos**: Por la comunidad bioinformática

### Metadatos  
- **Trackeo**: Mantener información de cada muestra
- **Identificación**: `meta.id` para nombrar outputs
- **Extensibilidad**: Se pueden agregar más campos

### Outputs Nombrados
```nextflow
output:
tuple val(meta), path("*.html"), emit: html  // Se puede acceder como FASTQC.out.html
```

## Ejercicios Propuestos

1. **Agregar MultiQC**: Consolidar reportes FastQC en uno solo
2. **Más metadatos**: Agregar fecha, tipo de muestra, etc.
3. **Procesos condicionales**: Solo ejecutar FastQC si la validación pasa
4. **Paralelización**: Procesar múltiples archivos simultáneamente

## Conceptos Aprendidos

✅ Workflows modulares anidados  
✅ BioContainers especializados  
✅ Metadatos en canales  
✅ Outputs nombrados y emisiones  
✅ Configuración avanzada de procesos  

## Próximo Paso
→ **Ejercicio 3**: Pipeline nf-core completo con validación automática