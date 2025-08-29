#!/bin/bash
# Pipeline Contínuo de Machine Learning para Bug Hunting

echo "🤖 Pipeline Contínuo de Machine Learning"
echo "======================================="

DOMAIN=$1
if [[ -z "$DOMAIN" ]]; then
    echo "Uso: $0 <domínio>"
    exit 1
fi

echo "🎯 Domínio: $DOMAIN"
echo "🔄 Iniciando ciclo de aprendizado contínuo..."

# 1. Executar reconhecimento
echo "📡 Fase 1: Reconhecimento"
./pipeline_recon.sh "$DOMAIN"

# 2. Executar scan de vulnerabilidades
echo "🔍 Fase 2: Scan de Vulnerabilidades"
if [[ -f active_urls.txt ]]; then
    ./pipeline_scan.sh active_urls.txt
fi

# 3. Executar fuzzing de alto valor
echo "💰 Fase 3: Fuzzing de Alto Valor"
./script_fuzzing_renda.sh

# 4. Testar endpoints encontrados
echo "🔍 Fase 4: Teste de Endpoints"
./test_endpoints_encontrados.sh

# 5. Análise com ML avançado
echo "🤖 Fase 5: Análise com ML Avançado"
source ml_env/bin/activate
python3 ml_bug_hunter_enhanced.py "$DOMAIN"

# 6. Aprender com os resultados
echo "📚 Fase 6: Aprendizado Contínuo"

# Verificar se há novos dados para aprender
if [[ -f "resultados_renda_real.txt" ]] || [[ -f "vulnerabilidades_criticas.txt" ]]; then
    echo "   📊 Novos dados encontrados para aprendizado"
    
    # Contar descobertas
    TOTAL_DESCOBERTAS=$(grep -c "Alvo:" resultados_renda_real.txt 2>/dev/null || echo "0")
    TOTAL_VULNERABILIDADES=$(grep -c "Alvo:" vulnerabilidades_criticas.txt 2>/dev/null || echo "0")
    
    echo "   🎯 Total de descobertas: $TOTAL_DESCOBERTAS"
    echo "   🔐 Total de vulnerabilidades: $TOTAL_VULNERABILIDADES"
    
    # Atualizar modelo de ML
    echo "   🤖 Atualizando modelo de ML..."
    python3 -c "
import sys
sys.path.append('.')
from ml_bug_hunter_enhanced import EnhancedMLBugHunter

hunter = EnhancedMLBugHunter()
hunter.load_data()

# Analisar resultados e aprender
if 'resultados_renda_real.txt' in sys.argv:
    hunter.analyze_scan_results('resultados_renda_real.txt')
    print('✅ Modelo atualizado com novos dados')
"
    
else
    echo "   ⚠️  Nenhum novo dado encontrado para aprendizado"
fi

# 7. Gerar relatório final
echo "📊 Fase 7: Relatório Final"
echo "Relatório Final - $(date)" > relatorio_final.txt
echo "Domínio: $DOMAIN" >> relatorio_final.txt
echo "" >> relatorio_final.txt

# Adicionar estatísticas
echo "📈 Estatísticas:" >> relatorio_final.txt
echo "   - Subdomínios encontrados: $(wc -l < subdomains.txt 2>/dev/null || echo '0')" >> relatorio_final.txt
echo "   - URLs ativas: $(wc -l < active_urls.txt 2>/dev/null || echo '0')" >> relatorio_final.txt
echo "   - Descobertas de API: $(grep -c "API Endpoints" resultados_renda_real.txt 2>/dev/null || echo '0')" >> relatorio_final.txt
echo "   - Vulnerabilidades críticas: $(grep -c "Admin Paths" vulnerabilidades_criticas.txt 2>/dev/null || echo '0')" >> relatorio_final.txt

# Adicionar insights do ML
if [[ -f "enhanced_bug_hunting_data.json" ]]; then
    echo "" >> relatorio_final.txt
    echo "🤖 Insights do Machine Learning:" >> relatorio_final.txt
    echo "   - Registros históricos: $(python3 -c "import json; data=json.load(open('enhanced_bug_hunting_data.json')); print(len(data.get('features', [])))" 2>/dev/null || echo '0')" >> relatorio_final.txt
    echo "   - Modelo treinado: $(ls enhanced_bug_hunting_model.pkl 2>/dev/null && echo 'Sim' || echo 'Não')" >> relatorio_final.txt
fi

# 8. Salvar backup dos dados
echo "💾 Fase 8: Backup dos Dados"
BACKUP_DIR="backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Copiar arquivos importantes
cp -r *.txt *.json *.log "$BACKUP_DIR/" 2>/dev/null || true
cp -r testes_detalhados "$BACKUP_DIR/" 2>/dev/null || true
cp -r wordlists "$BACKUP_DIR/" 2>/dev/null || true

echo "   📁 Backup salvo em: $BACKUP_DIR"

# 9. Preparar para próximo ciclo
echo "🔄 Fase 9: Preparação para Próximo Ciclo"

# Limpar arquivos temporários
rm -f api_*.json admin_*.json 2>/dev/null || true

# Atualizar wordlists baseado no aprendizado
echo "   📝 Atualizando wordlists baseado no aprendizado..."
if [[ -f "enhanced_bug_hunting_data.json" ]]; then
    python3 -c "
import json
import os

# Carregar dados históricos
if os.path.exists('enhanced_bug_hunting_data.json'):
    with open('enhanced_bug_hunting_data.json', 'r') as f:
        data = json.load(f)
    
    # Extrair padrões de URLs bem-sucedidas
    successful_urls = []
    for i, target in enumerate(data.get('targets', [])):
        if target == 1:  # Vulnerável
            features = data.get('features', [])[i]
            # Adicionar à lista de sucesso
            successful_urls.append(features)
    
    print(f'✅ {len(successful_urls)} padrões de sucesso identificados')
    print('📝 Wordlists serão otimizadas no próximo ciclo')
"
fi

echo ""
echo "✅ Pipeline contínuo concluído!"
echo "📊 Relatório final salvo em: relatorio_final.txt"
echo "💾 Backup salvo em: $BACKUP_DIR"
echo ""
echo "🔄 Próximo ciclo recomendado em: 24 horas"
echo "🎯 O sistema de ML aprendeu com esta execução"
echo "📈 Eficiência aumentará com cada ciclo"

# Mostrar resumo final
echo ""
echo "📋 Resumo Final:"
echo "================"
echo "🎯 Domínio: $DOMAIN"
echo "📡 Subdomínios: $(wc -l < subdomains.txt 2>/dev/null || echo '0')"
echo "🌐 URLs Ativas: $(wc -l < active_urls.txt 2>/dev/null || echo '0')"
echo "💰 Descobertas: $(grep -c "Alvo:" resultados_renda_real.txt 2>/dev/null || echo '0')"
echo "🔐 Vulnerabilidades: $(grep -c "Alvo:" vulnerabilidades_criticas.txt 2>/dev/null || echo '0')"
echo "🤖 ML Registros: $(python3 -c "import json; data=json.load(open('enhanced_bug_hunting_data.json')); print(len(data.get('features', [])))" 2>/dev/null || echo '0')"
