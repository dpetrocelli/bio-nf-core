FROM ubuntu:25.04

RUN apt-get update && apt-get install -y \
    curl \
    openjdk-21-jdk \
    git \
    && curl -s https://get.nextflow.io | bash \
    && mv nextflow /usr/local/bin/ && chmod +x /usr/local/bin/nextflow

WORKDIR /workspace

ENTRYPOINT ["nextflow"]
