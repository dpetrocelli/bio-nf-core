#!/bin/bash

# Setup script para Bio-NF-Core
# Instala dependencias y configura entorno virtual

echo "=== Bio-NF-Core Setup Script ==="

# Crear entorno virtual
echo "Creando entorno virtual..."
python3 -m venv .venv

# Activar entorno virtual
echo "Activando entorno virtual..."
source .venv/bin/activate

# Actualizar pip
echo "Actualizando pip..."
pip install --upgrade pip

# Instalar dependencias
echo "Instalando nf-core tools..."
pip install nf-core

# Instalar otras dependencias útiles
echo "Instalando dependencias adicionales..."
pip install biopython pandas matplotlib seaborn

# Verificar instalaciones
echo "Verificando instalaciones..."
echo "Python: $(python --version)"
echo "nf-core: $(nf-core --version)"
echo "Nextflow debe instalarse por separado: https://www.nextflow.io/docs/latest/getstarted.html#installation"

echo ""
echo "=== Setup completado! ==="
echo ""
echo "Para usar las herramientas:"
echo "1. Activa el entorno: source .venv/bin/activate"
echo "2. Ejecuta comandos nf-core: nf-core lint, nf-core schema, etc."
echo "3. Los contenedores Docker NO necesitan nf-core tools instalados"
echo ""
echo "Estructura del proyecto:"
echo "- Nextflow básico: docker/pipeline_1/main.nf"
echo "- Nextflow modular: workflows/bio_pipeline.nf" 
echo "- nf-core completo: se configurará con nf-core tools"