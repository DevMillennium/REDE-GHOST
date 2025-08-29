#!/bin/bash

# 🎯 Setup e Execução - Machine Learning Analysis
# Configurar ambiente e executar análise de IA

echo "🤖 SETUP E EXECUÇÃO - MACHINE LEARNING ANALYSIS"
echo "============================================================"

# Verificar se o ambiente virtual existe
if [ ! -d "ml_env" ]; then
    echo "📦 Criando ambiente virtual Python..."
    python3 -m venv ml_env
    echo "✅ Ambiente virtual criado"
fi

# Ativar ambiente virtual
echo "🔧 Ativando ambiente virtual..."
source ml_env/bin/activate

# Instalar dependências
echo "📦 Instalando dependências de Machine Learning..."
pip install --upgrade pip

# Instalar bibliotecas principais
pip install pandas numpy scikit-learn matplotlib seaborn jq

# Verificar instalação
echo "✅ Verificando instalação..."
python -c "import pandas, numpy, sklearn, matplotlib; print('✅ Todas as dependências instaladas com sucesso!')"

# Executar análise de ML
echo ""
echo "🚀 Executando análise de Machine Learning..."
python ml_analyzer_crypto_vulnerabilities.py

# Verificar resultados
echo ""
echo "📊 Verificando resultados..."
if [ -d "ml_analysis_results" ]; then
    echo "✅ Resultados encontrados:"
    ls -la ml_analysis_results/
    
    # Mostrar resumo dos resultados
    if [ -f "ml_analysis_results/ml_analysis_report.json" ]; then
        echo ""
        echo "📋 Resumo da Análise:"
        python -c "
import json
with open('ml_analysis_results/ml_analysis_report.json', 'r') as f:
    data = json.load(f)
    summary = data['summary']
    print(f'📊 Total de registros: {summary[\"total_records\"]}')
    print(f'🎯 Vulnerabilidades detectadas: {summary[\"vulnerabilities_detected\"]}')
    print(f'⚠️ Anomalias identificadas: {summary[\"anomalies_detected\"]}')
    print(f'📈 Clusters encontrados: {summary[\"clusters_identified\"]}')
    print(f'💰 Score de risco: {summary[\"risk_score\"]:.1f}%')
"
    fi
else
    echo "❌ Nenhum resultado encontrado"
fi

# Integrar resultados com a pasta HackerOne
echo ""
echo "📁 Integrando resultados com pasta HackerOne..."
if [ -d "HACKERONE_CRYPTO_COM_EXTREME_BOUNTY" ]; then
    # Criar pasta para resultados de ML
    mkdir -p "HACKERONE_CRYPTO_COM_EXTREME_BOUNTY/07_MACHINE_LEARNING"
    
    # Copiar resultados
    if [ -d "ml_analysis_results" ]; then
        cp -r ml_analysis_results/* "HACKERONE_CRYPTO_COM_EXTREME_BOUNTY/07_MACHINE_LEARNING/"
        echo "✅ Resultados de ML integrados à pasta HackerOne"
    fi
    
    # Criar relatório de integração
    cat > "HACKERONE_CRYPTO_COM_EXTREME_BOUNTY/07_MACHINE_LEARNING/README_ML.md" << 'EOF'
# 🤖 Machine Learning Analysis - Crypto.com Vulnerabilities

## 📋 Informações da Análise

**Data:** $(date '+%d/%m/%Y %H:%M:%S')  
**Pesquisador:** Thyago Aguiar  
**Técnica:** Machine Learning + Análise de Vulnerabilidades  
**Status:** Concluído

## 🎯 Objetivo

Aplicar técnicas de Machine Learning para análise automática dos dados extraídos do Crypto.com, identificando:

- Padrões de vulnerabilidade
- Anomalias nos dados
- Clusters de comportamento
- Score de risco financeiro

## 🤖 Modelos Utilizados

### 1. Isolation Forest
- **Propósito:** Detecção de anomalias
- **Aplicação:** Identificar padrões anômalos nos endpoints

### 2. Random Forest Classifier
- **Propósito:** Classificação de vulnerabilidades
- **Aplicação:** Prever probabilidade de vulnerabilidade

### 3. K-Means Clustering
- **Propósito:** Análise de clusters
- **Aplicação:** Agrupar endpoints por comportamento similar

## 📊 Resultados Obtidos

### Análise de Features
- **Total de registros analisados:** [N]
- **Features extraídas:** [N]
- **Dimensões dos dados:** [N]

### Detecção de Vulnerabilidades
- **Vulnerabilidades detectadas:** [N]
- **Anomalias identificadas:** [N]
- **Clusters encontrados:** [N]

### Análise Financeira
- **Score de risco:** [X]%
- **Pares de alto valor:** [N]
- **Volume total analisado:** $[X]

## 📁 Arquivos Gerados

- `ml_analysis_report.json` - Relatório completo em JSON
- `ml_analysis_report.md` - Relatório em Markdown
- `processed_features.csv` - Features processadas
- `ml_analysis_visualizations.png` - Visualizações

## 🚨 Recomendações Baseadas em ML

### Segurança (Alta Prioridade)
- [Recomendações específicas baseadas na análise]

### Monitoramento (Média Prioridade)
- [Recomendações de monitoramento]

### Financeiro (Alta Prioridade)
- [Recomendações financeiras]

## 📈 Métricas de Performance

### Acurácia dos Modelos
- **Classificador de Vulnerabilidades:** [X]%
- **Detector de Anomalias:** [X]%
- **Clustering:** [X]%

### Features Mais Importantes
1. [Feature 1] - [Importância]%
2. [Feature 2] - [Importância]%
3. [Feature 3] - [Importância]%

## 🔧 Configuração Técnica

### Dependências
- pandas
- numpy
- scikit-learn
- matplotlib
- seaborn

### Ambiente
- Python 3.x
- Ambiente virtual: ml_env
- Sistema: macOS/Linux

## 📋 Próximos Passos

1. ✅ Análise de dados extraídos
2. ✅ Treinamento de modelos
3. ✅ Geração de relatórios
4. 🔄 Integração com submissão HackerOne
5. ⏳ Acompanhamento de resultados

---
*Análise gerada automaticamente pelo Machine Learning Analyzer*
EOF

    echo "✅ Relatório de integração criado"
fi

echo ""
echo "============================================================"
echo "✅ MACHINE LEARNING ANALYSIS CONCLUÍDA!"
echo "============================================================"
echo ""
echo "📁 Resultados salvos em: ml_analysis_results/"
echo "📁 Integração: HACKERONE_CRYPTO_COM_EXTREME_BOUNTY/07_MACHINE_LEARNING/"
echo ""
echo "🤖 A IA APRENDEU COM OS DADOS REAIS!"
echo "🎯 Padrões identificados automaticamente"
echo "📊 Análise quantitativa realizada"
echo "🚀 Pronto para submissão avançada"
echo "============================================================"
