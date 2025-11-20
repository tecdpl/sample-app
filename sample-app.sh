#!/bin/bash
set -euo pipefail

APP_NAME="sampleapp"
CONTAINER_NAME="samplerunning"
TEMPDIR="tempdir"

echo "==> Limpando recursos anteriores (se existirem)..."
# Remove container se existir
docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true
# Remove imagem se existir
docker rmi -f "$APP_NAME" >/dev/null 2>&1 || true
# Remove diretório temporário
rm -rf "$TEMPDIR"

echo "==> Criando estrutura de diretórios..."
mkdir -p "$TEMPDIR/templates"
mkdir -p "$TEMPDIR/static"

echo "==> Copiando arquivos da aplicação..."
cp sample_app.py "$TEMPDIR"/
cp -r templates/* "$TEMPDIR/templates"/
cp -r static/* "$TEMPDIR/static"/

echo "==> Gerando Dockerfile..."
cat > "$TEMPDIR/Dockerfile" <<'EOF'
FROM python

# Evita cache e desativa progress bar "rich" do pip (corrige erro de thread)
ENV PIP_NO_CACHE_DIR=1 \
    PIP_PROGRESS_BAR=off

RUN pip install --no-cache-dir --progress-bar off flask
COPY ./static /home/myapp/static/
COPY ./templates /home/myapp/templates/
COPY sample_app.py /home/myapp/

EXPOSE 5050
CMD python3 /home/myapp/sample_app.py
EOF

echo "==> Build da imagem Docker..."
cd "$TEMPDIR"
#docker build -t "$APP_NAME" .

echo "==> Subindo container..."
#docker run -d -p 5050:5050 --name "$CONTAINER_NAME" "$APP_NAME"

echo "==> Containers em execução:"
#docker ps -a | grep "$CONTAINER_NAME" || docker ps -a
