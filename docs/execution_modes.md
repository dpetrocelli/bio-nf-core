# Modos de Ejecución del Pipeline

## 🎯 Resumen Rápido

| Modo | Comando | Cuándo Usar |
|------|---------|-------------|
| **Local** | `nextflow run main.nf` | Desarrollo, software ya instalado |
| **Docker** | `nextflow run main.nf -profile docker` | ✅ **Recomendado** - Reproducible |
| **Singularity** | `nextflow run main.nf -profile singularity` | Clusters HPC |
| **Kubernetes** | `nextflow run main.nf -profile k8s` | Producción en la nube |
| **Test** | `nextflow run main.nf -profile test` | Verificar funcionamiento |

## 🖥️ Ejecución LOCAL (sin contenedores)

### Cuándo usar:
- ✅ Desarrollo rápido
- ✅ Ya tienes el software instalado
- ✅ Debugging de código

### Prerequisitos:
```bash
# Necesitas tener instalado:
python3     # Para procesos Python
grep        # Para análisis de texto
bc          # Para cálculos matemáticos
```

### Comando:
```bash
# Ejecuta usando software del sistema
nextflow run main.nf --input "data/test_data/*.fasta"

# O explícitamente:
nextflow run main.nf -profile standard --input "data/test_data/*.fasta"
```

### ⚠️ Problemas comunes:
- Software faltante
- Versiones inconsistentes
- Dependencias del sistema

## 🐳 Ejecución con DOCKER (recomendado)

### Cuándo usar:
- ✅ **Siempre que sea posible**
- ✅ Reproducibilidad garantizada
- ✅ Sin problemas de dependencias
- ✅ Fácil compartir con otros

### Prerequisitos:
```bash
# Solo necesitas Docker
docker --version
docker run hello-world  # Verificar que funciona
```

### Comando:
```bash
# ✅ Recomendado para todos los ejercicios
nextflow run main.nf -profile docker --input "data/test_data/*.fasta"
```

### Contenedores usados:
```bash
# El pipeline usa automáticamente:
python:latest              # Para procesos Python
ubuntu:latest             # Para análisis con bash  
biocontainers/fastqc:*    # Para herramientas bioinformáticas (ejercicio 2)
```

### Ventajas:
- ✅ Mismos resultados en cualquier máquina
- ✅ Aislamiento completo
- ✅ Versionado de herramientas
- ✅ Fácil limpieza (docker system prune)

## 📦 Ejecución con SINGULARITY (HPC)

### Cuándo usar:
- 🏢 Clusters universitarios/empresariales
- 🔐 Sin permisos de administrador
- 🖥️ Sistemas HPC (High Performance Computing)

### Prerequisitos:
```bash
# Singularity debe estar instalado por el admin
singularity --version
```

### Comando:
```bash
nextflow run main.nf -profile singularity --input "data/test_data/*.fasta"
```

### Diferencias vs Docker:
- No requiere permisos root
- Mejor integración con sistemas de archivos compartidos
- Conversión automática de imágenes Docker → Singularity

## ☁️ Ejecución en KUBERNETES (producción)

### Cuándo usar:
- ☁️ Pipelines en producción
- 📈 Procesamiento masivo de datos
- 🔄 Pipelines automatizados (CI/CD)
- 👥 Equipos grandes

### Prerequisitos:
```bash
# Cluster Kubernetes configurado
kubectl cluster-info
kubectl get nodes

# Nextflow configurado para K8s
# Ver documentación: https://www.nextflow.io/docs/latest/kubernetes.html
```

### Comando:
```bash
nextflow run main.nf -profile k8s --input "s3://mi-bucket/data/*.fasta"
```

### Configuración necesaria:
```nextflow
// nextflow.config
k8s {
    namespace = 'bioinformatics'
    serviceAccount = 'nextflow-service-account'  
    storageClaimName = 'shared-storage'
}
```

## 🧪 Ejecución de TESTING

### Para verificar que todo funciona:
```bash
# Test rápido con datos pequeños
nextflow run main.nf -profile test

# Test con Docker (recomendado)
nextflow run main.nf -profile test,docker
```

## 📋 Ejemplos Prácticos por Ejercicio

### Ejercicio 1 - Básico
```bash
cd workflows/ejercicio_1_basico/

# Local (necesita Python)
nextflow run main.nf --input "../../data/test_data/*.fasta"

# Docker (recomendado)  
nextflow run main.nf -profile docker --input "../../data/test_data/*.fasta"
```

### Ejercicio 2 - Modular
```bash
cd workflows/ejercicio_2_modular/

# Solo Docker (usa contenedores especializados)
nextflow run main.nf -profile docker --input "../../data/test_data/*.fasta"
```

### Ejercicio 3 - nf-core
```bash
cd workflows/ejercicio_3_nfcore/

# Modo testing
nextflow run main.nf -profile test,docker

# Producción
nextflow run main.nf -profile docker --input "s3://data/*.fasta" --outdir "s3://results/"
```

## 🛠️ Troubleshooting

### Error: "Container not found"
```bash
# Verificar Docker
docker pull python:latest

# Usar imagen específica
nextflow run main.nf -profile docker -with-docker python:3.9
```

### Error: "Permission denied"
```bash
# Agregar usuario a grupo docker
sudo usermod -aG docker $USER
# Logout y login de nuevo
```

### Error: "Out of memory"
```bash
# Reducir recursos máximos
nextflow run main.nf -profile docker --max_memory 4.GB --max_cpus 2
```

## 🎯 Recomendaciones

1. **Para desarrollo**: Usa `-profile docker` siempre
2. **Para producción**: Configura Kubernetes + almacenamiento en nube  
3. **Para HPC**: Usa Singularity + scheduler (SLURM/PBS)
4. **Para CI/CD**: Combina con GitHub Actions

El modo Docker es el más confiable y el que usamos en este curso educativo.