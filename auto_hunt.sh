#!/bin/bash
# Automação Completa de Bug Hunting

DOMAIN=$1
if [[ -z "$DOMAIN" ]]; then
    echo "Uso: $0 <domínio>"
    exit 1
fi

echo "🤖 Automação Completa para: $DOMAIN"
echo "=================================="

# 1. Reconhecimento
echo "📡 Fase 1: Reconhecimento"
./pipeline_recon.sh "$DOMAIN"

# 2. Scan de vulnerabilidades
echo "🔍 Fase 2: Scan de Vulnerabilidades"
if [[ -f active_urls.txt ]]; then
    ./pipeline_scan.sh active_urls.txt
fi

# 3. Análise com ML
echo "🤖 Fase 3: Análise com Machine Learning"
./pipeline_ml.sh "$DOMAIN"

# 4. Relatório
echo "📊 Fase 4: Gerando Relatório"
echo "Relatório gerado em: $(date)" > report.txt
echo "Domínio: $DOMAIN" >> report.txt
echo "" >> report.txt

if [[ -f vulnerabilities.txt ]]; then
    echo "Vulnerabilidades encontradas:" >> report.txt
    cat vulnerabilities.txt >> report.txt
fi

if [[ -f ml_results.json ]]; then
    echo "" >> report.txt
    echo "Análise ML:" >> report.txt
    cat ml_results.json >> report.txt
fi

echo "✅ Automação concluída! Relatório salvo em report.txt"
