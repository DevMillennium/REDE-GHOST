#!/usr/bin/env python3
"""
🎯 Machine Learning Analyzer - Crypto.com Vulnerabilities (Versão Final Robusta)
Sistema de IA para análise automática de vulnerabilidades e padrões
"""

import json
import pandas as pd
import numpy as np
from datetime import datetime
import os
import glob
from sklearn.ensemble import RandomForestClassifier, IsolationForest
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler
import matplotlib.pyplot as plt
import warnings
warnings.filterwarnings('ignore')

class CryptoVulnerabilityML:
    def __init__(self):
        self.data_dir = "HACKERONE_CRYPTO_COM_EXTREME_BOUNTY"
        self.results_dir = "ml_analysis_results"
        self.models = {}
        self.scaler = StandardScaler()
        
        # Criar diretório de resultados
        os.makedirs(self.results_dir, exist_ok=True)
        
        print("🤖 Iniciando Machine Learning Analyzer - Crypto.com Vulnerabilities (Versão Final)")
        print("=" * 70)
    
    def load_data(self):
        """Carrega todos os dados extraídos"""
        print("📊 Carregando dados extraídos...")
        
        data = {
            'api_responses': [],
            'endpoints': [],
            'metadata': []
        }
        
        # Carregar dados da API pública
        api_files = glob.glob(f"{self.data_dir}/04_DADOS/API_PUBLICA/*.json")
        for file in api_files:
            try:
                with open(file, 'r', encoding='utf-8') as f:
                    content = json.load(f)
                    data['api_responses'].append({
                        'file': file,
                        'content': content,
                        'size': len(str(content)),
                        'type': 'api_public'
                    })
            except Exception as e:
                print(f"⚠️ Erro ao carregar {file}: {e}")
        
        # Carregar logs de status
        status_files = glob.glob(f"{self.data_dir}/02_EVIDENCIAS/*/status_*.txt")
        for file in status_files:
            try:
                with open(file, 'r', encoding='utf-8') as f:
                    content = f.read()
                    data['metadata'].append({
                        'file': file,
                        'content': content,
                        'type': 'status_log'
                    })
            except Exception as e:
                print(f"⚠️ Erro ao carregar {file}: {e}")
        
        print(f"✅ Dados carregados: {len(data['api_responses'])} APIs, {len(data['metadata'])} logs")
        return data
    
    def extract_features(self, data):
        """Extrai features dos dados para análise ML"""
        print("🔍 Extraindo features para análise...")
        
        features = []
        
        # Features de APIs públicas
        for api in data['api_responses']:
            if isinstance(api['content'], dict):
                feature = {
                    'type': 'api_public',
                    'size': api['size'],
                    'has_result': 1 if 'result' in api['content'] else 0,
                    'has_data': 1 if 'data' in api['content'] else 0,
                    'data_length': len(api['content'].get('result', {}).get('data', [])) if 'result' in api['content'] else 0,
                    'response_keys': len(api['content'].keys()),
                    'is_vulnerable': 1 if api['size'] > 1000 else 0
                }
                features.append(feature)
        
        # Features de logs de status
        for log in data['metadata']:
            content = log['content']
            feature = {
                'type': 'status_log',
                'size': len(content),
                'has_200': 1 if '200' in content else 0,
                'has_404': 1 if '404' in content else 0,
                'has_301': 1 if '301' in content else 0,
                'has_error': 1 if 'error' in content.lower() else 0,
                'response_time': self.extract_response_time(content),
                'is_vulnerable': 1 if '200' in content and 'error' not in content.lower() else 0
            }
            features.append(feature)
        
        print(f"✅ Features extraídas: {len(features)} registros")
        return pd.DataFrame(features)
    
    def extract_response_time(self, content):
        """Extrai tempo de resposta do log"""
        try:
            lines = content.split('\n')
            for line in lines:
                if 'Response Time:' in line:
                    time_str = line.split(':')[1].strip().replace('s', '')
                    return float(time_str)
        except:
            pass
        return 0.0
    
    def clean_features(self, features_df):
        """Limpa e prepara features para ML"""
        print("🧹 Limpando e preparando features...")
        
        # Substituir valores infinitos por 0
        features_df = features_df.replace([np.inf, -np.inf], 0)
        
        # Preencher valores NaN com 0
        features_df = features_df.fillna(0)
        
        # Garantir que todas as colunas numéricas sejam float
        numeric_columns = features_df.select_dtypes(include=[np.number]).columns
        for col in numeric_columns:
            features_df[col] = pd.to_numeric(features_df[col], errors='coerce').fillna(0)
        
        print(f"✅ Features limpas: {len(features_df)} registros, {len(features_df.columns)} colunas")
        return features_df
    
    def train_anomaly_detection(self, features_df):
        """Treina modelo de detecção de anomalias"""
        print("🎯 Treinando modelo de detecção de anomalias...")
        
        # Preparar dados numéricos
        numeric_features = features_df.select_dtypes(include=[np.number])
        
        if len(numeric_features) > 0 and len(numeric_features.columns) > 0:
            # Remover colunas com apenas zeros
            non_zero_cols = numeric_features.columns[numeric_features.sum() > 0]
            if len(non_zero_cols) > 0:
                numeric_features = numeric_features[non_zero_cols]
                
                # Normalizar dados
                scaled_features = self.scaler.fit_transform(numeric_features)
                
                # Treinar Isolation Forest
                iso_forest = IsolationForest(contamination=0.1, random_state=42)
                iso_forest.fit(scaled_features)
                
                # Prever anomalias
                predictions = iso_forest.predict(scaled_features)
                anomaly_scores = iso_forest.decision_function(scaled_features)
                
                # Adicionar resultados ao DataFrame
                features_df['anomaly_score'] = anomaly_scores
                features_df['is_anomaly'] = predictions == -1
                
                self.models['anomaly_detection'] = iso_forest
                
                print(f"✅ Anomalias detectadas: {sum(features_df['is_anomaly'])}")
            else:
                print("⚠️ Nenhuma feature numérica válida encontrada para detecção de anomalias")
        
        return features_df
    
    def train_vulnerability_classifier(self, features_df):
        """Treina classificador de vulnerabilidades"""
        print("🎯 Treinando classificador de vulnerabilidades...")
        
        # Preparar dados para classificação
        if 'is_vulnerable' in features_df.columns:
            # Selecionar features numéricas
            X = features_df.select_dtypes(include=[np.number])
            
            # Remover colunas de resultado
            exclude_cols = ['is_vulnerable', 'anomaly_score', 'is_anomaly']
            X = X.drop([col for col in exclude_cols if col in X.columns], axis=1)
            
            y = features_df['is_vulnerable']
            
            if len(X) > 0 and len(X.columns) > 0:
                # Garantir que não há NaN
                X = X.fillna(0)
                
                # Treinar Random Forest
                rf_classifier = RandomForestClassifier(n_estimators=100, random_state=42)
                rf_classifier.fit(X, y)
                
                # Prever vulnerabilidades
                predictions = rf_classifier.predict(X)
                probabilities = rf_classifier.predict_proba(X)
                
                # Adicionar resultados
                features_df['vulnerability_probability'] = probabilities[:, 1]
                features_df['predicted_vulnerable'] = predictions
                
                self.models['vulnerability_classifier'] = rf_classifier
                
                # Calcular importância das features
                feature_importance = pd.DataFrame({
                    'feature': X.columns,
                    'importance': rf_classifier.feature_importances_
                }).sort_values('importance', ascending=False)
                
                print(f"✅ Vulnerabilidades previstas: {sum(predictions)}")
                print("📊 Features mais importantes:")
                print(feature_importance.head())
            else:
                print("⚠️ Dados insuficientes para treinar classificador")
        
        return features_df
    
    def cluster_analysis(self, features_df):
        """Análise de clusters para identificar padrões"""
        print("🎯 Realizando análise de clusters...")
        
        # Preparar dados para clustering
        numeric_features = features_df.select_dtypes(include=[np.number])
        
        # Remover colunas de resultado
        exclude_cols = ['is_vulnerable', 'anomaly_score', 'is_anomaly', 'vulnerability_probability', 'predicted_vulnerable']
        numeric_features = numeric_features.drop([col for col in exclude_cols if col in numeric_features.columns], axis=1)
        
        if len(numeric_features) > 1 and len(numeric_features.columns) > 1:
            # Garantir que não há NaN
            numeric_features = numeric_features.fillna(0)
            
            # Remover colunas com apenas zeros
            non_zero_cols = numeric_features.columns[numeric_features.sum() > 0]
            if len(non_zero_cols) > 1:
                numeric_features = numeric_features[non_zero_cols]
                
                # Normalizar dados
                scaled_features = self.scaler.fit_transform(numeric_features)
                
                # Aplicar K-means
                n_clusters = min(3, len(scaled_features))
                kmeans = KMeans(n_clusters=n_clusters, random_state=42)
                cluster_labels = kmeans.fit_predict(scaled_features)
                
                # Adicionar clusters ao DataFrame
                features_df['cluster'] = cluster_labels
                
                self.models['clustering'] = kmeans
                
                print(f"✅ Clusters identificados: {len(set(cluster_labels))}")
            else:
                print("⚠️ Dados insuficientes para clustering")
        else:
            print("⚠️ Dados insuficientes para clustering")
        
        return features_df
    
    def analyze_financial_data(self, data):
        """Análise específica de dados financeiros"""
        print("💰 Analisando dados financeiros...")
        
        financial_insights = {
            'total_pairs': 0,
            'total_volume': 0,
            'high_value_pairs': [],
            'vulnerable_endpoints': [],
            'risk_score': 0
        }
        
        # Analisar dados da API pública
        for api in data['api_responses']:
            if isinstance(api['content'], dict) and 'result' in api['content']:
                result = api['content']['result']
                if 'data' in result and isinstance(result['data'], list):
                    financial_insights['total_pairs'] = len(result['data'])
                    
                    # Analisar cada par
                    for pair in result['data']:
                        if isinstance(pair, dict):
                            # Extrair volume
                            volume = float(pair.get('vv', 0))
                            financial_insights['total_volume'] += volume
                            
                            # Identificar pares de alto valor
                            if volume > 1000000:  # $1M+
                                financial_insights['high_value_pairs'].append({
                                    'pair': pair.get('i', 'Unknown'),
                                    'volume': volume,
                                    'price': pair.get('a', 0)
                                })
        
        # Calcular score de risco
        risk_factors = [
            financial_insights['total_pairs'] > 100,
            financial_insights['total_volume'] > 1000000000,  # $1B+
            len(financial_insights['high_value_pairs']) > 10
        ]
        financial_insights['risk_score'] = sum(risk_factors) / len(risk_factors) * 100
        
        print(f"✅ Análise financeira: {financial_insights['total_pairs']} pares, ${financial_insights['total_volume']:,.0f} volume")
        print(f"🎯 Score de risco: {financial_insights['risk_score']:.1f}%")
        
        return financial_insights
    
    def generate_ml_report(self, features_df, financial_insights):
        """Gera relatório de análise de ML"""
        print("📄 Gerando relatório de Machine Learning...")
        
        report = {
            'timestamp': datetime.now().isoformat(),
            'summary': {
                'total_records': len(features_df),
                'vulnerabilities_detected': sum(features_df.get('is_vulnerable', [0])),
                'anomalies_detected': sum(features_df.get('is_anomaly', [0])),
                'clusters_identified': len(set(features_df.get('cluster', [0]))) if 'cluster' in features_df.columns else 0,
                'risk_score': financial_insights['risk_score']
            },
            'vulnerability_analysis': {
                'high_risk_endpoints': features_df[features_df.get('vulnerability_probability', 0) > 0.7].to_dict('records') if 'vulnerability_probability' in features_df.columns else [],
                'anomalous_patterns': features_df[features_df.get('is_anomaly', False)].to_dict('records') if 'is_anomaly' in features_df.columns else []
            },
            'financial_analysis': financial_insights,
            'recommendations': self.generate_recommendations(features_df, financial_insights)
        }
        
        # Salvar relatório
        report_file = f"{self.results_dir}/ml_analysis_report.json"
        with open(report_file, 'w', encoding='utf-8') as f:
            json.dump(report, f, indent=2, ensure_ascii=False)
        
        # Gerar relatório em Markdown
        self.generate_markdown_report(report, features_df)
        
        print(f"✅ Relatório salvo: {report_file}")
        return report
    
    def generate_recommendations(self, features_df, financial_insights):
        """Gera recomendações baseadas na análise"""
        recommendations = []
        
        # Recomendações baseadas em vulnerabilidades
        vuln_count = sum(features_df.get('is_vulnerable', [0]))
        if vuln_count > 0:
            recommendations.append({
                'type': 'security',
                'priority': 'high',
                'description': f'Identificadas {vuln_count} vulnerabilidades potenciais que requerem investigação imediata'
            })
        
        # Recomendações baseadas em anomalias
        anomaly_count = sum(features_df.get('is_anomaly', [0]))
        if anomaly_count > 0:
            recommendations.append({
                'type': 'monitoring',
                'priority': 'medium',
                'description': f'Detectados {anomaly_count} padrões anômalos que merecem atenção'
            })
        
        # Recomendações baseadas em dados financeiros
        if financial_insights['risk_score'] > 70:
            recommendations.append({
                'type': 'financial',
                'priority': 'high',
                'description': f'Alto risco financeiro detectado (Score: {financial_insights["risk_score"]:.1f}%) - Priorizar análise'
            })
        
        # Recomendações gerais
        recommendations.append({
            'type': 'general',
            'priority': 'medium',
            'description': 'Implementar monitoramento contínuo dos endpoints identificados'
        })
        
        return recommendations
    
    def generate_markdown_report(self, report, features_df):
        """Gera relatório em formato Markdown"""
        md_file = f"{self.results_dir}/ml_analysis_report.md"
        
        with open(md_file, 'w', encoding='utf-8') as f:
            f.write("# 🤖 Relatório de Machine Learning - Análise Crypto.com (Versão Final)\n\n")
            f.write(f"**Data:** {report['timestamp']}\n")
            f.write(f"**Pesquisador:** Thyago Aguiar\n")
            f.write(f"**Alvo:** Crypto.com Exchange API\n\n")
            
            f.write("## 📊 Resumo Executivo\n\n")
            f.write(f"- **Total de registros analisados:** {report['summary']['total_records']}\n")
            f.write(f"- **Vulnerabilidades detectadas:** {report['summary']['vulnerabilities_detected']}\n")
            f.write(f"- **Anomalias identificadas:** {report['summary']['anomalies_detected']}\n")
            f.write(f"- **Clusters encontrados:** {report['summary']['clusters_identified']}\n")
            f.write(f"- **Score de risco:** {report['summary']['risk_score']:.1f}%\n\n")
            
            f.write("## 🎯 Análise de Vulnerabilidades\n\n")
            high_risk = report['vulnerability_analysis']['high_risk_endpoints']
            if high_risk:
                f.write("### Endpoints de Alto Risco:\n\n")
                for endpoint in high_risk[:5]:  # Top 5
                    f.write(f"- **{endpoint.get('file', 'Unknown')}**\n")
                    f.write(f"  - Probabilidade: {endpoint.get('vulnerability_probability', 0):.2%}\n")
                    f.write(f"  - Tamanho: {endpoint.get('size', 0)} bytes\n\n")
            
            f.write("## 💰 Análise Financeira\n\n")
            f.write(f"- **Total de pares:** {report['financial_analysis']['total_pairs']}\n")
            f.write(f"- **Volume total:** ${report['financial_analysis']['total_volume']:,.0f}\n")
            f.write(f"- **Pares de alto valor:** {len(report['financial_analysis']['high_value_pairs'])}\n\n")
            
            f.write("## 🚨 Recomendações\n\n")
            for rec in report['recommendations']:
                f.write(f"### {rec['type'].title()} ({rec['priority']})\n")
                f.write(f"{rec['description']}\n\n")
            
            f.write("## 📈 Métricas de ML\n\n")
            f.write("### Distribuição de Features:\n")
            f.write(features_df.describe().to_markdown())
            
            f.write("\n\n---\n")
            f.write("*Relatório gerado automaticamente pelo Machine Learning Analyzer (Versão Final)*")
        
        print(f"✅ Relatório Markdown salvo: {md_file}")
    
    def create_visualizations(self, features_df):
        """Cria visualizações dos dados"""
        print("📊 Criando visualizações...")
        
        try:
            # Configurar estilo
            plt.style.use('default')
            fig, axes = plt.subplots(2, 2, figsize=(15, 12))
            
            # 1. Distribuição de vulnerabilidades
            if 'is_vulnerable' in features_df.columns:
                vuln_counts = features_df['is_vulnerable'].value_counts()
                axes[0, 0].pie(vuln_counts.values, labels=['Seguro', 'Vulnerável'], autopct='%1.1f%%')
                axes[0, 0].set_title('Distribuição de Vulnerabilidades')
            
            # 2. Distribuição de anomalias
            if 'is_anomaly' in features_df.columns:
                anomaly_counts = features_df['is_anomaly'].value_counts()
                axes[0, 1].bar(anomaly_counts.index, anomaly_counts.values)
                axes[0, 1].set_title('Detecção de Anomalias')
                axes[0, 1].set_xticks([0, 1])
                axes[0, 1].set_xticklabels(['Normal', 'Anômalo'])
            
            # 3. Distribuição de clusters
            if 'cluster' in features_df.columns:
                cluster_counts = features_df['cluster'].value_counts()
                axes[1, 0].bar(range(len(cluster_counts)), cluster_counts.values)
                axes[1, 0].set_title('Distribuição de Clusters')
                axes[1, 0].set_xlabel('Cluster')
                axes[1, 0].set_ylabel('Quantidade')
            
            # 4. Score de vulnerabilidade
            if 'vulnerability_probability' in features_df.columns:
                axes[1, 1].hist(features_df['vulnerability_probability'], bins=20, alpha=0.7)
                axes[1, 1].set_title('Distribuição de Probabilidade de Vulnerabilidade')
                axes[1, 1].set_xlabel('Probabilidade')
                axes[1, 1].set_ylabel('Frequência')
            
            plt.tight_layout()
            plt.savefig(f"{self.results_dir}/ml_analysis_visualizations.png", dpi=300, bbox_inches='tight')
            plt.close()
            
            print(f"✅ Visualizações salvas: {self.results_dir}/ml_analysis_visualizations.png")
            
        except Exception as e:
            print(f"⚠️ Erro ao criar visualizações: {e}")
    
    def run_analysis(self):
        """Executa análise completa de ML"""
        print("🚀 Iniciando análise completa de Machine Learning...")
        
        # 1. Carregar dados
        data = self.load_data()
        
        # 2. Extrair features
        features_df = self.extract_features(data)
        
        if len(features_df) == 0:
            print("❌ Nenhum dado válido encontrado para análise")
            return
        
        # 3. Limpar features
        features_df = self.clean_features(features_df)
        
        # 4. Treinar modelos
        features_df = self.train_anomaly_detection(features_df)
        features_df = self.train_vulnerability_classifier(features_df)
        features_df = self.cluster_analysis(features_df)
        
        # 5. Análise financeira
        financial_insights = self.analyze_financial_data(data)
        
        # 6. Gerar relatórios
        report = self.generate_ml_report(features_df, financial_insights)
        
        # 7. Criar visualizações
        self.create_visualizations(features_df)
        
        # 8. Salvar dados processados
        features_df.to_csv(f"{self.results_dir}/processed_features.csv", index=False)
        
        print("\n" + "=" * 70)
        print("✅ ANÁLISE DE MACHINE LEARNING CONCLUÍDA!")
        print("=" * 70)
        print(f"📁 Resultados salvos em: {self.results_dir}")
        print(f"📊 Vulnerabilidades detectadas: {report['summary']['vulnerabilities_detected']}")
        print(f"🎯 Score de risco: {report['summary']['risk_score']:.1f}%")
        print(f"🤖 Modelos treinados: {len(self.models)}")
        print("=" * 70)

def main():
    """Função principal"""
    analyzer = CryptoVulnerabilityML()
    analyzer.run_analysis()

if __name__ == "__main__":
    main()
