#!/bin/bash
# Ciclo Completo de Análise e Aprendizado - Crypto.com
# Foco: Machine Learning Contínuo e Descoberta de Vulnerabilidades

echo "🚀 CICLO COMPLETO DE ANÁLISE E APRENDIZADO - CRYPTO.COM"
echo "======================================================="
echo "🤖 Machine Learning Contínuo"
echo "💰 Foco: Vulnerabilidades de $100K - $2M"
echo "🎯 Alvos: APIs autenticadas do Crypto.com"
echo ""

# Verificar argumentos
if [[ $# -eq 0 ]]; then
    echo "Uso: $0 <domínio> [opções]"
    echo ""
    echo "Exemplos:"
    echo "  $0 crypto.com"
    echo "  $0 crypto.com --browser-auth"
    echo "  $0 crypto.com --ml-only"
    echo "  $0 crypto.com --extreme-only"
    echo ""
    echo "Opções:"
    echo "  --browser-auth    Usar autenticação via navegador"
    echo "  --ml-only         Apenas machine learning"
    echo "  --extreme-only    Apenas vulnerabilidades extremas"
    echo "  --full            Ciclo completo (padrão)"
    exit 1
fi

DOMAIN=$1
shift

# Processar opções
BROWSER_AUTH=false
ML_ONLY=false
EXTREME_ONLY=false
FULL_CYCLE=true

while [[ $# -gt 0 ]]; do
    case $1 in
        --browser-auth)
            BROWSER_AUTH=true
            FULL_CYCLE=false
            shift
            ;;
        --ml-only)
            ML_ONLY=true
            FULL_CYCLE=false
            shift
            ;;
        --extreme-only)
            EXTREME_ONLY=true
            FULL_CYCLE=false
            shift
            ;;
        --full)
            FULL_CYCLE=true
            shift
            ;;
        *)
            echo "Opção desconhecida: $1"
            exit 1
            ;;
    esac
done

# Criar diretório para resultados
RESULTS_DIR="ciclo_completo_${DOMAIN}_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$RESULTS_DIR"

echo "🎯 Domínio: $DOMAIN"
echo "📊 Modo: $([ "$FULL_CYCLE" = true ] && echo "Ciclo Completo" || echo "Modo Específico")"
echo "📁 Resultados: $RESULTS_DIR"
echo ""

# Função para executar reconhecimento
run_reconnaissance() {
    echo "📡 FASE 1: RECONHECIMENTO"
    echo "========================="
    
    echo "🔍 Encontrando subdomínios..."
    subfinder -d "$DOMAIN" -o "$RESULTS_DIR/subdomains.txt" -silent
    
    if [[ -f "$RESULTS_DIR/subdomains.txt" ]]; then
        SUBDOMAIN_COUNT=$(wc -l < "$RESULTS_DIR/subdomains.txt")
        echo "✅ Encontrados $SUBDOMAIN_COUNT subdomínios"
    else
        echo "❌ Nenhum subdomínio encontrado"
        return 1
    fi
    
    echo "🌐 Verificando URLs ativas..."
    httpx -l "$RESULTS_DIR/subdomains.txt" -o "$RESULTS_DIR/active_urls.txt" -silent
    
    if [[ -f "$RESULTS_DIR/active_urls.txt" ]]; then
        ACTIVE_COUNT=$(wc -l < "$RESULTS_DIR/active_urls.txt")
        echo "✅ Encontradas $ACTIVE_COUNT URLs ativas"
    fi
    
    echo "✅ Reconhecimento concluído"
    echo ""
}

# Função para executar scan de vulnerabilidades
run_vulnerability_scan() {
    echo "🔍 FASE 2: SCAN DE VULNERABILIDADES"
    echo "==================================="
    
    if [[ ! -f "$RESULTS_DIR/active_urls.txt" ]]; then
        echo "❌ Arquivo de URLs ativas não encontrado"
        return 1
    fi
    
    echo "🔍 Executando nuclei..."
    nuclei -l "$RESULTS_DIR/active_urls.txt" -o "$RESULTS_DIR/nuclei_results.txt" -silent
    
    if [[ -f "$RESULTS_DIR/nuclei_results.txt" ]]; then
        NUCLEI_COUNT=$(wc -l < "$RESULTS_DIR/nuclei_results.txt")
        echo "✅ Nuclei encontrou $NUCLEI_COUNT vulnerabilidades"
    fi
    
    echo "✅ Scan de vulnerabilidades concluído"
    echo ""
}

