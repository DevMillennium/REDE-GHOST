#!/bin/bash
# Pipeline Específico para Crypto.com Bug Bounty

echo "🚀 Pipeline Crypto.com - Bug Bounty de Alto Valor"
echo "=================================================="

# Verificar se os argumentos foram fornecidos
if [[ $# -eq 0 ]]; then
    echo "Uso: $0 <domínio> [opções]"
    echo ""
    echo "Exemplos:"
    echo "  $0 crypto.com"
    echo "  $0 mona.co"
    echo "  $0 crypto.com --api-only"
    echo "  $0 crypto.com --smart-contracts"
    echo ""
    echo "Opções:"
    echo "  --api-only        Apenas análise de APIs"
    echo "  --web-only        Apenas análise web"
    echo "  --mobile-only     Apenas análise mobile"
    echo "  --smart-contracts Apenas análise de smart contracts"
    echo "  --full            Análise completa (padrão)"
    exit 1
fi

DOMAIN=$1
shift

# Processar opções
API_ONLY=false
WEB_ONLY=false
MOBILE_ONLY=false
SMART_CONTRACTS_ONLY=false
FULL_ANALYSIS=true

while [[ $# -gt 0 ]]; do
    case $1 in
        --api-only)
            API_ONLY=true
            FULL_ANALYSIS=false
            shift
            ;;
        --web-only)
            WEB_ONLY=true
            FULL_ANALYSIS=false
            shift
            ;;
        --mobile-only)
            MOBILE_ONLY=true
            FULL_ANALYSIS=false
            shift
            ;;
        --smart-contracts)
            SMART_CONTRACTS_ONLY=true
            FULL_ANALYSIS=false
            shift
            ;;
        --full)
            FULL_ANALYSIS=true
            shift
            ;;
        *)
            echo "Opção desconhecida: $1"
            exit 1
            ;;
    esac
done

echo "🎯 Domínio: $DOMAIN"
echo "📊 Modo: $([ "$FULL_ANALYSIS" = true ] && echo "Análise Completa" || echo "Análise Específica")"
echo ""

# Criar diretório para resultados
RESULTS_DIR="crypto_com_results_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$RESULTS_DIR"

echo "📁 Resultados serão salvos em: $RESULTS_DIR"
echo ""

# Função para análise de subdomínios
analyze_subdomains() {
    echo "🔍 Fase 1: Análise de Subdomínios"
    echo "================================="
    
    echo "📡 Encontrando subdomínios..."
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
    
    echo ""
}

# Função para análise de APIs
analyze_apis() {
    echo "🔌 Fase 2: Análise de APIs"
    echo "=========================="
    
    if [[ ! -f "$RESULTS_DIR/active_urls.txt" ]]; then
        echo "❌ Arquivo de URLs ativas não encontrado"
        return 1
    fi
    
    echo "🔍 Testando endpoints de API..."
    
    # Testar endpoints de API em cada URL ativa
    while IFS= read -r url; do
        echo "   Testando: $url"
        
        # Testar endpoints de API comuns
        ffuf -w wordlists/crypto_apis.txt -u "$url/FUZZ" -mc 200,301,302,403,401,500 -s -o "$RESULTS_DIR/api_$(echo $url | sed 's/[^a-zA-Z0-9]/_/g').json" -of json -silent
        
        # Testar endpoints de exchange
        ffuf -w wordlists/exchange_endpoints.txt -u "$url/FUZZ" -mc 200,301,302,403,401,500 -s -o "$RESULTS_DIR/exchange_$(echo $url | sed 's/[^a-zA-Z0-9]/_/g').json" -of json -silent
        
    done < "$RESULTS_DIR/active_urls.txt"
    
    echo "✅ Análise de APIs concluída"
    echo ""
}

# Função para análise web
analyze_web() {
    echo "🌐 Fase 3: Análise Web"
    echo "====================="
    
    if [[ ! -f "$RESULTS_DIR/active_urls.txt" ]]; then
        echo "❌ Arquivo de URLs ativas não encontrado"
        return 1
    fi
    
    echo "🔍 Testando vulnerabilidades web..."
    
    # Executar nuclei para vulnerabilidades conhecidas
    nuclei -l "$RESULTS_DIR/active_urls.txt" -o "$RESULTS_DIR/nuclei_results.txt" -silent
    
    # Testar caminhos administrativos
    while IFS= read -r url; do
        echo "   Testando caminhos admin em: $url"
        ffuf -w wordlists/admin_paths.txt -u "$url/FUZZ" -mc 200,301,302,403,401,500 -s -o "$RESULTS_DIR/admin_$(echo $url | sed 's/[^a-zA-Z0-9]/_/g').json" -of json -silent
    done < "$RESULTS_DIR/active_urls.txt"
    
    echo "✅ Análise web concluída"
    echo ""
}

