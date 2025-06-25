docker rm -f ollama-gpu ollama-webui ollama-init 2>/dev/null || true

docker-compose --env-file .env -f docker-compose-ollama.yml up