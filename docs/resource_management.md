# Gestión de Recursos: CPU, Memoria y GPU

## 🎯 Configuración de Recursos por Escenario

| Escenario | Comando | CPU | RAM | Tiempo |
|-----------|---------|-----|-----|---------|
| **💻 Laptop** | `-profile laptop,docker` | 4 cores | 8GB | 4h |
| **🖥️ Desktop** | `-profile docker` | 8 cores | 16GB | 8h |
| **🏢 Servidor** | `-profile server,docker` | 32 cores | 128GB | 48h |
| **🌩️ HPC** | `-profile hpc` | 64 cores | 500GB | 7 días |
| **⚡ GPU** | `-profile gpu,docker` | + GPU | +16GB | Acelerado |

## ⚙️ Configuración Automática por Proceso

Los procesos se clasifican automáticamente usando **labels**:

```nextflow
process ANALYZE_COMPOSITION {
    label 'process_medium'  // 6 CPU, 36GB RAM, 8h
    
    script:
    """
    # Análisis computacionalmente intensivo
    """
}
```

### Labels Disponibles:

| Label | CPU | Memoria | Tiempo | Uso |
|-------|-----|---------|---------|-----|
| `process_single` | 1 | 6GB | 4h | Validación, conteos simples |
| `process_low` | 2 | 12GB | 4h | Análisis básicos |
| `process_medium` | 6 | 36GB | 8h | Bioinformática estándar |
| `process_high` | 12 | 72GB | 16h | Análisis pesados |
| `process_high_memory` | 12 | 200GB | 16h | Genomas grandes |
| `process_gpu` | 6 + GPU | 16GB | 8h | Machine Learning |

## 🚀 Ejemplos Prácticos

### 1. Ejecución en Laptop (Recursos Limitados)
```bash
# Reduce automáticamente recursos
nextflow run main.nf -profile laptop,docker --input "data/*.fasta"

# Recursos máximos: 4 CPU, 8GB RAM, 4h
```

### 2. Ejecución en Servidor (Más Potencia)
```bash
# Usa más recursos disponibles
nextflow run main.nf -profile server,docker --input "data/*.fasta"

# Recursos máximos: 32 CPU, 128GB RAM, 48h
```

### 3. Ejecución con GPU (Machine Learning)
```bash
# Habilita GPU para procesos compatibles
nextflow run main.nf -profile gpu,docker --input "data/*.fasta"

# Requiere: NVIDIA Docker runtime
```

### 4. Límites Personalizados
```bash
# Override manual de recursos
nextflow run main.nf -profile docker \\
    --max_cpus 16 \\
    --max_memory 64.GB \\
    --max_time 12.h \\
    --input "data/*.fasta"
```

## 🔧 Configuración Avanzada

### Para HPC/SLURM:
```bash
nextflow run main.nf -profile hpc \\
    -with-report execution_report.html \\
    -with-timeline timeline.html \\
    -with-trace trace.txt
```

### Para AWS Batch:
```bash
nextflow run main.nf -profile cloud \\
    --workDir s3://my-bucket/work \\
    --outdir s3://my-bucket/results
```

## 📊 Monitoreo de Recursos

### Reportes Automáticos
Cada ejecución genera:

```
results/pipeline_info/
├── execution_report.html    # 📊 Uso de recursos por proceso
├── execution_timeline.html  # ⏱️ Timeline de ejecución  
└── execution_trace.txt      # 📝 Logs detallados
```

### Métricas Importantes:
- **Peak RSS**: Memoria máxima real usada
- **%CPU**: Utilización de CPU
- **Duration**: Tiempo total vs tiempo de CPU
- **Exit status**: Códigos de error

## 🐳 Docker + Recursos

### Configuración de Docker:
```bash
# Limitar recursos en Docker
docker run --cpus="4" --memory="8g" --gpus all my-pipeline
```

### Nextflow maneja automáticamente:
- CPU assignment por contenedor
- Memory limits
- GPU access (`--gpus all` cuando se necesita)
- User permissions (`-u $(id -u):$(id -g)`)

## ⚡ Optimización de Performance

### 1. Paralelización Inteligente
```nextflow
// Nextflow paraleliza automáticamente
Channel.fromPath("*.fasta")
    .map { [meta, file] }
    .set { samples }

PROCESS(samples)  // Ejecuta en paralelo para cada muestra
```

### 2. Resource Scaling on Retry
```nextflow
process HEAVY_ANALYSIS {
    memory { 8.GB * task.attempt }  // Dobla memoria en retry
    time   { 4.h  * task.attempt }  // Dobla tiempo en retry
    
    errorStrategy 'retry'
    maxRetries 2
}
```

### 3. Queue Management
```nextflow
process {
    withLabel: process_high {
        queue = 'highmem'      // Cola específica HPC
        time = '72.h'          // Tiempo extendido
        memory = '500.GB'      // Memoria extra
    }
}
```

## 🛠️ Troubleshooting Recursos

### Error: "Out of Memory" 
```bash
# Ver uso real en el reporte
cat results/pipeline_info/execution_trace.txt | grep FAILED

# Aumentar memoria
nextflow run main.nf --max_memory 32.GB
```

### Error: "Time Limit Exceeded"
```bash
# Ver procesos lentos
grep "duration" results/pipeline_info/execution_trace.txt

# Aumentar tiempo límite  
nextflow run main.nf --max_time 24.h
```

### Error: "CPU Oversubscription"
```bash
# Limitar CPU paralelos
nextflow run main.nf --max_cpus 8

# O usar profile específico
nextflow run main.nf -profile laptop
```

## 📈 Escalado para Producción

### Datos Pequeños (< 1GB)
```bash
nextflow run main.nf -profile laptop,docker
```

### Datos Medianos (1-100GB)  
```bash
nextflow run main.nf -profile server,docker
```

### Datos Grandes (> 100GB)
```bash
nextflow run main.nf -profile hpc
# O cloud con auto-scaling
nextflow run main.nf -profile cloud
```

Los perfiles de recursos se ajustan automáticamente según el entorno y datos, garantizando uso óptimo de recursos disponibles.