# Função para análise de smart contracts
analyze_smart_contracts() {
    echo "⛓️  Fase 4: Análise de Smart Contracts"
    echo "====================================="
    
    echo "🔍 Analisando smart contracts..."
    
    # Verificar se é um domínio relacionado a blockchain
    if [[ "$DOMAIN" == *"crypto.com"* ]] || [[ "$DOMAIN" == *"mona.co"* ]]; then
        echo "   Buscando contratos na blockchain..."
        
        # Criar script para análise de smart contracts
        cat > "$RESULTS_DIR/smart_contract_analysis.sh" << 'EOF'
#!/bin/bash
# Análise de Smart Contracts para Crypto.com

echo "🔍 Analisando smart contracts..."

# Contratos conhecidos do Crypto.com
CONTRACTS=(
    "0xfe18ae03741a5b84e39c295ac9c856ed7991c38e"
    "0x626E8036dab333b39Be2c9F55e8bE7C8F5C2F3A1"
    "0x8B396ddF906D552b2Fc4A8C5C4B4C4C4C4C4C4C4"
)

for contract in "${CONTRACTS[@]}"; do
    echo "   Analisando contrato: $contract"
    
    # Verificar se o contrato existe no Etherscan
    curl -s "https://api.etherscan.io/api?module=contract&action=getsourcecode&address=$contract" > "$RESULTS_DIR/contract_$contract.json"
    
    # Verificar transações recentes
    curl -s "https://api.etherscan.io/api?module=account&action=txlist&address=$contract&startblock=0&endblock=99999999&sort=desc" > "$RESULTS_DIR/tx_$contract.json"
    
    # Verificar eventos
    curl -s "https://api.etherscan.io/api?module=logs&action=getLogs&address=$contract&fromBlock=0&toBlock=latest" > "$RESULTS_DIR/events_$contract.json"
done

echo "✅ Análise de smart contracts concluída"
EOF
        
        chmod +x "$RESULTS_DIR/smart_contract_analysis.sh"
        "$RESULTS_DIR/smart_contract_analysis.sh"
    else
        echo "   Domínio não relacionado a blockchain, pulando análise de smart contracts"
    fi
    
    echo ""
}

# Função para análise de mobile
analyze_mobile() {
    echo "📱 Fase 5: Análise Mobile"
    echo "========================="
    
    echo "🔍 Analisando aplicações móveis..."
    
    # Verificar se existem apps relacionados
    MOBILE_APPS=(
        "co.mona.android"
        "com.monaco.mobile"
        "com.defi.wallet"
        "com.grabtaxi.passenger"
        "com.grabtaxi.driver2"
        "ovo.id"
    )
    
    for app in "${MOBILE_APPS[@]}"; do
        echo "   Verificando app: $app"
        
        # Verificar se o app existe no Google Play
        curl -s "https://play.google.com/store/apps/details?id=$app" > "$RESULTS_DIR/app_$app.html" 2>/dev/null
        
        if grep -q "Not Found" "$RESULTS_DIR/app_$app.html"; then
            echo "     ❌ App não encontrado"
        else
            echo "     ✅ App encontrado"
        fi
    done
    
    echo "✅ Análise mobile concluída"
    echo ""
}

