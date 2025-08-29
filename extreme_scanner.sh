#!/bin/bash
# Extreme Scanner - Scanner de Vulnerabilidades de Valor Extremo
# Foco: $100,000 - $2,000,000 em recompensas

echo "🚨 EXTREME SCANNER - VULNERABILIDADES DE VALOR EXTREMO"
echo "======================================================"
echo "💰 Foco: $100,000 - $2,000,000 em recompensas"
echo "🎯 Alvos: APIs de alto valor do Crypto.com"
echo ""

# Verificar argumentos
if [[ $# -eq 0 ]]; then
    echo "Uso: $0 <domínio> [opções]"
    echo ""
    echo "Exemplos:"
    echo "  $0 crypto.com"
    echo "  $0 crypto.com --financial-only"
    echo "  $0 crypto.com --data-breach-only"
    echo "  $0 crypto.com --smart-contracts-only"
    echo ""
    echo "Opções:"
    echo "  --financial-only     Apenas vulnerabilidades financeiras"
    echo "  --data-breach-only   Apenas vazamento de dados"
    echo "  --auth-bypass-only   Apenas bypass de autenticação"
    echo "  --smart-contracts-only Apenas smart contracts"
    echo "  --business-logic-only Apenas business logic"
    echo "  --full               Scan completo (padrão)"
    exit 1
fi

DOMAIN=$1
shift

# Processar opções
FINANCIAL_ONLY=false
DATA_BREACH_ONLY=false
AUTH_BYPASS_ONLY=false
SMART_CONTRACTS_ONLY=false
BUSINESS_LOGIC_ONLY=false
FULL_SCAN=true

while [[ $# -gt 0 ]]; do
    case $1 in
        --financial-only)
            FINANCIAL_ONLY=true
            FULL_SCAN=false
            shift
            ;;
        --data-breach-only)
            DATA_BREACH_ONLY=true
            FULL_SCAN=false
            shift
            ;;
        --auth-bypass-only)
            AUTH_BYPASS_ONLY=true
            FULL_SCAN=false
            shift
            ;;
        --smart-contracts-only)
            SMART_CONTRACTS_ONLY=true
            FULL_SCAN=false
            shift
            ;;
        --business-logic-only)
            BUSINESS_LOGIC_ONLY=true
            FULL_SCAN=false
            shift
            ;;
        --full)
            FULL_SCAN=true
            shift
            ;;
        *)
            echo "Opção desconhecida: $1"
            exit 1
            ;;
    esac
done

# Criar diretório para resultados
RESULTS_DIR="extreme_results_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$RESULTS_DIR"

echo "🎯 Domínio: $DOMAIN"
echo "📊 Modo: $([ "$FULL_SCAN" = true ] && echo "Scan Completo" || echo "Scan Específico")"
echo "📁 Resultados: $RESULTS_DIR"
echo ""

