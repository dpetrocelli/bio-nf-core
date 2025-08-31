# Unidad 2: Uso de Contenedores en Bioinformática

## ¿Por qué usar contenedores en bioinformática?

Los contenedores garantizan **reproducibilidad** en los análisis bioinformáticos, permitiendo que el mismo código funcione igual en cualquier sistema operativo y configuración.

## Tipos de contenedores en este proyecto

### 1. Contenedores públicos (Docker Hub)

```nextflow
// Ejemplo: Usar Python oficial
container 'python:latest'

// Ejemplo: Usar BioContainer específico
container 'biocontainers/fastqc:v0.11.9_cv8'
```

**Ventajas:**
- Listos para usar
- Mantenidos por la comunidad
- Optimizados para tareas específicas

### 2. Dockerfile personalizado

El archivo `Dockerfile` en esta carpeta crea una imagen personalizada con:
- Python latest
- Herramientas bioinformáticas (BioPython, pandas)
- FastQC instalado manualmente
- Dependencias del sistema

### Cómo construir la imagen personalizada

```bash
# Desde la carpeta docker/
docker build -t bio-pipeline:latest .

# Verificar que se creó
docker images | grep bio-pipeline
```

### Cómo usar la imagen personalizada en Nextflow

```nextflow
process MI_PROCESO {
    container 'bio-pipeline:latest'
    
    script:
    """
    # Aquí puedes usar todas las herramientas instaladas
    python --version
    fastqc --version
    """
}
```

## BioContainers

Los **BioContainers** son imágenes Docker pre-construidas con herramientas bioinformáticas específicas.

### Ejemplo: FastQC

```nextflow
process FASTQC {
    container 'biocontainers/fastqc:v0.11.9_cv8'
    
    input:
    path reads
    
    output:
    path "*.html"
    path "*.zip"
    
    script:
    """
    fastqc $reads
    """
}
```

### Ventajas de BioContainers

1. **Versionado específico**: `v0.11.9_cv8` garantiza siempre la misma versión
2. **Optimizados**: Contienen solo las dependencias necesarias
3. **Mantenidos**: Actualizados por la comunidad científica
4. **Reproducibles**: Mismo resultado en cualquier máquina

## Configuración de contenedores

En `nextflow.config`:

```nextflow
docker {
    enabled = true
    runOptions = '-u $(id -u):$(id -g)'
}

// Para usar contenedores por defecto
process {
    container = 'python:latest'
    
    // Contenedores específicos por proceso
    withName: FASTQC {
        container = 'biocontainers/fastqc:v0.11.9_cv8'
    }
}
```

## Ejercicios prácticos

1. **Construir imagen personalizada**: Ejecuta el comando docker build
2. **Probar FastQC**: Ejecuta el pipeline y verifica los archivos HTML generados
3. **Modificar Dockerfile**: Agrega una nueva herramienta bioinformática

## Recursos adicionales

- [BioContainers Registry](https://biocontainers.pro/)
- [Docker Hub - BioContainers](https://hub.docker.com/u/biocontainers)
- [Nextflow - Container support](https://www.nextflow.io/docs/latest/container.html)