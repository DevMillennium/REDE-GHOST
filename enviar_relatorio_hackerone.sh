#!/bin/bash

# 🚀 Script para Envio do Relatório - HackerOne
# 📋 Relatório de Dados Reais Vazados - Crypto.com

echo "🚀 ENVIO DO RELATÓRIO PARA HACKERONE"
echo "====================================="
echo ""
echo "📁 Relatório: relatorio_dados_reais_vazados.md"
echo "🎯 Programa: Crypto.com Bug Bounty"
echo "📅 Data: $(date)"
echo ""

# Verificar se o relatório existe
if [ ! -f "relatorio_dados_reais_vazados.md" ]; then
    echo "❌ ERRO: Relatório não encontrado!"
    echo "📁 Procurando em outros locais..."
    find /Users/thyagomesquita/Desktop/REDE-GHOST -name "relatorio_dados_reais_vazados.md" 2>/dev/null
    exit 1
fi

echo "✅ Relatório encontrado!"
echo "📏 Tamanho: $(ls -lh relatorio_dados_reais_vazados.md | awk '{print $5}')"
echo ""

# Mostrar resumo do conteúdo
echo "📋 RESUMO DO RELATÓRIO:"
echo "======================="
echo ""
echo "🔍 Vulnerabilidades Identificadas:"
echo "   - Information Disclosure (Medium)"
echo "   - Infrastructure Enumeration (Low-Medium)"
echo "   - API Misconfiguration (Medium)"
echo ""
echo "📊 Dados Reais Vazados:"
echo "   - Metadados da plataforma"
echo "   - Infraestrutura interna"
echo "   - Estrutura da aplicação"
echo ""
echo "💰 Valor Estimado: $200 - $5,000"
echo "🎯 CVSS Score: 5.3 (Medium)"
echo ""

# Instruções para envio
echo "📤 INSTRUÇÕES PARA ENVIO:"
echo "========================="
echo ""
echo "1. Acesse: https://hackerone.com/crypto_com"
echo "2. Clique em 'Submit Report'"
echo "3. Selecione a severidade: Medium"
echo "4. Cole o conteúdo do relatório"
echo "5. Anexe screenshots se necessário"
echo "6. Envie o report"
echo ""

# Opção para abrir o relatório
echo "📖 OPÇÕES:"
echo "=========="
echo ""
echo "1. Abrir relatório no editor:"
echo "   open relatorio_dados_reais_vazados.md"
echo ""
echo "2. Copiar conteúdo para clipboard:"
echo "   cat relatorio_dados_reais_vazados.md | pbcopy"
echo ""
echo "3. Ver conteúdo completo:"
echo "   cat relatorio_dados_reais_vazados.md"
echo ""

# Perguntar qual ação executar
echo "🎯 Qual ação deseja executar?"
echo "1) Abrir relatório no editor"
echo "2) Copiar para clipboard"
echo "3) Ver conteúdo completo"
echo "4) Sair"
echo ""
read -p "Digite sua escolha (1-4): " choice

case $choice in
    1)
        echo "📖 Abrindo relatório no editor..."
        open relatorio_dados_reais_vazados.md
        ;;
    2)
        echo "📋 Copiando conteúdo para clipboard..."
        cat relatorio_dados_reais_vazados.md | pbcopy
        echo "✅ Conteúdo copiado! Cole no HackerOne."
        ;;
    3)
        echo "📄 Mostrando conteúdo completo:"
        echo "================================"
        cat relatorio_dados_reais_vazados.md
        ;;
    4)
        echo "👋 Saindo..."
        exit 0
        ;;
    *)
        echo "❌ Opção inválida!"
        exit 1
        ;;
esac

echo ""
echo "🎉 Processo concluído!"
echo "📤 Agora envie o relatório para HackerOne!"
echo "🔐 Lembre-se: Programa legal e autorizado!"