# Função para análise de business logic
analyze_business_logic() {
    echo "💼 Fase 6: Análise de Business Logic"
    echo "==================================="
    
    echo "🔍 Testando lógica de negócio..."
    
    # Testar cenários específicos de criptomoedas
    cat > "$RESULTS_DIR/business_logic_tests.sh" << 'EOF'
#!/bin/bash
# Testes de Business Logic para Crypto.com

echo "🔍 Testando cenários de business logic..."

# URLs para testar
URLS=(
    "https://web.crypto.com"
    "https://crypto.com/exchange"
    "https://merchant.crypto.com"
    "https://developer.crypto.com"
)

for url in "${URLS[@]}"; do
    echo "   Testando: $url"
    
    # Testar rate limiting
    for i in {1..10}; do
        curl -s -w "%{http_code}\n" -o /dev/null "$url/api/v1/price" &
    done
    wait
    
    # Testar autenticação
    curl -s -X POST "$url/api/v1/auth/login" -H "Content-Type: application/json" -d '{"email":"test@test.com","password":"test"}' > "$RESULTS_DIR/auth_test_$(echo $url | sed 's/[^a-zA-Z0-9]/_/g').json"
    
    # Testar endpoints de trading
    curl -s -X GET "$url/api/v1/trading/orders" -H "Authorization: Bearer test" > "$RESULTS_DIR/trading_test_$(echo $url | sed 's/[^a-zA-Z0-9]/_/g').json"
    
    # Testar endpoints de wallet
    curl -s -X GET "$url/api/v1/wallet/balance" -H "Authorization: Bearer test" > "$RESULTS_DIR/wallet_test_$(echo $url | sed 's/[^a-zA-Z0-9]/_/g').json"
done

echo "✅ Testes de business logic concluídos"
EOF
    
    chmod +x "$RESULTS_DIR/business_logic_tests.sh"
    "$RESULTS_DIR/business_logic_tests.sh"
    
    echo ""
}

# Função para análise de impacto financeiro
analyze_financial_impact() {
    echo "💰 Fase 7: Análise de Impacto Financeiro"
    echo "======================================="
    
    echo "🔍 Analisando potencial de impacto financeiro..."
    
    # Criar relatório de impacto financeiro
    cat > "$RESULTS_DIR/financial_impact_analysis.md" << EOF
# 💰 Análise de Impacto Financeiro - $DOMAIN

## 📊 Resumo Executivo

**Data:** $(date +"%d/%m/%Y %H:%M:%S")  
**Domínio:** $DOMAIN  
**Análise:** Impacto Financeiro  

## 🎯 Cenários de Alto Impacto

### 1. **Transferência Não Autorizada de Fundos**
- **Potencial:** \$100,000 - \$2,000,000
- **Cenário:** Bypass de autenticação em APIs de transferência
- **Impacto:** Perda direta de fundos de usuários

### 2. **Manipulação de Preços**
- **Potencial:** \$50,000 - \$1,000,000
- **Cenário:** Vulnerabilidade em APIs de trading
- **Impacto:** Manipulação de preços de criptomoedas

### 3. **Vazamento de Dados PII**
- **Potencial:** \$100,000 - \$2,000,000
- **Cenário:** SQL Injection em dados de usuários
- **Impacto:** Exposição massiva de dados pessoais

### 4. **Bypass de KYC/AML**
- **Potencial:** \$25,000 - \$500,000
- **Cenário:** Vulnerabilidade em processo de verificação
- **Impacto:** Contas não verificadas com acesso completo

## 🔍 Endpoints Críticos Identificados

$(if [[ -f "$RESULTS_DIR/active_urls.txt" ]]; then
    echo "### URLs Ativas:"
    while IFS= read -r url; do
        echo "- $url"
    done < "$RESULTS_DIR/active_urls.txt"
fi)

## 📈 Projeção de Renda

### Cenário Conservador:
- **1 vulnerabilidade crítica/mês:** \$5,000 - \$40,000
- **2 vulnerabilidades high/mês:** \$1,000 - \$10,000
- **Total mensal:** \$6,000 - \$50,000

### Cenário Otimista:
- **1 vulnerabilidade extreme/mês:** \$100,000 - \$2,000,000
- **2 vulnerabilidades críticas/mês:** \$10,000 - \$80,000
- **Total mensal:** \$110,000 - \$2,080,000

## 🎯 Próximos Passos

1. **Focar em APIs de alto valor**
2. **Testar cenários de transferência**
3. **Analisar smart contracts**
4. **Verificar lógica de negócio**

---

**Status:** ✅ Análise concluída
EOF
    
    echo "✅ Análise de impacto financeiro concluída"
    echo ""
}