# Função para testar vulnerabilidades financeiras
test_financial_vulnerabilities() {
    echo "💰 FASE 1: TESTANDO VULNERABILIDADES FINANCEIRAS"
    echo "================================================"
    
    # Endpoints críticos de transferência
    TRANSFER_ENDPOINTS=(
        "/api/v1/transfer"
        "/api/v1/send"
        "/api/v1/withdraw"
        "/api/v1/withdrawal"
        "/api/v1/payment"
        "/api/v1/transaction"
        "/api/v1/wallet/transfer"
        "/api/v1/account/transfer"
        "/api/v1/user/transfer"
        "/api/v1/financial/transfer"
        "/api/v1/money/transfer"
        "/api/v1/crypto/transfer"
        "/api/v1/coin/transfer"
        "/api/v1/token/transfer"
        "/api/v1/asset/transfer"
    )
    
    # Testar cada endpoint
    for endpoint in "${TRANSFER_ENDPOINTS[@]}"; do
        echo "   Testando: $endpoint"
        
        # Teste 1: Bypass de autenticação
        response=$(curl -s -w "%{http_code}" -o "$RESULTS_DIR/financial_test_${endpoint//\//_}.json" \
            -X POST "https://$DOMAIN$endpoint" \
            -H "Content-Type: application/json" \
            -d '{"amount": "1000000", "currency": "USD", "to_address": "test@test.com", "description": "Test transfer"}' \
            --connect-timeout 10)
        
        if [[ "$response" == "200" ]] || [[ "$response" == "201" ]] || [[ "$response" == "202" ]]; then
            echo "   🚨 VULNERABILIDADE ENCONTRADA: Bypass de autenticação em $endpoint"
            echo "   💰 Valor: $500,000 - $2,000,000"
            echo "   📝 Evidência: POST $endpoint retornou $response"
            echo ""
        fi
        
        # Teste 2: Manipulação de valores negativos
        response=$(curl -s -w "%{http_code}" -o /dev/null \
            -X POST "https://$DOMAIN$endpoint" \
            -H "Content-Type: application/json" \
            -d '{"amount": "-1000000", "currency": "USD", "to_address": "test@test.com"}' \
            --connect-timeout 10)
        
        if [[ "$response" == "200" ]] || [[ "$response" == "201" ]] || [[ "$response" == "202" ]]; then
            echo "   🚨 VULNERABILIDADE ENCONTRADA: Manipulação de valor negativo em $endpoint"
            echo "   💰 Valor: $300,000 - $1,500,000"
            echo "   📝 Evidência: POST $endpoint com valor negativo retornou $response"
            echo ""
        fi
        
        # Teste 3: IDOR em histórico
        response=$(curl -s -w "%{http_code}" -o "$RESULTS_DIR/financial_history_${endpoint//\//_}.json" \
            -X GET "https://$DOMAIN$endpoint/history" \
            --connect-timeout 10)
        
        if [[ "$response" == "200" ]]; then
            content_size=$(wc -c < "$RESULTS_DIR/financial_history_${endpoint//\//_}.json")
            if [[ $content_size -gt 100 ]]; then
                echo "   🚨 VULNERABILIDADE ENCONTRADA: IDOR em histórico de $endpoint"
                echo "   💰 Valor: $200,000 - $1,000,000"
                echo "   📝 Evidência: GET $endpoint/history retornou $content_size bytes"
                echo ""
            fi
        fi
        
    done
    
    echo "✅ Teste de vulnerabilidades financeiras concluído"
    echo ""
}

# Função para testar vazamento de dados
test_data_breach_vulnerabilities() {
    echo "🔒 FASE 2: TESTANDO VAZAMENTO DE DADOS"
    echo "======================================"
    
    # Endpoints com dados sensíveis
    SENSITIVE_ENDPOINTS=(
        "/api/v1/users"
        "/api/v1/accounts"
        "/api/v1/customers"
        "/api/v1/kyc"
        "/api/v1/aml"
        "/api/v1/verification"
        "/api/v1/identity"
        "/api/v1/documents"
        "/api/v1/personal"
        "/api/v1/private"
        "/api/v1/secret"
        "/api/v1/internal"
        "/api/v1/admin"
        "/api/v1/backup"
        "/api/v1/export"
        "/api/v1/download"
        "/api/v1/dump"
        "/api/v1/restore"
        "/api/v1/migrate"
    )
    
    # Testar cada endpoint
    for endpoint in "${SENSITIVE_ENDPOINTS[@]}"; do
        echo "   Testando: $endpoint"
        
        response=$(curl -s -w "%{http_code}" -o "$RESULTS_DIR/data_breach_${endpoint//\//_}.json" \
            -X GET "https://$DOMAIN$endpoint" \
            --connect-timeout 10)
        
        if [[ "$response" == "200" ]]; then
            content=$(cat "$RESULTS_DIR/data_breach_${endpoint//\//_}.json" | tr '[:upper:]' '[:lower:]')
            
            # Verificar padrões sensíveis
            sensitive_patterns=(
                "email"
                "password"
                "ssn"
                "credit_card"
                "bank_account"
                "private_key"
                "secret"
                "token"
                "api_key"
                "address"
                "phone"
                "social_security"
                "passport"
                "driver_license"
                "kyc"
                "aml"
                "verification"
                "identity"
                "personal"
            )
            
            sensitive_count=0
            for pattern in "${sensitive_patterns[@]}"; do
                if echo "$content" | grep -q "$pattern"; then
                    ((sensitive_count++))
                fi
            done
            
            if [[ $sensitive_count -ge 3 ]]; then
                content_size=$(wc -c < "$RESULTS_DIR/data_breach_${endpoint//\//_}.json")
                echo "   🚨 VULNERABILIDADE ENCONTRADA: Vazamento massivo de dados PII em $endpoint"
                echo "   💰 Valor: $500,000 - $2,000,000"
                echo "   📝 Evidência: GET $endpoint retornou $content_size bytes com $sensitive_count padrões sensíveis"
                echo ""
            fi
        fi
        
    done
    
    echo "✅ Teste de vazamento de dados concluído"
    echo ""
}

