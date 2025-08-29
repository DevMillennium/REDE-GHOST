#!/bin/bash
# Pipeline de Scan Otimizado
set -e

URLS_FILE=$1
if [[ -z "$URLS_FILE" ]]; then
    echo "Uso: $0 <arquivo_com_urls>"
    exit 1
fi

echo "🎯 Scan de vulnerabilidades otimizado..."

# Nuclei com templates específicos e rate limit
echo "🔍 Executando Nuclei..."
cat "$URLS_FILE" | nuclei -t nuclei-templates -severity medium,high,critical -silent -rate-limit 150 -bulk-size 25 | tee vulnerabilities.txt

# ffuf para fuzzing otimizado
echo "🔍 Executando fuzzing..."
head -10 "$URLS_FILE" | while read url; do
    echo "Fuzzing: $url"
    ffuf -u "${url}/FUZZ" -w /usr/share/wordlists/dirb/common.txt -mc 200,301,302,403 -t 50 -s | tee -a fuzzing_results.txt
done

echo "✅ Scan concluído!"
echo "📊 Resultados salvos em: vulnerabilities.txt e fuzzing_results.txt"
