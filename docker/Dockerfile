# Dockerfile personalizado para pipeline bioinformático
FROM python:latest

# Metadatos del contenedor
LABEL maintainer="Bio Pipeline Course"
LABEL description="Contenedor personalizado con herramientas bioinformáticas"
LABEL version="1.0"

# Actualizar sistema e instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    default-jre \
    && rm -rf /var/lib/apt/lists/*

# Instalar herramientas Python para bioinformática
RUN pip install --no-cache-dir \
    biopython \
    pandas \
    numpy \
    matplotlib \
    seaborn

# Instalar FastQC
RUN wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.12.1.zip && \
    unzip fastqc_v0.12.1.zip && \
    chmod +x FastQC/fastqc && \
    mv FastQC /opt/ && \
    ln -s /opt/FastQC/fastqc /usr/local/bin/fastqc && \
    rm fastqc_v0.12.1.zip

# Crear directorio de trabajo
WORKDIR /app

# Comando por defecto
CMD ["/bin/bash"]