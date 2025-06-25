#!/bin/bash

# Asegurar que el directorio de modelos existe (coincide con /root/.ollama en el container)
mkdir -p /root/.ollama
chmod 755 /root/.ollama

# Iniciar Ollama en segundo plano
ollama serve &

# Esperar hasta que Ollama esté listo
echo "Waiting for Ollama server to start..."
sleep 5

while ! ollama list > /dev/null 2>&1; do
    echo "Still waiting for Ollama server..."
    sleep 2
done

echo "Ollama server is ready!"

# Verificar si el modelo ya está instalado
if [ -n "$OLLAMA_MODEL" ]; then
    if ollama list | grep -q "$OLLAMA_MODEL"; then
        echo "Model $OLLAMA_MODEL already exists. Skipping download."
    else
        echo "Pulling model: $OLLAMA_MODEL"
        ollama pull "$OLLAMA_MODEL"
    fi
fi

# Mantener el contenedor vivo
wait