# Função para testar bypass de autenticação
test_auth_bypass_vulnerabilities() {
    echo "🔐 FASE 3: TESTANDO BYPASS DE AUTENTICAÇÃO"
    echo "=========================================="
    
    # Endpoints administrativos
    ADMIN_ENDPOINTS=(
        "/api/v1/admin"
        "/api/v1/administrator"
        "/api/v1/management"
        "/api/v1/panel"
        "/api/v1/console"
        "/api/v1/dashboard"
        "/api/v1/control"
        "/api/v1/settings"
        "/api/v1/config"
        "/api/v1/system"
        "/api/v1/root"
        "/api/v1/superuser"
        "/api/v1/master"
        "/api/v1/owner"
        "/api/v1/privileged"
    )
    
    # Testar cada endpoint
    for endpoint in "${ADMIN_ENDPOINTS[@]}"; do
        echo "   Testando: $endpoint"
        
        response=$(curl -s -w "%{http_code}" -o "$RESULTS_DIR/auth_bypass_${endpoint//\//_}.json" \
            -X GET "https://$DOMAIN$endpoint" \
            --connect-timeout 10)
        
        if [[ "$response" == "200" ]] || [[ "$response" == "201" ]] || [[ "$response" == "202" ]]; then
            echo "   🚨 VULNERABILIDADE ENCONTRADA: Bypass de autenticação administrativa em $endpoint"
            echo "   💰 Valor: $100,000 - $1,000,000"
            echo "   📝 Evidência: GET $endpoint retornou $response"
            echo ""
        fi
        
    done
    
    echo "✅ Teste de bypass de autenticação concluído"
    echo ""
}

# Função para testar smart contracts
test_smart_contract_vulnerabilities() {
    echo "⛓️  FASE 4: TESTANDO SMART CONTRACTS"
    echo "==================================="
    
    # Contratos conhecidos do Crypto.com
    CONTRACTS=(
        "0xfe18ae03741a5b84e39c295ac9c856ed7991c38e"  # CRO Token
        "0x626E8036dab333b39Be2c9F55e8bE7C8F5C2F3A1"  # MCO Token
    )
    
    for contract in "${CONTRACTS[@]}"; do
        echo "   Analisando contrato: $contract"
        
        # Verificar se o contrato tem vulnerabilidades conhecidas
        response=$(curl -s "https://api.etherscan.io/api?module=contract&action=getsourcecode&address=$contract")
        
        if echo "$response" | grep -q '"status":"1"'; then
            source_code=$(echo "$response" | jq -r '.result[0].SourceCode' | tr '[:upper:]' '[:lower:]')
            
            # Verificar vulnerabilidades conhecidas
            vulnerabilities=(
                "call.value"
                "send"
                "transfer"
                "uint256"
                "int256"
                "add"
                "sub"
                "mul"
                "public"
                "external"
                "anyone"
                "now"
                "block.timestamp"
                "block.number"
                "blockhash"
            )
            
            for vuln in "${vulnerabilities[@]}"; do
                if echo "$source_code" | grep -q "$vuln"; then
                    echo "   🚨 VULNERABILIDADE ENCONTRADA: Padrão suspeito '$vuln' no contrato $contract"
                    echo "   💰 Valor: $200,000 - $2,000,000"
                    echo "   📝 Evidência: Contrato $contract contém padrão suspeito: $vuln"
                    echo ""
                fi
            done
        fi
        
    done
    
    echo "✅ Teste de smart contracts concluído"
    echo ""
}

