#!/bin/bash
# Pipeline com Machine Learning
set -e

DOMAIN=$1
if [[ -z "$DOMAIN" ]]; then
    echo "Uso: $0 <domínio>"
    exit 1
fi

echo "🤖 Pipeline com ML para: $DOMAIN"

# Ativar ambiente virtual
source ml_env/bin/activate

# Executar análise com ML
python3 ml_bug_hunter.py "$DOMAIN" | tee ml_results.json

echo "✅ Análise com ML concluída!"
echo "📊 Resultados salvos em: ml_results.json"