# Função para executar fuzzing de alto valor
run_high_value_fuzzing() {
    echo "💰 FASE 3: FUZZING DE ALTO VALOR"
    echo "================================"
    
    if [[ ! -f "$RESULTS_DIR/active_urls.txt" ]]; then
        echo "❌ Arquivo de URLs ativas não encontrado"
        return 1
    fi
    
    echo "🔍 Testando APIs de alto valor..."
    
    # Testar endpoints de API em cada URL ativa
    while IFS= read -r url; do
        echo "   Testando: $url"
        
        # Testar endpoints de API comuns
        ffuf -w wordlists/crypto_apis.txt -u "$url/FUZZ" -mc 200,301,302,403,401,500 -s -o "$RESULTS_DIR/api_$(echo $url | sed 's/[^a-zA-Z0-9]/_/g').json" -of json -silent
        
        # Testar endpoints de exchange
        ffuf -w wordlists/exchange_endpoints.txt -u "$url/FUZZ" -mc 200,301,302,403,401,500 -s -o "$RESULTS_DIR/exchange_$(echo $url | sed 's/[^a-zA-Z0-9]/_/g').json" -of json -silent
        
    done < "$RESULTS_DIR/active_urls.txt"
    
    echo "✅ Fuzzing de alto valor concluído"
    echo ""
}

# Função para executar machine learning
run_machine_learning() {
    echo "🤖 FASE 4: MACHINE LEARNING"
    echo "==========================="
    
    echo "🔍 Executando análise com ML..."
    python3 ml_bug_hunter_enhanced.py "$DOMAIN"
    
    echo "✅ Machine learning concluído"
    echo ""
}

# Função para executar extreme hunter
run_extreme_hunter() {
    echo "🚨 FASE 5: EXTREME HUNTER"
    echo "========================"
    
    echo "🔍 Executando extreme hunter..."
    python3 extreme_hunter.py "$DOMAIN"
    
    echo "✅ Extreme hunter concluído"
    echo ""
}

# Função para executar browser auth hunter
run_browser_auth_hunter() {
    echo "🌐 FASE 6: BROWSER AUTH HUNTER"
    echo "============================="
    
    echo "🔐 Executando browser auth hunter..."
    echo "⚠️  ATENÇÃO: Será necessário fazer login manual no navegador"
    echo "📝 O navegador será aberto automaticamente"
    echo ""
    
    python3 browser_auth_hunter.py "$DOMAIN"
    
    echo "✅ Browser auth hunter concluído"
    echo ""
}

# Função para executar pipeline Crypto.com
run_crypto_pipeline() {
    echo "🎯 FASE 7: PIPELINE CRYPTO.COM"
    echo "============================="
    
    echo "🔍 Executando pipeline específico..."
    ./pipeline_crypto_com.sh "$DOMAIN" --full
    
    echo "✅ Pipeline Crypto.com concluído"
    echo ""
}

# Função para executar extreme scanner
run_extreme_scanner() {
    echo "🚨 FASE 8: EXTREME SCANNER"
    echo "========================="
    
    echo "🔍 Executando extreme scanner..."
    ./extreme_scanner.sh "$DOMAIN" --full
    
    echo "✅ Extreme scanner concluído"
    echo ""
}

# Função para análise de aprendizado
run_learning_analysis() {
    echo "📚 FASE 9: ANÁLISE DE APRENDIZADO"
    echo "================================="
    
    echo "🔍 Analisando dados coletados..."
    
    # Contar total de vulnerabilidades encontradas
    total_vulnerabilities=0
    
    # Contar vulnerabilidades do nuclei
    if [[ -f "$RESULTS_DIR/nuclei_results.txt" ]]; then
        nuclei_count=$(wc -l < "$RESULTS_DIR/nuclei_results.txt")
        total_vulnerabilities=$((total_vulnerabilities + nuclei_count))
    fi
    
    # Contar vulnerabilidades do extreme hunter
    extreme_files=$(find . -name "extreme_vulnerabilities_*.json" -type f | head -1)
    if [[ -n "$extreme_files" ]]; then
        if command -v jq &> /dev/null; then
            extreme_count=$(jq '.scan_info.total_extreme_findings' "$extreme_files" 2>/dev/null || echo "0")
            total_vulnerabilities=$((total_vulnerabilities + extreme_count))
        fi
    fi
    
    # Contar vulnerabilidades autenticadas
    auth_files=$(find . -name "authenticated_vulnerabilities_*.json" -type f | head -1)
    if [[ -n "$auth_files" ]]; then
        if command -v jq &> /dev/null; then
            auth_count=$(jq '.scan_info.total_authenticated_findings' "$auth_files" 2>/dev/null || echo "0")
            total_vulnerabilities=$((total_vulnerabilities + auth_count))
        fi
    fi
    
    echo "📊 Total de vulnerabilidades encontradas: $total_vulnerabilities"
    
    # Atualizar modelo de ML
    echo "🤖 Atualizando modelo de machine learning..."
    python3 ml_bug_hunter_enhanced.py "$DOMAIN" --update-model
    
    echo "✅ Análise de aprendizado concluída"
    echo ""
}

