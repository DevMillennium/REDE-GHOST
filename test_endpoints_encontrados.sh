#!/bin/bash
# Script para Testar Endpoints Encontrados - Análise Detalhada

echo "🔍 Testando Endpoints Encontrados - Análise Detalhada"
echo "===================================================="

# Verificar se os arquivos de resultados existem
if [[ ! -f "resultados_renda_real.txt" ]]; then
    echo "❌ Arquivo resultados_renda_real.txt não encontrado!"
    exit 1
fi

# Criar diretório para resultados detalhados
mkdir -p testes_detalhados

echo "📋 Analisando endpoints encontrados..."

# Extrair URLs dos resultados
grep "Alvo:" resultados_renda_real.txt | while read line; do
    url=$(echo "$line" | sed 's/Alvo: //' | sed 's/ - Tipo:.*//')
    tipo=$(echo "$line" | sed 's/.*Tipo: //')
    
    echo ""
    echo "🎯 Testando: $url"
    echo "📝 Tipo: $tipo"
    echo "=================================="
    
    # Testar conectividade básica
    echo "📡 Teste de conectividade..."
    response_code=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    echo "   Status Code: $response_code"
    
    # Testar headers de segurança
    echo "🔒 Analisando headers de segurança..."
    curl -s -I "$url" > "testes_detalhados/headers_$(echo $url | sed 's/[^a-zA-Z0-9]/_/g').txt"
    
    # Verificar se há headers de segurança
    if grep -i "x-frame-options\|x-content-type-options\|x-xss-protection\|strict-transport-security" "testes_detalhados/headers_$(echo $url | sed 's/[^a-zA-Z0-9]/_/g').txt" > /dev/null; then
        echo "   ✅ Headers de segurança encontrados"
    else
        echo "   ⚠️  Headers de segurança ausentes"
    fi
    
    # Testar endpoints específicos encontrados
    if [[ "$tipo" == "API Endpoints" ]]; then
        echo "🔍 Testando endpoints de API específicos..."
        
        # Testar endpoints comuns de API
        api_endpoints=("status" "health" "ping" "info" "version" "docs" "swagger" "openapi")
        
        for endpoint in "${api_endpoints[@]}"; do
            test_url="$url/$endpoint"
            echo "   Testando: $test_url"
            
            response=$(curl -s -w "%{http_code}" "$test_url" -o "testes_detalhados/api_$(echo $url | sed 's/[^a-zA-Z0-9]/_/g')_$endpoint.txt")
            status_code="${response: -3}"
            
            if [[ "$status_code" == "200" ]]; then
                echo "   ✅ $endpoint - Status: $status_code"
            elif [[ "$status_code" == "403" ]]; then
                echo "   🔒 $endpoint - Protegido (403)"
            elif [[ "$status_code" == "401" ]]; then
                echo "   🔐 $endpoint - Autenticação requerida (401)"
            else
                echo "   ❌ $endpoint - Status: $status_code"
            fi
        done
    fi
    
    if [[ "$tipo" == "Admin Paths" ]]; then
        echo "🔐 Testando caminhos administrativos..."
        
        # Testar caminhos administrativos específicos
        admin_endpoints=("admin" "login" "dashboard" "panel" "console" "manage")
        
        for endpoint in "${admin_endpoints[@]}"; do
            test_url="$url/$endpoint"
            echo "   Testando: $test_url"
            
            response=$(curl -s -w "%{http_code}" "$test_url" -o "testes_detalhados/admin_$(echo $url | sed 's/[^a-zA-Z0-9]/_/g')_$endpoint.txt")
            status_code="${response: -3}"
            
            if [[ "$status_code" == "200" ]]; then
                echo "   🚨 ALERTA: $endpoint acessível (200)!"
            elif [[ "$status_code" == "403" ]]; then
                echo "   🔒 $endpoint - Protegido (403)"
            elif [[ "$status_code" == "401" ]]; then
                echo "   🔐 $endpoint - Autenticação requerida (401)"
            else
                echo "   ❌ $endpoint - Status: $status_code"
            fi
        done
    fi
    
    # Testar métodos HTTP
    echo "🌐 Testando métodos HTTP..."
    for method in "GET" "POST" "PUT" "DELETE" "OPTIONS"; do
        if [[ "$method" == "GET" ]]; then
            continue  # Já testamos GET
        fi
        
        response_code=$(curl -s -o /dev/null -w "%{http_code}" -X "$method" "$url")
        if [[ "$response_code" != "405" && "$response_code" != "403" ]]; then
            echo "   ⚠️  Método $method retornou: $response_code"
        fi
    done
    
    # Verificar se há informações de debug
    echo "🐛 Verificando informações de debug..."
    response_body=$(curl -s "$url")
    
    if echo "$response_body" | grep -i "error\|debug\|stack trace\|exception" > /dev/null; then
        echo "   ⚠️  Informações de debug encontradas!"
        echo "$response_body" > "testes_detalhados/debug_$(echo $url | sed 's/[^a-zA-Z0-9]/_/g').txt"
    fi
    
    # Verificar se há versões expostas
    if echo "$response_body" | grep -E "version|v[0-9]+\.[0-9]+" > /dev/null; then
        echo "   ⚠️  Versões expostas encontradas!"
    fi
    
    echo "   ✅ Teste concluído para $url"
    echo ""
    
done

echo "✅ Testes detalhados concluídos!"
echo "📊 Resultados salvos em: testes_detalhados/"

# Gerar relatório resumido
echo ""
echo "📋 Relatório Resumido:"
echo "======================"

if [[ -d "testes_detalhados" ]]; then
    echo "📁 Arquivos gerados:"
    ls -la testes_detalhados/
    
    echo ""
    echo "🔍 Endpoints acessíveis encontrados:"
    grep -r "ALERTA:" testes_detalhados/ || echo "   Nenhum endpoint acessível encontrado"
    
    echo ""
    echo "⚠️  Informações de debug encontradas:"
    ls -la testes_detalhados/debug_* 2>/dev/null || echo "   Nenhuma informação de debug encontrada"
fi

echo ""
echo "🎯 Próximos passos:"
echo "   1. Analisar arquivos gerados em testes_detalhados/"
echo "   2. Verificar endpoints acessíveis encontrados"
echo "   3. Documentar vulnerabilidades para report"
echo "   4. Executar testes de autenticação se necessário"