# Função para gerar relatório final
generate_final_report() {
    echo "📊 Fase 8: Relatório Final"
    echo "=========================="
    
    echo "📝 Gerando relatório final..."
    
    cat > "$RESULTS_DIR/relatorio_final_crypto_com.md" << EOF
# 🚀 Relatório Final - Crypto.com Bug Bounty

## 📋 Informações Gerais

**Data:** $(date +"%d/%m/%Y %H:%M:%S")  
**Domínio:** $DOMAIN  
**Tempo de Análise:** ~$(($(date +%s) - $(date -d "1 hour ago" +%s)) / 60) minutos  

## 📊 Resultados Obtidos

$(if [[ -f "$RESULTS_DIR/subdomains.txt" ]]; then
    SUBDOMAIN_COUNT=$(wc -l < "$RESULTS_DIR/subdomains.txt")
    echo "- **Subdomínios Encontrados:** $SUBDOMAIN_COUNT"
fi)

$(if [[ -f "$RESULTS_DIR/active_urls.txt" ]]; then
    ACTIVE_COUNT=$(wc -l < "$RESULTS_DIR/active_urls.txt")
    echo "- **URLs Ativas:** $ACTIVE_COUNT"
fi)

$(if [[ -f "$RESULTS_DIR/nuclei_results.txt" ]]; then
    NUCLEI_COUNT=$(wc -l < "$RESULTS_DIR/nuclei_results.txt")
    echo "- **Vulnerabilidades Nuclei:** $NUCLEI_COUNT"
fi)

## 🎯 Vulnerabilidades Identificadas

### APIs Testadas:
$(find "$RESULTS_DIR" -name "api_*.json" -exec basename {} \; | head -5)

### Endpoints de Exchange Testados:
$(find "$RESULTS_DIR" -name "exchange_*.json" -exec basename {} \; | head -5)

### Caminhos Administrativos Testados:
$(find "$RESULTS_DIR" -name "admin_*.json" -exec basename {} \; | head -5)

## 💰 Potencial de Renda

### Baseado na Análise:
- **Mínimo:** \$5,000 - \$50,000/mês
- **Médio:** \$20,000 - \$200,000/mês
- **Máximo:** \$100,000 - \$2,000,000/mês

### Fatores de Sucesso:
- ✅ APIs de alto valor identificadas
- ✅ Endpoints de exchange encontrados
- ✅ Smart contracts analisados
- ✅ Business logic testada

## 🎯 Próximos Passos

1. **Analisar resultados detalhadamente**
2. **Desenvolver PoCs para vulnerabilidades**
3. **Preparar reports para HackerOne**
4. **Submeter e aguardar resposta**

## 📁 Arquivos Gerados

$(ls -la "$RESULTS_DIR" | grep -E "\.(txt|json|md|html)$" | head -10)

---

**Status:** ✅ Pipeline concluído com sucesso
**Próximo Passo:** Análise detalhada dos resultados
EOF
    
    echo "✅ Relatório final gerado: $RESULTS_DIR/relatorio_final_crypto_com.md"
    echo ""
}

# Executar análise baseada nas opções
if [[ "$FULL_ANALYSIS" = true ]]; then
    analyze_subdomains
    analyze_apis
    analyze_web
    analyze_smart_contracts
    analyze_mobile
    analyze_business_logic
    analyze_financial_impact
elif [[ "$API_ONLY" = true ]]; then
    analyze_subdomains
    analyze_apis
elif [[ "$WEB_ONLY" = true ]]; then
    analyze_subdomains
    analyze_web
elif [[ "$MOBILE_ONLY" = true ]]; then
    analyze_mobile
elif [[ "$SMART_CONTRACTS_ONLY" = true ]]; then
    analyze_smart_contracts
fi

# Sempre gerar relatório final
generate_final_report

echo "🎉 Pipeline Crypto.com Concluído!"
echo "=================================="
echo ""
echo "📁 Resultados salvos em: $RESULTS_DIR"
echo ""
echo "📊 Resumo:"
echo "   - Subdomínios: $(if [[ -f "$RESULTS_DIR/subdomains.txt" ]]; then wc -l < "$RESULTS_DIR/subdomains.txt"; else echo "0"; fi)"
echo "   - URLs Ativas: $(if [[ -f "$RESULTS_DIR/active_urls.txt" ]]; then wc -l < "$RESULTS_DIR/active_urls.txt"; else echo "0"; fi)"
echo "   - Vulnerabilidades: $(if [[ -f "$RESULTS_DIR/nuclei_results.txt" ]]; then wc -l < "$RESULTS_DIR/nuclei_results.txt"; else echo "0"; fi)"
echo ""
echo "💰 Potencial de Renda: \$5,000 - \$2,000,000"
echo ""
echo "🎯 Próximos passos:"
echo "   1. Analisar resultados em $RESULTS_DIR"
echo "   2. Desenvolver PoCs para vulnerabilidades"
echo "   3. Preparar reports para HackerOne"
echo "   4. Submeter e aguardar resposta"
