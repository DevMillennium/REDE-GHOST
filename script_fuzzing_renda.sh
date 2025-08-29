#!/bin/bash
# Script de Fuzzing para Alvos de Alto Valor - Renda Real

echo "💰 Fuzzing de Alvos de Alto Valor para Renda Real"
echo "=================================================="

# Lista de alvos prioritários identificados
ALVOS_CRITICOS=(
    "https://github-mysql.0.azr.grabpay.com"
    "https://github-cassandra.0.azr.grabpay.com"
    "https://k8s-deploy-jenkins01.corp.grabpay.com"
    "https://github-administrator.0.azr.grabpay.com"
    "https://grafana.grabpay.com"
    "https://administratortash.0.azr.grabpay.com"
    "https://api.grabpay.com"
    "https://newkibana07.sg.aws.grabpay.com"
    "https://kibana-test.0.azr.grabpay.com"
)

# Verificar se as wordlists existem
API_WORDLIST="./wordlists/api_endpoints.txt"
ADMIN_WORDLIST="./wordlists/admin_paths.txt"

if [[ ! -f "$API_WORDLIST" ]] || [[ ! -f "$ADMIN_WORDLIST" ]]; then
    echo "❌ Wordlists não encontradas!"
    exit 1
fi

echo "📋 Wordlists carregadas:"
echo "   - API: $API_WORDLIST"
echo "   - Admin: $ADMIN_WORDLIST"

# Limpar resultados anteriores
> resultados_renda_real.txt
> vulnerabilidades_criticas.txt

echo "🚀 Iniciando fuzzing em alvos críticos..."

for alvo in "${ALVOS_CRITICOS[@]}"; do
    echo ""
    echo "🎯 Testando: $alvo"
    echo "=================================="
    
    # Testar conectividade básica
    echo "📡 Verificando conectividade..."
    if curl -s -o /dev/null -w "%{http_code}" "$alvo" | grep -q "200\|301\|302\|403\|401"; then
        echo "✅ Alvo acessível"
        
        # Fuzzing de endpoints de API
        echo "🔍 Testando endpoints de API..."
        ffuf -w "$API_WORDLIST" -u "$alvo/FUZZ" -mc 200,301,302,403,401,500 -s -o "api_$(echo $alvo | sed 's/[^a-zA-Z0-9]/_/g').json" -of json 2>/dev/null
        
        # Fuzzing de caminhos administrativos
        echo "🔐 Testando caminhos administrativos..."
        ffuf -w "$ADMIN_WORDLIST" -u "$alvo/FUZZ" -mc 200,301,302,403,401,500 -s -o "admin_$(echo $alvo | sed 's/[^a-zA-Z0-9]/_/g').json" -of json 2>/dev/null
        
        # Verificar se encontrou algo
        API_RESULT="api_$(echo $alvo | sed 's/[^a-zA-Z0-9]/_/g').json"
        ADMIN_RESULT="admin_$(echo $alvo | sed 's/[^a-zA-Z0-9]/_/g').json"
        
        if [[ -f "$API_RESULT" ]] && [[ -s "$API_RESULT" ]]; then
            echo "💰 ENCONTRADO: Endpoints de API em $alvo"
            echo "Alvo: $alvo - Tipo: API Endpoints" >> resultados_renda_real.txt
            cat "$API_RESULT" >> resultados_renda_real.txt
            echo "" >> resultados_renda_real.txt
        fi
        
        if [[ -f "$ADMIN_RESULT" ]] && [[ -s "$ADMIN_RESULT" ]]; then
            echo "💰 ENCONTRADO: Caminhos administrativos em $alvo"
            echo "Alvo: $alvo - Tipo: Admin Paths" >> vulnerabilidades_criticas.txt
            cat "$ADMIN_RESULT" >> vulnerabilidades_criticas.txt
            echo "" >> vulnerabilidades_criticas.txt
        fi
        
        # Limpar arquivos temporários
        rm -f "$API_RESULT" "$ADMIN_RESULT"
        
    else
        echo "❌ Alvo não acessível"
    fi
    
    # Delay para não sobrecarregar
    sleep 2
done

echo ""
echo "✅ Fuzzing concluído!"
echo "📊 Resultados salvos em:"
echo "   - resultados_renda_real.txt (APIs encontradas)"
echo "   - vulnerabilidades_criticas.txt (Admin paths encontrados)"

# Mostrar resumo
if [[ -s "resultados_renda_real.txt" ]]; then
    echo ""
    echo "💰 APIs Encontradas:"
    grep "Alvo:" resultados_renda_real.txt
fi

if [[ -s "vulnerabilidades_criticas.txt" ]]; then
    echo ""
    echo "🔐 Caminhos Administrativos Encontrados:"
    grep "Alvo:" vulnerabilidades_criticas.txt
fi

echo ""
echo "🎯 Próximos passos:"
echo "   1. Analisar resultados detalhadamente"
echo "   2. Testar endpoints específicos encontrados"
echo "   3. Verificar vulnerabilidades de autenticação"
echo "   4. Documentar para report de bug bounty"
