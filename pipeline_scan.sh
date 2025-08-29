#!/bin/bash
# Pipeline de Scan de Vulnerabilidades Otimizado

URLS_FILE=$1
if [[ -z "$URLS_FILE" ]]; then
    echo "Uso: $0 <arquivo_urls>"
    exit 1
fi

echo "🔍 Pipeline de Scan para: $URLS_FILE"
echo "=================================="

# Verificar se o arquivo existe
if [[ ! -f "$URLS_FILE" ]]; then
    echo "❌ Arquivo $URLS_FILE não encontrado!"
    exit 1
fi

# Usar wordlists locais
WORDLIST_DIR="./wordlists"
COMMON_WORDLIST="$WORDLIST_DIR/common.txt"
EXTENSIONS_WORDLIST="$WORDLIST_DIR/extensions.txt"

# Verificar se as wordlists existem
if [[ ! -f "$COMMON_WORDLIST" ]]; then
    echo "❌ Wordlist $COMMON_WORDLIST não encontrada!"
    exit 1
fi

echo "📋 Usando wordlists locais:"
echo "   - Diretórios: $COMMON_WORDLIST"
echo "   - Extensões: $EXTENSIONS_WORDLIST"

# Limpar arquivos anteriores
> vulnerabilities.txt
> fuzzing_results.txt

# Contador de URLs processadas
TOTAL_URLS=$(wc -l < "$URLS_FILE")
CURRENT=0

echo "🚀 Iniciando fuzzing em $TOTAL_URLS URLs..."

while IFS= read -r url; do
    CURRENT=$((CURRENT + 1))
    echo "📡 [$CURRENT/$TOTAL_URLS] Fuzzing: $url"
    
    # Fuzzing de diretórios
    echo "   🔍 Testando diretórios..."
    ffuf -w "$COMMON_WORDLIST" -u "$url/FUZZ" -mc 200,301,302,403 -s -o "fuzz_dirs_$CURRENT.json" -of json 2>/dev/null
    
    # Fuzzing de extensões
    echo "   📄 Testando extensões..."
    ffuf -w "$EXTENSIONS_WORDLIST" -u "$url/FUZZ" -mc 200,301,302,403 -s -o "fuzz_ext_$CURRENT.json" -of json 2>/dev/null
    
    # Verificar se encontrou algo
    if [[ -f "fuzz_dirs_$CURRENT.json" ]] && [[ -s "fuzz_dirs_$CURRENT.json" ]]; then
        echo "   ✅ Encontrados diretórios em $url"
        cat "fuzz_dirs_$CURRENT.json" >> fuzzing_results.txt
    fi
    
    if [[ -f "fuzz_ext_$CURRENT.json" ]] && [[ -s "fuzz_ext_$CURRENT.json" ]]; then
        echo "   ✅ Encontrados arquivos em $url"
        cat "fuzz_ext_$CURRENT.json" >> fuzzing_results.txt
    fi
    
    # Limpar arquivos temporários
    rm -f "fuzz_dirs_$CURRENT.json" "fuzz_ext_$CURRENT.json"
    
    # Delay para não sobrecarregar
    sleep 1
    
done < "$URLS_FILE"

echo "✅ Scan concluído!"
echo "📊 Resultados salvos em: vulnerabilities.txt e fuzzing_results.txt"