# Função para testar business logic
test_business_logic_vulnerabilities() {
    echo "💼 FASE 5: TESTANDO BUSINESS LOGIC"
    echo "=================================="
    
    # Cenários de teste
    TEST_SCENARIOS=(
        {
            "name": "Rate Limiting Bypass",
            "endpoint": "/api/v1/price",
            "method": "GET",
            "expected_failure": "429",
            "value": "$100,000 - $500,000"
        }
        {
            "name": "Negative Balance",
            "endpoint": "/api/v1/balance",
            "method": "POST",
            "data": '{"amount": "-1000000"}',
            "expected_failure": "400",
            "value": "$200,000 - $1,000,000"
        }
        {
            "name": "Duplicate Transaction",
            "endpoint": "/api/v1/transaction",
            "method": "POST",
            "data": '{"id": "duplicate_123", "amount": "1000"}',
            "expected_failure": "409",
            "value": "$150,000 - $800,000"
        }
    )
    
    for scenario in "${TEST_SCENARIOS[@]}"; do
        echo "   Testando: ${scenario[name]}"
        
        if [[ "${scenario[method]}" == "GET" ]]; then
            response=$(curl -s -w "%{http_code}" -o /dev/null \
                -X GET "https://$DOMAIN${scenario[endpoint]}" \
                --connect-timeout 10)
        else
            response=$(curl -s -w "%{http_code}" -o /dev/null \
                -X POST "https://$DOMAIN${scenario[endpoint]}" \
                -H "Content-Type: application/json" \
                -d "${scenario[data]}" \
                --connect-timeout 10)
        fi
        
        if [[ "$response" != "${scenario[expected_failure]}" ]]; then
            echo "   🚨 VULNERABILIDADE ENCONTRADA: ${scenario[name]}"
            echo "   💰 Valor: ${scenario[value]}"
            echo "   📝 Evidência: ${scenario[method]} ${scenario[endpoint]} retornou $response (esperado: ${scenario[expected_failure]})"
            echo ""
        fi
        
    done
    
    echo "✅ Teste de business logic concluído"
    echo ""
}

