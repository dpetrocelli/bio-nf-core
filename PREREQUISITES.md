# Prerequisitos del Sistema

## Software Obligatorio

### 1. Java 17 o superior
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y openjdk-17-jdk

# Verificar instalación
java -version
# Debe mostrar: openjdk version "17.x.x" o superior
```

### 2. Nextflow
```bash
# Instalar Nextflow
curl -s https://get.nextflow.io | bash
chmod +x ./nextflow
sudo mv ./nextflow /usr/local/bin/

# Verificar instalación
nextflow -version
# Debe mostrar: version 25.x.x o superior
```

### 3. Docker
```bash
# Ubuntu/Debian - Instalar Docker
sudo apt update
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

# Agregar usuario al grupo docker (requiere logout/login)
sudo usermod -aG docker $USER

# Verificar instalación
docker --version
docker run hello-world
```

### 4. Python 3.8+ (para nf-core tools)
```bash
# Ubuntu/Debian
sudo apt install -y python3 python3-pip python3-venv

# Verificar instalación
python3 --version
# Debe mostrar: Python 3.8.x o superior
```

## Setup del Proyecto

### 1. Clonar repositorio
```bash
git clone <repo-url>
cd bio-nf-core
```

### 2. Instalar nf-core tools (opcional para ejercicios 1-2)
```bash
# Ejecutar script de setup
./setup.sh

# Activar entorno virtual
source .venv/bin/activate

# Verificar instalación
nf-core --version
```

## Verificación Completa

### Script de verificación automática
```bash
#!/bin/bash
echo "=== Verificando Prerequisitos ==="

# Java
if command -v java &> /dev/null; then
    echo "✅ Java: $(java -version 2>&1 | head -n1)"
else
    echo "❌ Java: No encontrado"
fi

# Nextflow
if command -v nextflow &> /dev/null; then
    echo "✅ Nextflow: $(nextflow -version | head -n2 | tail -n1)"
else
    echo "❌ Nextflow: No encontrado"
fi

# Docker
if command -v docker &> /dev/null; then
    echo "✅ Docker: $(docker --version)"
    if docker ps &> /dev/null; then
        echo "✅ Docker daemon: Funcionando"
    else
        echo "⚠️  Docker daemon: No accesible (¿usuario en grupo docker?)"
    fi
else
    echo "❌ Docker: No encontrado"
fi

# Python
if command -v python3 &> /dev/null; then
    echo "✅ Python: $(python3 --version)"
else
    echo "❌ Python: No encontrado"
fi

echo ""
echo "=== Prueba Rápida ==="
echo "Ejecutando prueba básica..."

# Probar Nextflow + Docker
cd workflows/ejercicio_1_basico/
if nextflow run main.nf -profile docker --input "../../data/test_data/*.fasta" > /dev/null 2>&1; then
    echo "✅ Nextflow + Docker: Funcionando correctamente"
else
    echo "❌ Nextflow + Docker: Error en ejecución"
fi
```

## Troubleshooting Común

### Error: "java: command not found"
```bash
# Instalar Java
sudo apt install -y openjdk-17-jdk

# Si sigue fallando, configurar JAVA_HOME
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64' >> ~/.bashrc
source ~/.bashrc
```

### Error: "docker: permission denied"
```bash
# Agregar usuario al grupo docker
sudo usermod -aG docker $USER

# Logout y login, o ejecutar:
newgrp docker
```

### Error: "Nextflow needs Java 17 or later"
```bash
# Verificar versión de Java
java -version

# Si es menor a 17, actualizar:
sudo apt install -y openjdk-17-jdk
```

### Error: "Unable to pull Docker image"
```bash
# Verificar conectividad Docker Hub
docker pull hello-world

# Si falla, verificar conexión a internet y configuración proxy si aplica
```

## Sistemas Operativos Soportados

### ✅ Linux (Ubuntu 20.04+, CentOS 7+)
- Recomendado para desarrollo
- Mejor performance

### ✅ macOS (Big Sur 11+)
```bash
# Instalar con Homebrew
brew install openjdk@17
brew install docker
# Nextflow: mismo comando curl
```

### ✅ Windows (WSL2)
- Usar WSL2 con Ubuntu
- Docker Desktop for Windows
- Seguir instrucciones Linux dentro de WSL2

### ❌ Windows nativo
- No recomendado
- Problemas con paths y contenedores

## Recursos del Sistema

### Mínimo
- RAM: 4 GB
- Espacio: 10 GB libres
- CPU: 2 cores

### Recomendado  
- RAM: 8 GB o más
- Espacio: 20 GB libres
- CPU: 4+ cores
- SSD para mejor I/O