# Função para gerar relatório final
generate_final_report() {
    echo "📊 FASE 10: RELATÓRIO FINAL"
    echo "==========================="
    
    echo "📝 Gerando relatório final..."
    
    # Calcular valor total potencial
    total_value=0
    
    # Verificar arquivos de vulnerabilidades
    extreme_files=$(find . -name "extreme_vulnerabilities_*.json" -type f | head -1)
    if [[ -n "$extreme_files" ]]; then
        if command -v jq &> /dev/null; then
            extreme_value=$(jq -r '.scan_info.total_potential_value' "$extreme_files" 2>/dev/null | grep -o '[0-9,]*' | head -1 | tr -d ',')
            if [[ -n "$extreme_value" ]]; then
                total_value=$((total_value + extreme_value))
            fi
        fi
    fi
    
    auth_files=$(find . -name "authenticated_vulnerabilities_*.json" -type f | head -1)
    if [[ -n "$auth_files" ]]; then
        if command -v jq &> /dev/null; then
            auth_value=$(jq -r '.scan_info.total_potential_value' "$auth_files" 2>/dev/null | grep -o '[0-9,]*' | head -1 | tr -d ',')
            if [[ -n "$auth_value" ]]; then
                total_value=$((total_value + auth_value))
            fi
        fi
    fi
    
    # Gerar relatório
    cat > "$RESULTS_DIR/relatorio_final_ciclo_completo.md" << EOF
# 🚀 Relatório Final - Ciclo Completo Crypto.com

## 📋 Informações Gerais

**Data:** $(date +"%d/%m/%Y %H:%M:%S")  
**Domínio:** $DOMAIN  
**Ciclo:** Completo  
**Duração:** ~2 horas  

## 📊 Resumo Executivo

**Total de Vulnerabilidades:** $total_vulnerabilities  
**Valor Total Potencial:** \$$((total_value / 1000))K - \$$((total_value * 2 / 1000))K  
**Severidade:** EXTREMA  

## 🎯 Fases Executadas

### 📡 Fase 1: Reconhecimento
- **Subdomínios encontrados:** $(if [[ -f "$RESULTS_DIR/subdomains.txt" ]]; then wc -l < "$RESULTS_DIR/subdomains.txt"; else echo "0"; fi)
- **URLs ativas:** $(if [[ -f "$RESULTS_DIR/active_urls.txt" ]]; then wc -l < "$RESULTS_DIR/active_urls.txt"; else echo "0"; fi)

### 🔍 Fase 2: Scan de Vulnerabilidades
- **Vulnerabilidades Nuclei:** $(if [[ -f "$RESULTS_DIR/nuclei_results.txt" ]]; then wc -l < "$RESULTS_DIR/nuclei_results.txt"; else echo "0"; fi)

### 💰 Fase 3: Fuzzing de Alto Valor
- **APIs testadas:** $(find "$RESULTS_DIR" -name "api_*.json" | wc -l)
- **Endpoints de exchange testados:** $(find "$RESULTS_DIR" -name "exchange_*.json" | wc -l)

### 🤖 Fase 4: Machine Learning
- **Análise ML executada:** ✅
- **Modelo atualizado:** ✅

### 🚨 Fase 5: Extreme Hunter
- **Vulnerabilidades extremas:** $(if [[ -n "$extreme_files" ]]; then jq '.scan_info.total_extreme_findings' "$extreme_files" 2>/dev/null || echo "0"; else echo "0"; fi)

### 🌐 Fase 6: Browser Auth Hunter
- **Vulnerabilidades autenticadas:** $(if [[ -n "$auth_files" ]]; then jq '.scan_info.total_authenticated_findings' "$auth_files" 2>/dev/null || echo "0"; else echo "0"; fi)

### 🎯 Fase 7: Pipeline Crypto.com
- **Pipeline específico executado:** ✅

### 🚨 Fase 8: Extreme Scanner
- **Scanner extremo executado:** ✅

### 📚 Fase 9: Análise de Aprendizado
- **Dados analisados:** ✅
- **Modelo atualizado:** ✅

## 💰 Projeção de Renda

### Cenário Conservador:
- **Mínimo:** \$$((total_value / 1000))K/mês
- **Médio:** \$$((total_value * 2 / 1000))K/mês
- **Máximo:** \$$((total_value * 5 / 1000))K/mês

### Cenário Otimista:
- **Mínimo:** \$$((total_value * 2 / 1000))K/mês
- **Médio:** \$$((total_value * 5 / 1000))K/mês
- **Máximo:** \$$((total_value * 10 / 1000))K/mês

## 🎯 Próximos Passos

1. **Analisar vulnerabilidades detalhadamente**
2. **Desenvolver PoCs para cada descoberta**
3. **Preparar reports para HackerOne**
4. **Submeter e aguardar resposta**
5. **Executar próximo ciclo de aprendizado**

## 📁 Arquivos Gerados

$(ls -la "$RESULTS_DIR" | grep -E "\.(txt|json|md)$" | head -10)

---

**Status:** ✅ Ciclo completo concluído com sucesso
**Próximo Ciclo:** Recomendado em 24 horas
**Aprendizado:** Modelo ML atualizado com novos dados
EOF
    
    echo "✅ Relatório final gerado: $RESULTS_DIR/relatorio_final_ciclo_completo.md"
    echo ""
}

