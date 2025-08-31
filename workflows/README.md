# Estructura de Ejercicios Progresivos

Este directorio contiene ejercicios organizados de forma progresiva para aprender Nextflow y nf-core.

## Ejercicio 1: Nextflow Básico
**Carpeta**: `ejercicio_1_basico/`
**Objetivo**: Entender conceptos fundamentales de Nextflow

### Características:
- Un solo archivo `main.nf`
- Procesos simples
- Contenedores básicos
- DSL2 introducción

### Ejecutar:
```bash
cd workflows/ejercicio_1_basico/
nextflow run main.nf -profile docker --input "../../data/test_data/*.fasta"
```

## Ejercicio 2: Nextflow Modular
**Carpeta**: `ejercicio_2_modular/`  
**Objetivo**: Estructura modular y mejores prácticas

### Características:
- Workflows separados
- Procesos modulares
- Configuración avanzada
- BioContainers (FastQC)
- Metadatos y canales estructurados

### Ejecutar:
```bash
cd workflows/ejercicio_2_modular/
nextflow run main.nf -profile docker --input "../../data/test_data/*.fasta"
```

## Ejercicio 3: nf-core Completo
**Carpeta**: `ejercicio_3_nfcore/`
**Objetivo**: Pipeline siguiendo estándares nf-core completos

### Características:
- Validación de parámetros con schema.json
- Linting automático
- Documentación estándar
- Módulos del registro nf-core
- GitHub Actions CI/CD

### Prerequisitos:
```bash
# Instalar nf-core tools
./setup.sh
source .venv/bin/activate
```

### Ejecutar:
```bash
cd workflows/ejercicio_3_nfcore/
nf-core lint                    # Validar estándares
nextflow run main.nf -profile docker --input "../../data/test_data/*.fasta"
```

## Progresión de Aprendizaje

1. **Ejercicio 1** → Conceptos básicos Nextflow
2. **Ejercicio 2** → Modularización y contenedores
3. **Ejercicio 3** → Estándares profesionales nf-core

Cada ejercicio construye sobre el anterior, agregando complejidad y mejores prácticas.