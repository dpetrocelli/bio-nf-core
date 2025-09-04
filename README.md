# Bio-NF-Core: Pipeline Bioinformático Educativo

## Descripción del Curso
**DENOMINACIÓN DE LA ACTIVIDAD**: Diseño de Pipelines Bioinformáticos Escalables: Automatización, Contenedores y Nube

Este repositorio contiene ejercicios progresivos para aprender:
- **Unidad 2**: Uso de contenedores (Docker) para reproducibilidad  
- **Unidad 3**: Versionado, estructura nf-core y colaboración

## Estructura del Proyecto
fgsdfgsdfg
```
bio-nf-core/
├── workflows/                 # 📚 Ejercicios progresivos
│   ├── ejercicio_1_basico/   # Nextflow básico
│   ├── ejercicio_2_modular/  # Nextflow modular + BioContainers  
│   └── ejercicio_3_nfcore/   # Pipeline nf-core completo
├── docker/                   # 🐳 Contenedores personalizados
├── modules/                  # 🧩 Procesos reutilizables
├── conf/                     # ⚙️ Configuraciones
├── data/test_data/          # 🧬 Datos de prueba
└── docs/                    # 📖 Documentación educativa
```

## Progresión de Aprendizaje

### 1. Ejercicio Básico (Nextflow Puro)
- Conceptos fundamentales
- Procesos y workflows simples
- Contenedores básicos

### 2. Ejercicio Modular 
- Estructura modular
- BioContainers especializados (FastQC)
- Metadatos en canales

### 3. Ejercicio nf-core
- Validación automática de parámetros
- Versionado de software
- MultiQC y reportes consolidados

## Prerequisitos

⚠️ **IMPORTANTE**: Leer [PREREQUISITES.md](PREREQUISITES.md) antes de comenzar

### Requisitos mínimos:
- Java 17+
- Nextflow 25.04+
- Docker
- Python 3.8+ (para ejercicio 3)

### Setup rápido:
```bash
# 1. Instalar Java y Nextflow (ver PREREQUISITES.md)
java -version    # Debe ser 17+
nextflow -version

# 2. Clonar repositorio
git clone <repo-url>
cd bio-nf-core

# 3. Para ejercicio 3 (nf-core), instalar dependencias
./setup.sh
source .venv/bin/activate
```

## 🚀 Ejecutar Ejercicios

### ⚠️ **IMPORTANTE**: Los ejercicios deben ejecutarse desde sus directorios específicos

```bash
# ❌ NO ejecutar desde la raíz:
nextflow run main.nf  # Error: archivos no encontrados

# ✅ Ejecutar desde cada directorio de ejercicio:

# 📚 Ejercicio 1: Básico
cd workflows/ejercicio_1_basico/
nextflow run main.nf -profile docker --input "../../data/test_data/*.fasta"

# 📚 Ejercicio 2: Modular  
cd ../ejercicio_2_modular/
nextflow run main.nf -profile docker --input "../../data/test_data/*.fasta"

# 📚 Ejercicio 3: nf-core
cd ../ejercicio_3_nfcore/
nextflow run main.nf -profile docker --input "../../data/test_data/*.fasta"
```

### 🔍 **Selector de Ejercicios**
Si ejecutas desde la raíz, verás un menú de ayuda:
```bash
# Desde la raíz del proyecto
nextflow run main.nf  # Muestra instrucciones
```

## Documentación

- `workflows/README.md` - Guía de ejercicios progresivos
- `docker/README_containers.md` - Contenedores en bioinformática  
- `docs/nextflow_vs_nfcore.md` - Comparación Nextflow vs nf-core
- **`docs/execution_modes.md` - 🆕 Modos de ejecución: Local vs Docker vs Kubernetes**
- **`docs/resource_management.md` - 🆕 Gestión de CPU, Memoria y GPU**

## 🚀 Modos de Ejecución

| Modo | Comando | Para qué |
|------|---------|----------|
| **🖥️ Local** | `nextflow run main.nf` | Desarrollo rápido |
| **🐳 Docker** | `nextflow run main.nf -profile docker` | ✅ **Recomendado** |
| **☁️ K8s** | `nextflow run main.nf -profile k8s` | Producción |

Ver [docs/execution_modes.md](docs/execution_modes.md) para detalles completos.

## ⚙️ Configuración de Recursos

| Escenario | Profile | CPU | RAM | Para |
|-----------|---------|-----|-----|------|
| 💻 **Laptop** | `-profile laptop,docker` | 4 cores | 8GB | Desarrollo |
| 🖥️ **Desktop** | `-profile docker` | 8 cores | 16GB | Testing |
| 🏢 **Servidor** | `-profile server,docker` | 32 cores | 128GB | Análisis serios |
| 🌩️ **HPC** | `-profile hpc` | 64+ cores | 500GB+ | Datos masivos |

