#!/bin/bash

# Script helper para ejecutar ejercicios Bio-NF-Core
# Uso: ./run_exercise.sh [1|2|3] [local|docker]

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Función para mostrar ayuda
show_help() {
    echo -e "${BLUE}"
    echo "========================================="
    echo " Bio-NF-Core - Script de Ejecución"
    echo "========================================="
    echo -e "${NC}"
    echo "Uso: ./run_exercise.sh [EJERCICIO] [MODO]"
    echo ""
    echo "EJERCICIOS:"
    echo "  1    Ejercicio 1 - Nextflow Básico"
    echo "  2    Ejercicio 2 - Nextflow Modular"
    echo "  3    Ejercicio 3 - nf-core Completo"
    echo ""
    echo "MODOS:"
    echo "  local    Ejecución sin contenedores"
    echo "  docker   Ejecución con Docker (recomendado)"
    echo ""
    echo "Ejemplos:"
    echo "  ./run_exercise.sh 1 docker    # Ejercicio 1 con Docker"
    echo "  ./run_exercise.sh 2 local     # Ejercicio 2 local"
    echo "  ./run_exercise.sh 3 docker    # Ejercicio 3 con Docker"
    echo ""
}

# Verificar argumentos
if [ $# -eq 0 ]; then
    show_help
    exit 1
fi

EXERCISE=$1
MODE=${2:-docker}  # Docker por defecto

# Validar número de ejercicio
if [[ ! "$EXERCISE" =~ ^[1-3]$ ]]; then
    echo -e "${RED}❌ Error: Ejercicio debe ser 1, 2 o 3${NC}"
    show_help
    exit 1
fi

# Validar modo
if [[ ! "$MODE" =~ ^(local|docker)$ ]]; then
    echo -e "${RED}❌ Error: Modo debe ser 'local' o 'docker'${NC}"
    show_help
    exit 1
fi

# Verificar prerequisitos
if ! command -v nextflow &> /dev/null; then
    echo -e "${RED}❌ Error: Nextflow no está instalado${NC}"
    echo "Ver PREREQUISITES.md para instrucciones de instalación"
    exit 1
fi

if [ "$MODE" = "docker" ] && ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Error: Docker no está instalado${NC}"
    echo "Ver PREREQUISITES.md para instrucciones de instalación"
    exit 1
fi

# Definir directorios y comandos
case $EXERCISE in
    1)
        DIR="workflows/ejercicio_1_basico"
        NAME="Nextflow Básico"
        ;;
    2)
        DIR="workflows/ejercicio_2_modular"
        NAME="Nextflow Modular"
        ;;
    3)
        DIR="workflows/ejercicio_3_nfcore"
        NAME="nf-core Completo"
        ;;
esac

# Construir comando
if [ "$MODE" = "docker" ]; then
    PROFILE="-profile docker"
else
    PROFILE=""
fi

INPUT_DATA="../../data/test_data/*.fasta"
CMD="nextflow run main.nf $PROFILE --input \"$INPUT_DATA\""

# Mostrar información
echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}🧬 Ejecutando Ejercicio $EXERCISE: $NAME${NC}"
echo -e "${BLUE}=========================================${NC}"
echo "📁 Directorio: $DIR"
echo "🐳 Modo: $MODE"
echo "📊 Datos: $INPUT_DATA"
echo "⚡ Comando: $CMD"
echo -e "${BLUE}=========================================${NC}"
echo ""

# Verificar que el directorio existe
if [ ! -d "$DIR" ]; then
    echo -e "${RED}❌ Error: Directorio $DIR no encontrado${NC}"
    exit 1
fi

# Verificar que main.nf existe
if [ ! -f "$DIR/main.nf" ]; then
    echo -e "${RED}❌ Error: $DIR/main.nf no encontrado${NC}"
    exit 1
fi

# Verificar datos de test
if ! ls data/test_data/*.fasta 1> /dev/null 2>&1; then
    echo -e "${RED}❌ Error: No se encontraron archivos FASTA en data/test_data/${NC}"
    exit 1
fi

# Cambiar al directorio del ejercicio y ejecutar
echo -e "${YELLOW}🚀 Iniciando ejecución...${NC}"
echo ""

cd "$DIR"

# Ejecutar el pipeline
if eval $CMD; then
    echo ""
    echo -e "${GREEN}✅ Ejercicio $EXERCISE completado exitosamente!${NC}"
    echo ""
    echo -e "${BLUE}📋 Resultados generados:${NC}"
    if [ -d "results" ]; then
        find results -type f -name "*.csv" -o -name "*.txt" -o -name "*.html" | head -10
    elif [ -d "work" ]; then
        echo "📁 Archivos en directorio work/ (buscar summary.csv)"
        find work -name "summary.csv" | head -5
    fi
    
    echo ""
    echo -e "${BLUE}📊 Logs y reportes disponibles:${NC}"
    echo "📁 Todos los logs están en: ../../logs/"
    echo "🌐 Reporte de recursos: ../../logs/execution_report.html" 
    echo "⏱️ Timeline: ../../logs/execution_timeline.html"
    echo "📝 Trace detallado: ../../logs/execution_trace.txt"
    echo "🔄 Diagrama: ../../logs/pipeline_dag.svg"
    echo ""
    echo -e "${YELLOW}💡 Para ver logs en tiempo real: tail -f ../../logs/.nextflow.log${NC}"
    
else
    echo ""
    echo -e "${RED}❌ Error en la ejecución del ejercicio $EXERCISE${NC}"
    echo ""
    echo -e "${YELLOW}💡 Tips para debugging:${NC}"
    echo "1. Verificar que Docker esté corriendo (si usando modo docker)"
    echo "2. Revisar logs en .nextflow.log"
    echo "3. Verificar prerequisitos en PREREQUISITES.md"
    echo "4. Probar con modo local: ./run_exercise.sh $EXERCISE local"
    exit 1
fi