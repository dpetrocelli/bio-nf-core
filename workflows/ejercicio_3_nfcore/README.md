# Ejercicio 3: Pipeline nf-core Completo

## Objetivo
Implementar un pipeline siguiendo los estándares nf-core **reales**:
- Validación de parámetros con schema JSON
- Versionado obligatorio de software
- Estructura modular profesional
- Reportes consolidados (estilo MultiQC)
- Contenedores especializados

## Diferencias Clave vs Ejercicios Anteriores

| Aspecto | Ejercicio 1-2 | Ejercicio 3 nf-core |
|---------|---------------|---------------------|
| **Validación** | Manual | Schema JSON automático |
| **Versionado** | No obligatorio | Cada proceso reporta versiones |
| **Estructura** | Libre | Convenciones nf-core estrictas |
| **Reportes** | Separados | HTML consolidado |
| **Contenedores** | Ad-hoc | Especificados por proceso |
| **Documentación** | Manual | Auto-generada desde schema |

## Estructura del Ejercicio

```
ejercicio_3_nfcore/
├── main.nf                     # Entry point con validación
├── nextflow_schema.json        # 🆕 Validación de parámetros
├── workflows/
│   └── simple_biopipeline.nf   # 🆕 Workflow con estándares nf-core
└── README.md                   # Esta documentación
```

## Conceptos nf-core Implementados

### 1. Schema de Validación
El archivo `nextflow_schema.json` define automáticamente:
- Tipos de parámetros permitidos
- Validación de formatos de archivo
- Documentación de cada opción
- Valores por defecto

```json
{
  "input": {
    "type": "string",
    "pattern": "^\\S+\\.(fasta|fa|fas)$",
    "description": "Path to FASTA files"
  }
}
```

### 2. Versionado Automático de Software
Cada proceso **debe** reportar versiones:

```nextflow
process VALIDATE_FASTA_NF {
    output:
    path "versions.yml", emit: versions
    
    script:
    """
    # Tu código aquí
    
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version | sed 's/Python //g')
    END_VERSIONS
    """
}
```

### 3. Contenedores por Proceso
Cada proceso especifica su contenedor según nf-core:

```nextflow
container "${ workflow.containerEngine == 'singularity' ? 
    'https://depot.galaxyproject.org/singularity/python:3.8.3' : 
    'python:latest' }"
```

### 4. Labels de Recursos
Clasificación estándar de recursos:

```nextflow
label 'process_single'  // 1 CPU, 6GB RAM, 4h
label 'process_low'     // 2 CPU, 12GB RAM, 4h
label 'process_medium'  // 6 CPU, 36GB RAM, 8h
```

### 5. Publishdir Condicional
Publicación inteligente de archivos:

```nextflow
publishDir "${params.outdir}/composition", mode: params.publish_dir_mode
```

## Ejecutar el Pipeline

### Prerequisitos
```bash
# Activar entorno (si tienes nf-core tools)
source .venv/bin/activate

# Verificar schema (opcional)
nextflow run main.nf --help
```

### Ejecución
```bash
# Desde la carpeta del ejercicio 3
cd workflows/ejercicio_3_nfcore/

# Ejecutar con validación automática
nextflow run main.nf -profile docker --input "../../data/test_data/*.fasta"

# Verificar parámetros automáticamente
nextflow run main.nf --input "invalid.txt"  # ❌ Error automático
```

## Resultados Esperados (nf-core style)

```
results/
├── composition/
│   ├── sample1.composition.txt
│   └── sample2.composition.txt
├── counts/  
│   ├── sample1.count.txt
│   └── sample2.count.txt
├── summary_report.html         # 🆕 Reporte HTML consolidado
├── summary.csv
└── pipeline_info/              # 🆕 Información del pipeline
    ├── software_versions.yml   # 🆕 Versiones automáticas
    ├── software_versions.txt   # 🆕 Versiones legibles
    └── execution_*.html        # 🆕 Reportes Nextflow
```

### Reporte HTML Consolidado
El archivo `summary_report.html` incluye:
- 📊 Tabla de conteos de secuencias
- 🔬 Análisis de composición por muestra  
- ⚙️ Versiones de software utilizadas
- 📅 Metadata del pipeline

## Issues Encontrados y Soluciones

### ❌ Error: "No such variable: WorkflowMain"
**Problema**: `WorkflowMain.initialise()` requiere librerías nf-core oficiales.
**Solución**: Implementamos validación manual básica manteniendo los conceptos.

### ❌ Error: "No such property: multiqc_report" 
**Problema**: Outputs incorrectos entre workflows.
**Solución**: Matching exacto de outputs entre workflows padre e hijo.

### ❌ Error: "No module named 'nf_core'"
**Problema**: Instalación compleja de nf-core tools.
**Solución**: Pipeline funciona sin nf-core tools, siguiendo las convenciones.

## Conceptos nf-core Aprendidos

✅ **Schema validation**: Parámetros validados por tipo y formato  
✅ **Mandatory versioning**: Cada herramienta reporta su versión  
✅ **Resource labels**: Clasificación estándar de recursos  
✅ **Container specification**: Soporte Singularity + Docker  
✅ **Conditional publishing**: Publicación inteligente por modo  
✅ **Consolidated reports**: HTML único con toda la información  
✅ **Pipeline metadata**: Información completa de ejecución  

## Para Producción Real

Para implementar un pipeline nf-core completo en producción:

1. **Usar nf-core tools**: `nf-core create`, `nf-core lint`
2. **Módulos oficiales**: `nf-core modules install fastqc`
3. **CI/CD completo**: GitHub Actions con testing automático
4. **MultiQC real**: Reportes consolidados profesionales
5. **Documentación**: Auto-generada desde schema JSON

## Comandos Útiles (con nf-core tools)

```bash
# Crear pipeline desde template
nf-core create mipipeline

# Instalar módulo oficial  
nf-core modules install fastqc

# Validar estándares
nf-core lint

# Generar documentación
nf-core schema docs
```

Este ejercicio muestra **todos los conceptos clave** de nf-core sin la complejidad de configurar las herramientas completas, preparándote para pipelines profesionales.