#!/bin/bash
# Pipeline de Reconhecimento Otimizado
set -e

DOMAIN=$1
if [[ -z "$DOMAIN" ]]; then
    echo "Uso: $0 <domínio>"
    exit 1
fi

echo "🔍 Reconhecimento otimizado para: $DOMAIN"

# Subfinder com threads otimizadas
echo "📡 Encontrando subdomínios..."
subfinder -d "$DOMAIN" -silent | tee subdomains.txt

# httpx com rate limit otimizado
echo "🌐 Verificando URLs ativas..."
cat subdomains.txt | httpx -silent -status-code -title -tech-detect -rate-limit 1000 | tee active_urls.txt

echo "✅ Reconhecimento concluído!"
echo "📊 Resultados salvos em: subdomains.txt e active_urls.txt"