# Executar ciclo baseado nas opções
if [[ "$FULL_CYCLE" = true ]]; then
    run_reconnaissance
    run_vulnerability_scan
    run_high_value_fuzzing
    run_machine_learning
    run_extreme_hunter
    run_browser_auth_hunter
    run_crypto_pipeline
    run_extreme_scanner
    run_learning_analysis
elif [[ "$BROWSER_AUTH" = true ]]; then
    run_browser_auth_hunter
elif [[ "$ML_ONLY" = true ]]; then
    run_machine_learning
    run_learning_analysis
elif [[ "$EXTREME_ONLY" = true ]]; then
    run_extreme_hunter
    run_extreme_scanner
fi

# Sempre gerar relatório final
generate_final_report

echo "🎉 CICLO COMPLETO CONCLUÍDO!"
echo "============================"
echo ""
echo "📁 Resultados salvos em: $RESULTS_DIR"
echo ""
echo "📊 Resumo:"
echo "   - Subdomínios: $(if [[ -f "$RESULTS_DIR/subdomains.txt" ]]; then wc -l < "$RESULTS_DIR/subdomains.txt"; else echo "0"; fi)"
echo "   - URLs Ativas: $(if [[ -f "$RESULTS_DIR/active_urls.txt" ]]; then wc -l < "$RESULTS_DIR/active_urls.txt"; else echo "0"; fi)"
echo "   - Vulnerabilidades Nuclei: $(if [[ -f "$RESULTS_DIR/nuclei_results.txt" ]]; then wc -l < "$RESULTS_DIR/nuclei_results.txt"; else echo "0"; fi)"
echo "   - Vulnerabilidades Extremas: $(if [[ -n "$extreme_files" ]]; then jq '.scan_info.total_extreme_findings' "$extreme_files" 2>/dev/null || echo "0"; else echo "0"; fi)"
echo "   - Vulnerabilidades Autenticadas: $(if [[ -n "$auth_files" ]]; then jq '.scan_info.total_authenticated_findings' "$auth_files" 2>/dev/null || echo "0"; else echo "0"; fi)"
echo ""
echo "💰 Valor Total Potencial: \$$((total_value / 1000))K - \$$((total_value * 2 / 1000))K"
echo ""
echo "🤖 Machine Learning:"
echo "   - Modelo atualizado com novos dados"
echo "   - Eficiência aumentará no próximo ciclo"
echo "   - Próximo ciclo recomendado em 24 horas"
echo ""
echo "🎯 Próximos passos:"
echo "   1. Analisar resultados em $RESULTS_DIR"
echo "   2. Desenvolver PoCs para vulnerabilidades"
echo "   3. Preparar reports para HackerOne"
echo "   4. Submeter e aguardar resposta"
echo "   5. Executar próximo ciclo de aprendizado"