Ver [docs/resource_management.md](docs/resource_management.md) para configuración avanzada.

## 📋 Gestión de Logs

**Todos los logs se centralizan automáticamente** en la carpeta `logs/`:

```
logs/
├── execution_report.html      # 📊 Reporte de recursos
├── execution_timeline.html    # ⏱️ Timeline de ejecución
├── execution_trace.txt        # 📝 Trace detallado
├── pipeline_dag.svg           # 🔄 Diagrama del pipeline
├── work/                      # 🗂️ Archivos temporales
└── README.md                  # 📖 Guía de logs
```

### 🔍 Ver logs en tiempo real:
```bash
# Monitorear ejecución
tail -f logs/.nextflow.log

# Ver reportes después
open logs/execution_report.html
```

## Contenedores

### Docker personalizado
```bash
# Construir imagen personalizada
cd docker/
docker build -t bio-pipeline:latest .
```

### BioContainers incluidos
- `python:latest` - Procesamiento básico
- `biocontainers/fastqc:v0.11.9_cv8` - Control de calidad

## Datos de Prueba

Archivos FASTA de ejemplo en `data/test_data/`:
- `sample1.fasta` - 3 secuencias
- `sample2.fasta` - 2 secuencias

## Resultados Esperados

Cada ejercicio genera:
- Archivos validados 
- Reportes FastQC (ejercicios 2-3)
- Conteos de secuencias
- Resumen CSV
- MultiQC consolidado (ejercicio 3)

## Herramientas Requeridas

- [Nextflow](https://www.nextflow.io/) >= 21.10.3
- [Docker](https://www.docker.com/)
- Python 3.8+ (para nf-core tools)

## Issues Conocidos y Soluciones

### Ejercicio 2: FastQC vs FASTA
**Problema**: FastQC está diseñado para archivos FASTQ (reads secuenciados), no FASTA (secuencias consenso).
**Solución**: Implementamos análisis de composición de nucleótidos usando bash, más apropiado para archivos FASTA.

### Paths relativos en módulos
**Problema**: Los includes relativos fallan desde subdirectorios de workflows.
**Solución**: Usar paths absolutos desde la raíz del proyecto: `'../../modules/local/process/main'`

### Contenedores especializados
**Problema**: Algunos BioContainers pueden no tener las dependencias esperadas.
**Solución**: Usar contenedores estables como `ubuntu:latest` o `python:latest` para lógica simple.

## Testing - Estado de los Ejercicios

### ✅ Ejercicio 1: Nextflow Básico - FUNCIONANDO
```bash
cd workflows/ejercicio_1_basico/
nextflow run main.nf -profile docker --input "../../data/test_data/*.fasta"
# ✅ Genera: work/, summary.csv (sample1: 3 seqs, sample2: 2 seqs)
```

### ✅ Ejercicio 2: Nextflow Modular - FUNCIONANDO  
```bash
cd ../ejercicio_2_modular/
nextflow run main.nf -profile docker --input "../../data/test_data/*.fasta"
# ✅ Genera: results/composition/, results/counts/, summary.csv
# 🔬 Análisis nucleotídicos: GC content ~50%, distribución ATGC balanceada
```

### ⚠️ Ejercicio 3: nf-core Completo - PREPARADO (requiere ajustes menores)
```bash
cd ../ejercicio_3_nfcore/
nextflow run main.nf -profile docker --input "../../data/test_data/*.fasta"
# 📋 Implementa conceptos nf-core: versionado, schema, reportes HTML
# 🎯 Para producción: usar `nf-core create` + módulos oficiales
```

## Resumen de Aprendizajes

| Concepto | Ejercicio 1 | Ejercicio 2 | Ejercicio 3 |
|----------|-------------|-------------|-------------|
| **Nextflow DSL2** | ✅ Básico | ✅ Avanzado | ✅ Profesional |
| **Contenedores** | `python:latest` | Múltiples especializados | Especificación nf-core |
| **Modularización** | Un archivo | Workflows anidados | Estructura nf-core |
| **Metadatos** | Simple | Canales complejos | Schema validation |
| **Reportes** | CSV básico | Múltiples outputs | HTML consolidado |
| **Versionado** | No | Opcional | Obligatorio |
| **Producción** | Prototipos | Equipos pequeños | Empresarial |

## Licencia

Proyecto educativo - Universidad [Nombre]