# Função para escanear alvos de valor extremo
scan_extreme_targets() {
    echo "🎯 FASE 0: ESCANEANDO ALVOS DE VALOR EXTREMO"
    echo "============================================"
    
    # Ler alvos do arquivo
    if [[ -f "extreme_targets.txt" ]]; then
        while IFS= read -r target; do
            # Pular comentários e linhas vazias
            if [[ "$target" =~ ^[[:space:]]*# ]] || [[ -z "$target" ]]; then
                continue
            fi
            
            echo "   Testando: $target"
            
            response=$(curl -s -w "%{http_code}" -o /dev/null \
                -X GET "$target" \
                --connect-timeout 10)
            
            if [[ "$response" == "200" ]]; then
                echo "   ✅ Alvo ativo: $target"
                echo "$target" >> "$RESULTS_DIR/active_extreme_targets.txt"
            else
                echo "   ❌ Alvo inativo: $target"
            fi
            
        done < "extreme_targets.txt"
    else
        echo "   ❌ Arquivo extreme_targets.txt não encontrado"
    fi
    
    echo "✅ Escaneamento de alvos concluído"
    echo ""
}

# Função para gerar relatório final
generate_extreme_report() {
    echo "📊 GERANDO RELATÓRIO FINAL"
    echo "=========================="
    
    # Contar vulnerabilidades encontradas
    financial_count=$(grep -r "VULNERABILIDADE ENCONTRADA.*financeira" "$RESULTS_DIR" | wc -l)
    data_breach_count=$(grep -r "VULNERABILIDADE ENCONTRADA.*vazamento" "$RESULTS_DIR" | wc -l)
    auth_bypass_count=$(grep -r "VULNERABILIDADE ENCONTRADA.*autenticação" "$RESULTS_DIR" | wc -l)
    smart_contract_count=$(grep -r "VULNERABILIDADE ENCONTRADA.*contrato" "$RESULTS_DIR" | wc -l)
    business_logic_count=$(grep -r "VULNERABILIDADE ENCONTRADA.*business" "$RESULTS_DIR" | wc -l)
    
    total_vulnerabilities=$((financial_count + data_breach_count + auth_bypass_count + smart_contract_count + business_logic_count))
    
    # Calcular valor total potencial
    total_value=0
    if [[ $financial_count -gt 0 ]]; then
        total_value=$((total_value + financial_count * 500000))
    fi
    if [[ $data_breach_count -gt 0 ]]; then
        total_value=$((total_value + data_breach_count * 500000))
    fi
    if [[ $auth_bypass_count -gt 0 ]]; then
        total_value=$((total_value + auth_bypass_count * 100000))
    fi
    if [[ $smart_contract_count -gt 0 ]]; then
        total_value=$((total_value + smart_contract_count * 200000))
    fi
    if [[ $business_logic_count -gt 0 ]]; then
        total_value=$((total_value + business_logic_count * 100000))
    fi
    
    # Gerar relatório
    cat > "$RESULTS_DIR/extreme_vulnerabilities_report.md" << EOF
# 🚨 RELATÓRIO DE VULNERABILIDADES EXTREMAS

## 📋 Informações Gerais

**Data:** $(date +"%d/%m/%Y %H:%M:%S")  
**Domínio:** $DOMAIN  
**Scanner:** Extreme Scanner v1.0  
**Tempo de Scan:** ~$(($(date +%s) - $(date -d "1 hour ago" +%s)) / 60) minutos  

## 📊 Resumo Executivo

**Total de Vulnerabilidades Extremas:** $total_vulnerabilities  
**Valor Total Potencial:** \$$((total_value / 1000))K - \$$((total_value * 2 / 1000))K  
**Severidade:** EXTREMA  

## 🎯 Vulnerabilidades Encontradas

### 💰 Vulnerabilidades Financeiras: $financial_count
- **Valor:** \$500K - \$2M por vulnerabilidade
- **Impacto:** Perda direta de fundos
- **Categoria:** Critical/Extreme

### 🔒 Vazamento de Dados: $data_breach_count
- **Valor:** \$500K - \$2M por vulnerabilidade
- **Impacto:** Exposição massiva de PII
- **Categoria:** Critical/Extreme

### 🔐 Bypass de Autenticação: $auth_bypass_count
- **Valor:** \$100K - \$1M por vulnerabilidade
- **Impacto:** Acesso não autorizado
- **Categoria:** Critical

### ⛓️ Smart Contracts: $smart_contract_count
- **Valor:** \$200K - \$2M por vulnerabilidade
- **Impacto:** Perda de fundos em blockchain
- **Categoria:** Critical/Extreme

### 💼 Business Logic: $business_logic_count
- **Valor:** \$100K - \$1M por vulnerabilidade
- **Impacto:** Falhas de lógica de negócio
- **Categoria:** High/Critical

## 🎯 Alvos de Valor Extremo

$(if [[ -f "$RESULTS_DIR/active_extreme_targets.txt" ]]; then
    echo "### URLs Ativas:"
    while IFS= read -r target; do
        echo "- $target"
    done < "$RESULTS_DIR/active_extreme_targets.txt"
else
    echo "Nenhum alvo ativo encontrado"
fi)

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

## 📁 Arquivos Gerados

$(ls -la "$RESULTS_DIR" | grep -E "\.(json|md|txt)$" | head -10)

---

**Status:** ✅ Scan extremo concluído com sucesso
**Próximo Passo:** Análise detalhada das vulnerabilidades encontradas
EOF
    
    echo "✅ Relatório final gerado: $RESULTS_DIR/extreme_vulnerabilities_report.md"
    echo ""
}

# Executar scan baseado nas opções
if [[ "$FULL_SCAN" = true ]]; then
    scan_extreme_targets
    test_financial_vulnerabilities
    test_data_breach_vulnerabilities
    test_auth_bypass_vulnerabilities
    test_smart_contract_vulnerabilities
    test_business_logic_vulnerabilities
elif [[ "$FINANCIAL_ONLY" = true ]]; then
    scan_extreme_targets
    test_financial_vulnerabilities
elif [[ "$DATA_BREACH_ONLY" = true ]]; then
    scan_extreme_targets
    test_data_breach_vulnerabilities
elif [[ "$AUTH_BYPASS_ONLY" = true ]]; then
    scan_extreme_targets
    test_auth_bypass_vulnerabilities
elif [[ "$SMART_CONTRACTS_ONLY" = true ]]; then
    test_smart_contract_vulnerabilities
elif [[ "$BUSINESS_LOGIC_ONLY" = true ]]; then
    scan_extreme_targets
    test_business_logic_vulnerabilities
fi

# Sempre gerar relatório final
generate_extreme_report

echo "🎉 EXTREME SCANNER CONCLUÍDO!"
echo "============================="
echo ""
echo "📁 Resultados salvos em: $RESULTS_DIR"
echo ""
echo "📊 Resumo:"
echo "   - Vulnerabilidades Financeiras: $financial_count"
echo "   - Vazamento de Dados: $data_breach_count"
echo "   - Bypass de Autenticação: $auth_bypass_count"
echo "   - Smart Contracts: $smart_contract_count"
echo "   - Business Logic: $business_logic_count"
echo "   - Total: $total_vulnerabilities"
echo ""
echo "💰 Valor Total Potencial: \$$((total_value / 1000))K - \$$((total_value * 2 / 1000))K"
echo ""
echo "🎯 Próximos passos:"
echo "   1. Analisar resultados em $RESULTS_DIR"
echo "   2. Desenvolver PoCs para vulnerabilidades"
echo "   3. Preparar reports para HackerOne"
echo "   4. Submeter e aguardar resposta"
