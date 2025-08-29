#!/usr/bin/env python3
"""
🎯 Machine Learning Analyzer - Dados Reais Completos Crypto.com
Análise completa de todos os dados reais coletados
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
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt
import seaborn as sns
import warnings
warnings.filterwarnings('ignore')

class CompleteCryptoMLAnalyzer:
    def __init__(self):
        self.data_dir = "data/20250829T093234Z"
        self.results_dir = "ml_analysis_complete"
        self.models = {}
        self.scaler = StandardScaler()
        
        # Criar diretório de resultados
        os.makedirs(self.results_dir, exist_ok=True)
        
        print("🤖 Iniciando Machine Learning Analyzer - Dados Reais Completos")
        print("=" * 70)
    
    def load_all_data(self):
        """Carrega todos os dados reais coletados"""
        print("📊 Carregando dados reais completos...")
        
        data = {
            'books': [],
            'tickers': [],
            'trades': [],
            'candles': [],
            'valuations': [],
            'meta': []
        }
        
        # Carregar order books
        book_files = glob.glob(f"{self.data_dir}/books/*.json")
        print(f"📚 Carregando {len(book_files)} order books...")
        for file in book_files:
            try:
                with open(file, 'r', encoding='utf-8') as f:
                    content = json.load(f)
                    if 'result' in content and 'data' in content['result']:
                        data['books'].append({
                            'file': file,
                            'instrument': content['result'].get('instrument_name', 'Unknown'),
                            'data': content['result']['data'],
                            'depth': content['result'].get('depth', 0)
                        })
            except Exception as e:
                print(f"⚠️ Erro ao carregar {file}: {e}")
        
        # Carregar tickers
        ticker_file = f"{self.data_dir}/tickers/all.json"
        if os.path.exists(ticker_file):
            try:
                with open(ticker_file, 'r', encoding='utf-8') as f:
                    content = json.load(f)
                    if 'result' in content and 'data' in content['result']:
                        data['tickers'] = content['result']['data']
                        print(f"📈 Carregados {len(data['tickers'])} tickers")
            except Exception as e:
                print(f"⚠️ Erro ao carregar tickers: {e}")
        
        # Carregar trades
        trade_files = glob.glob(f"{self.data_dir}/trades/*.json")
        print(f"💱 Carregando {len(trade_files)} arquivos de trades...")
        for file in trade_files:
            try:
                with open(file, 'r', encoding='utf-8') as f:
                    content = json.load(f)
                    if 'result' in content and 'data' in content['result']:
                        data['trades'].append({
                            'file': file,
                            'instrument': content['result'].get('instrument_name', 'Unknown'),
                            'data': content['result']['data']
                        })
            except Exception as e:
                print(f"⚠️ Erro ao carregar {file}: {e}")
        
        # Carregar candles
        candle_files = glob.glob(f"{self.data_dir}/candles/*.json")
        print(f"🕯️ Carregando {len(candle_files)} arquivos de candles...")
        for file in candle_files:
            try:
                with open(file, 'r', encoding='utf-8') as f:
                    content = json.load(f)
                    if 'result' in content and 'data' in content['result']:
                        data['candles'].append({
                            'file': file,
                            'instrument': content['result'].get('instrument_name', 'Unknown'),
                            'timeframe': content['result'].get('timeframe', 'Unknown'),
                            'data': content['result']['data']
                        })
            except Exception as e:
                print(f"⚠️ Erro ao carregar {file}: {e}")
        
        # Carregar valuations
        valuation_files = glob.glob(f"{self.data_dir}/valuations/*.json")
        print(f"💰 Carregando {len(valuation_files)} arquivos de valuations...")
        for file in valuation_files:
            try:
                with open(file, 'r', encoding='utf-8') as f:
                    content = json.load(f)
                    if 'result' in content and 'data' in content['result']:
                        data['valuations'].append({
                            'file': file,
                            'instrument': content['result'].get('instrument_name', 'Unknown'),
                            'type': content['result'].get('valuation_type', 'Unknown'),
                            'data': content['result']['data']
                        })
            except Exception as e:
                print(f"⚠️ Erro ao carregar {file}: {e}")
        
        print(f"✅ Dados carregados: {len(data['books'])} books, {len(data['tickers'])} tickers, {len(data['trades'])} trades, {len(data['candles'])} candles, {len(data['valuations'])} valuations")
        return data
    
    def extract_comprehensive_features(self, data):
        """Extrai features abrangentes de todos os dados"""
        print("🔍 Extraindo features abrangentes...")
        
        features = []
        
        # Features dos order books
        for book in data['books']:
            if book['data'] and len(book['data']) > 0:
                book_data = book['data'][0]
                bids = book_data.get('bids', [])
                asks = book_data.get('asks', [])
                
                if bids and asks:
                    # Calcular métricas do order book
                    bid_prices = [float(bid[0]) for bid in bids]
                    bid_sizes = [float(bid[1]) for bid in bids]
                    ask_prices = [float(ask[0]) for ask in asks]
                    ask_sizes = [float(ask[1]) for ask in asks]
                    
                    feature = {
                        'type': 'order_book',
                        'instrument': book['instrument'],
                        'bid_count': len(bids),
                        'ask_count': len(asks),
                        'bid_volume': sum(bid_sizes),
                        'ask_volume': sum(ask_sizes),
                        'bid_price_avg': np.mean(bid_prices),
                        'ask_price_avg': np.mean(ask_prices),
                        'spread': np.mean(ask_prices) - np.mean(bid_prices),
                        'spread_pct': ((np.mean(ask_prices) - np.mean(bid_prices)) / np.mean(bid_prices)) * 100,
                        'bid_price_std': np.std(bid_prices),
                        'ask_price_std': np.std(ask_prices),
                        'depth': book['depth'],
                        'is_vulnerable': 1 if abs(np.mean(ask_prices) - np.mean(bid_prices)) > 100 else 0
                    }
                    features.append(feature)
        
        # Features dos tickers
        for ticker in data['tickers']:
            try:
                feature = {
                    'type': 'ticker',
                    'instrument': ticker.get('i', 'Unknown'),
                    'high': float(ticker.get('h', 0)),
                    'low': float(ticker.get('l', 0)),
                    'avg': float(ticker.get('a', 0)),
                    'volume': float(ticker.get('v', 0)),
                    'volume_usd': float(ticker.get('vv', 0)),
                    'change_pct': float(ticker.get('c', 0)),
                    'bid': float(ticker.get('b', 0)),
                    'ask': float(ticker.get('k', 0)),
                    'open_interest': float(ticker.get('oi', 0)) if ticker.get('oi') else 0,
                    'volatility': abs(float(ticker.get('h', 0)) - float(ticker.get('l', 0))) / float(ticker.get('a', 1)),
                    'is_vulnerable': 1 if float(ticker.get('vv', 0)) > 1000000 else 0  # Volume alto
                }
                features.append(feature)
            except Exception as e:
                continue
        
        # Features dos trades
        for trade in data['trades']:
            if trade['data'] and len(trade['data']) > 0:
                trade_data = trade['data']
                prices = [float(t.get('p', 0)) for t in trade_data if t.get('p')]
                sizes = [float(t.get('s', 0)) for t in trade_data if t.get('s')]
                
                if prices and sizes:
                    feature = {
                        'type': 'trade',
                        'instrument': trade['instrument'],
                        'trade_count': len(trade_data),
                        'avg_price': np.mean(prices),
                        'total_volume': sum(sizes),
                        'price_volatility': np.std(prices),
                        'size_volatility': np.std(sizes),
                        'max_price': max(prices),
                        'min_price': min(prices),
                        'is_vulnerable': 1 if np.std(prices) > np.mean(prices) * 0.1 else 0
                    }
                    features.append(feature)
        
        print(f"✅ Features extraídas: {len(features)} registros")
        return pd.DataFrame(features)
    
    def analyze_financial_impact(self, data):
        """Análise detalhada do impacto financeiro"""
        print("💰 Analisando impacto financeiro...")
        
        financial_analysis = {
            'total_instruments': len(data['tickers']),
            'total_volume_usd': 0,
            'high_volume_pairs': [],
            'volatile_pairs': [],
            'risk_metrics': {},
            'market_structure': {}
        }
        
        # Análise de volume
        volumes = []
        for ticker in data['tickers']:
            try:
                volume_usd = float(ticker.get('vv', 0))
                volumes.append(volume_usd)
                financial_analysis['total_volume_usd'] += volume_usd
                
                if volume_usd > 1000000:  # $1M+
                    financial_analysis['high_volume_pairs'].append({
                        'instrument': ticker.get('i', 'Unknown'),
                        'volume': volume_usd,
                        'price': float(ticker.get('a', 0))
                    })
                
                # Análise de volatilidade
                high = float(ticker.get('h', 0))
                low = float(ticker.get('l', 0))
                avg = float(ticker.get('a', 0))
                volatility = abs(high - low) / avg if avg > 0 else 0
                
                if volatility > 0.1:  # 10%+ volatilidade
                    financial_analysis['volatile_pairs'].append({
                        'instrument': ticker.get('i', 'Unknown'),
                        'volatility': volatility,
                        'volume': volume_usd
                    })
            except:
                continue
        
        # Métricas de risco
        if volumes:
            financial_analysis['risk_metrics'] = {
                'avg_volume': np.mean(volumes),
                'median_volume': np.median(volumes),
                'volume_std': np.std(volumes),
                'max_volume': max(volumes),
                'min_volume': min(volumes),
                'volume_percentiles': {
                    '25': np.percentile(volumes, 25),
                    '50': np.percentile(volumes, 50),
                    '75': np.percentile(volumes, 75),
                    '95': np.percentile(volumes, 95)
                }
            }
        
        # Estrutura de mercado
        instrument_types = {}
        for ticker in data['tickers']:
            instrument = ticker.get('i', 'Unknown')
            if 'USD' in instrument:
                if 'PERP' in instrument:
                    instrument_types['PERP'] = instrument_types.get('PERP', 0) + 1
                elif 'USDT' in instrument:
                    instrument_types['USDT'] = instrument_types.get('USDT', 0) + 1
                else:
                    instrument_types['USD'] = instrument_types.get('USD', 0) + 1
        
        financial_analysis['market_structure'] = instrument_types
        
        print(f"✅ Análise financeira: ${financial_analysis['total_volume_usd']:,.0f} volume total")
        print(f"📊 {len(financial_analysis['high_volume_pairs'])} pares de alto volume")
        print(f"📈 {len(financial_analysis['volatile_pairs'])} pares voláteis")
        
        return financial_analysis
    
    def train_advanced_models(self, features_df):
        """Treina modelos avançados de ML"""
        print("🎯 Treinando modelos avançados...")
        
        # Preparar dados
        numeric_features = features_df.select_dtypes(include=[np.number])
        numeric_features = numeric_features.fillna(0)
        
        # Remover colunas com apenas zeros
        non_zero_cols = numeric_features.columns[numeric_features.sum() > 0]
        if len(non_zero_cols) > 0:
            numeric_features = numeric_features[non_zero_cols]
            
            # Normalizar dados
            scaled_features = self.scaler.fit_transform(numeric_features)
            
            # 1. Detecção de Anomalias Avançada
            print("🔍 Treinando detector de anomalias avançado...")
            iso_forest = IsolationForest(contamination=0.05, random_state=42)
            iso_forest.fit(scaled_features)
            
            anomaly_scores = iso_forest.decision_function(scaled_features)
            anomaly_predictions = iso_forest.predict(scaled_features)
            
            features_df['anomaly_score'] = anomaly_scores
            features_df['is_anomaly'] = anomaly_predictions == -1
            
            self.models['anomaly_detection'] = iso_forest
            
            # 2. Clustering Avançado
            print("🎯 Treinando clustering avançado...")
            n_clusters = min(5, len(scaled_features) // 10)
            if n_clusters > 1:
                kmeans = KMeans(n_clusters=n_clusters, random_state=42)
                cluster_labels = kmeans.fit_predict(scaled_features)
                features_df['cluster'] = cluster_labels
                self.models['clustering'] = kmeans
            
            # 3. PCA para Redução de Dimensões
            print("📊 Aplicando PCA...")
            if len(scaled_features) > 1 and len(scaled_features[0]) > 1:
                pca = PCA(n_components=min(3, len(scaled_features[0])))
                pca_features = pca.fit_transform(scaled_features)
                
                features_df['pca_1'] = pca_features[:, 0] if len(pca_features[0]) > 0 else 0
                features_df['pca_2'] = pca_features[:, 1] if len(pca_features[0]) > 1 else 0
                features_df['pca_3'] = pca_features[:, 2] if len(pca_features[0]) > 2 else 0
                
                self.models['pca'] = pca
                
                print(f"📈 Variância explicada: {sum(pca.explained_variance_ratio_):.2%}")
            
            # 4. Classificador de Vulnerabilidades
            if 'is_vulnerable' in features_df.columns:
                print("🛡️ Treinando classificador de vulnerabilidades...")
                X = numeric_features
                y = features_df['is_vulnerable']
                
                rf_classifier = RandomForestClassifier(n_estimators=200, random_state=42)
                rf_classifier.fit(X, y)
                
                predictions = rf_classifier.predict(X)
                probabilities = rf_classifier.predict_proba(X)
                
                features_df['vulnerability_probability'] = probabilities[:, 1]
                features_df['predicted_vulnerable'] = predictions
                
                self.models['vulnerability_classifier'] = rf_classifier
                
                # Feature importance
                feature_importance = pd.DataFrame({
                    'feature': X.columns,
                    'importance': rf_classifier.feature_importances_
                }).sort_values('importance', ascending=False)
                
                print("📊 Features mais importantes:")
                print(feature_importance.head())
        
        return features_df
    
    def generate_comprehensive_report(self, features_df, financial_analysis):
        """Gera relatório abrangente"""
        print("📄 Gerando relatório abrangente...")
        
        report = {
            'timestamp': datetime.now().isoformat(),
            'data_summary': {
                'total_features': len(features_df),
                'vulnerabilities_detected': sum(features_df.get('is_vulnerable', [0])),
                'anomalies_detected': sum(features_df.get('is_anomaly', [0])),
                'clusters_identified': len(set(features_df.get('cluster', [0]))) if 'cluster' in features_df.columns else 0,
                'models_trained': len(self.models)
            },
            'financial_analysis': financial_analysis,
            'ml_insights': {
                'high_risk_instruments': features_df[features_df.get('vulnerability_probability', 0) > 0.8].to_dict('records') if 'vulnerability_probability' in features_df.columns else [],
                'anomalous_patterns': features_df[features_df.get('is_anomaly', False)].to_dict('records') if 'is_anomaly' in features_df.columns else [],
                'cluster_analysis': self.analyze_clusters(features_df)
            },
            'recommendations': self.generate_advanced_recommendations(features_df, financial_analysis)
        }
        
        # Salvar relatório
        report_file = f"{self.results_dir}/comprehensive_ml_report.json"
        with open(report_file, 'w', encoding='utf-8') as f:
            json.dump(report, f, indent=2, ensure_ascii=False)
        
        # Gerar relatório Markdown
        self.generate_markdown_report(report, features_df)
        
        print(f"✅ Relatório salvo: {report_file}")
        return report
    
    def analyze_clusters(self, features_df):
        """Análise detalhada dos clusters"""
        if 'cluster' not in features_df.columns:
            return {}
        
        cluster_analysis = {}
        for cluster_id in features_df['cluster'].unique():
            cluster_data = features_df[features_df['cluster'] == cluster_id]
            
            cluster_analysis[f'cluster_{cluster_id}'] = {
                'size': len(cluster_data),
                'vulnerability_rate': sum(cluster_data.get('is_vulnerable', [0])) / len(cluster_data) if len(cluster_data) > 0 else 0,
                'anomaly_rate': sum(cluster_data.get('is_anomaly', [0])) / len(cluster_data) if len(cluster_data) > 0 else 0,
                'avg_volume': cluster_data.get('volume_usd', [0]).mean() if 'volume_usd' in cluster_data.columns else 0,
                'instruments': cluster_data['instrument'].unique().tolist()[:10]  # Top 10
            }
        
        return cluster_analysis
    
    def generate_advanced_recommendations(self, features_df, financial_analysis):
        """Gera recomendações avançadas"""
        recommendations = []
        
        # Baseadas em vulnerabilidades
        vuln_count = sum(features_df.get('is_vulnerable', [0]))
        if vuln_count > 0:
            recommendations.append({
                'type': 'security',
                'priority': 'critical',
                'description': f'Identificadas {vuln_count} vulnerabilidades críticas em instrumentos financeiros',
                'impact': 'Alto risco de manipulação de mercado'
            })
        
        # Baseadas em anomalias
        anomaly_count = sum(features_df.get('is_anomaly', [0]))
        if anomaly_count > 0:
            recommendations.append({
                'type': 'monitoring',
                'priority': 'high',
                'description': f'Detectados {anomaly_count} padrões anômalos que indicam comportamento suspeito',
                'impact': 'Possível manipulação ou falha de sistema'
            })
        
        # Baseadas em volume
        if financial_analysis['total_volume_usd'] > 1000000000:  # $1B+
            recommendations.append({
                'type': 'financial',
                'priority': 'critical',
                'description': f'Volume total de ${financial_analysis["total_volume_usd"]:,.0f} representa risco sistêmico',
                'impact': 'Exposição financeira massiva'
            })
        
        # Baseadas em volatilidade
        if len(financial_analysis['volatile_pairs']) > 50:
            recommendations.append({
                'type': 'market',
                'priority': 'high',
                'description': f'{len(financial_analysis["volatile_pairs"])} pares com alta volatilidade',
                'impact': 'Instabilidade de mercado significativa'
            })
        
        return recommendations
    
    def generate_markdown_report(self, report, features_df):
        """Gera relatório em Markdown"""
        md_file = f"{self.results_dir}/comprehensive_ml_report.md"
        
        with open(md_file, 'w', encoding='utf-8') as f:
            f.write("# 🤖 Relatório Abrangente - Machine Learning Crypto.com\n\n")
            f.write(f"**Data:** {report['timestamp']}\n")
            f.write(f"**Pesquisador:** Thyago Aguiar\n")
            f.write(f"**Alvo:** Crypto.com Exchange (Dados Reais Completos)\n\n")
            
            f.write("## 📊 Resumo Executivo\n\n")
            f.write(f"- **Total de features analisadas:** {report['data_summary']['total_features']}\n")
            f.write(f"- **Vulnerabilidades detectadas:** {report['data_summary']['vulnerabilities_detected']}\n")
            f.write(f"- **Anomalias identificadas:** {report['data_summary']['anomalies_detected']}\n")
            f.write(f"- **Clusters encontrados:** {report['data_summary']['clusters_identified']}\n")
            f.write(f"- **Modelos treinados:** {report['data_summary']['models_trained']}\n\n")
            
            f.write("## 💰 Análise Financeira Completa\n\n")
            f.write(f"- **Total de instrumentos:** {report['financial_analysis']['total_instruments']}\n")
            f.write(f"- **Volume total:** ${report['financial_analysis']['total_volume_usd']:,.0f}\n")
            f.write(f"- **Pares de alto volume:** {len(report['financial_analysis']['high_volume_pairs'])}\n")
            f.write(f"- **Pares voláteis:** {len(report['financial_analysis']['volatile_pairs'])}\n\n")
            
            f.write("## 🎯 Insights de Machine Learning\n\n")
            
            # High risk instruments
            high_risk = report['ml_insights']['high_risk_instruments']
            if high_risk:
                f.write("### Instrumentos de Alto Risco:\n\n")
                for instrument in high_risk[:10]:
                    f.write(f"- **{instrument.get('instrument', 'Unknown')}**\n")
                    f.write(f"  - Probabilidade: {instrument.get('vulnerability_probability', 0):.2%}\n")
                    f.write(f"  - Tipo: {instrument.get('type', 'Unknown')}\n\n")
            
            # Cluster analysis
            clusters = report['ml_insights']['cluster_analysis']
            if clusters:
                f.write("### Análise de Clusters:\n\n")
                for cluster_id, cluster_info in clusters.items():
                    f.write(f"- **{cluster_id}**\n")
                    f.write(f"  - Tamanho: {cluster_info['size']}\n")
                    f.write(f"  - Taxa de vulnerabilidade: {cluster_info['vulnerability_rate']:.2%}\n")
                    f.write(f"  - Taxa de anomalia: {cluster_info['anomaly_rate']:.2%}\n\n")
            
            f.write("## 🚨 Recomendações Críticas\n\n")
            for rec in report['recommendations']:
                f.write(f"### {rec['type'].title()} ({rec['priority']})\n")
                f.write(f"{rec['description']}\n")
                f.write(f"**Impacto:** {rec['impact']}\n\n")
            
            f.write("## 📈 Métricas Detalhadas\n\n")
            f.write("### Distribuição de Features:\n")
            f.write(features_df.describe().to_markdown())
            
            f.write("\n\n---\n")
            f.write("*Relatório gerado automaticamente pelo Machine Learning Analyzer Completo*")
        
        print(f"✅ Relatório Markdown salvo: {md_file}")
    
    def create_advanced_visualizations(self, features_df):
        """Cria visualizações avançadas"""
        print("📊 Criando visualizações avançadas...")
        
        try:
            plt.style.use('default')
            fig, axes = plt.subplots(3, 2, figsize=(20, 15))
            
            # 1. Distribuição de vulnerabilidades por tipo
            if 'type' in features_df.columns and 'is_vulnerable' in features_df.columns:
                vuln_by_type = features_df.groupby('type')['is_vulnerable'].sum()
                axes[0, 0].bar(vuln_by_type.index, vuln_by_type.values)
                axes[0, 0].set_title('Vulnerabilidades por Tipo de Dado')
                axes[0, 0].set_ylabel('Quantidade')
            
            # 2. Distribuição de anomalias
            if 'is_anomaly' in features_df.columns:
                anomaly_counts = features_df['is_anomaly'].value_counts()
                axes[0, 1].pie(anomaly_counts.values, labels=['Normal', 'Anômalo'], autopct='%1.1f%%')
                axes[0, 1].set_title('Distribuição de Anomalias')
            
            # 3. Distribuição de clusters
            if 'cluster' in features_df.columns:
                cluster_counts = features_df['cluster'].value_counts()
                axes[1, 0].bar(range(len(cluster_counts)), cluster_counts.values)
                axes[1, 0].set_title('Distribuição de Clusters')
                axes[1, 0].set_xlabel('Cluster')
                axes[1, 0].set_ylabel('Quantidade')
            
            # 4. Volume por instrumento (top 10)
            if 'volume_usd' in features_df.columns:
                top_volume = features_df.nlargest(10, 'volume_usd')
                axes[1, 1].barh(top_volume['instrument'], top_volume['volume_usd'])
                axes[1, 1].set_title('Top 10 Instrumentos por Volume')
                axes[1, 1].set_xlabel('Volume (USD)')
            
            # 5. Probabilidade de vulnerabilidade
            if 'vulnerability_probability' in features_df.columns:
                axes[2, 0].hist(features_df['vulnerability_probability'], bins=30, alpha=0.7)
                axes[2, 0].set_title('Distribuição de Probabilidade de Vulnerabilidade')
                axes[2, 0].set_xlabel('Probabilidade')
                axes[2, 0].set_ylabel('Frequência')
            
            # 6. Anomaly scores
            if 'anomaly_score' in features_df.columns:
                axes[2, 1].hist(features_df['anomaly_score'], bins=30, alpha=0.7)
                axes[2, 1].set_title('Distribuição de Anomaly Scores')
                axes[2, 1].set_xlabel('Score')
                axes[2, 1].set_ylabel('Frequência')
            
            plt.tight_layout()
            plt.savefig(f"{self.results_dir}/advanced_visualizations.png", dpi=300, bbox_inches='tight')
            plt.close()
            
            print(f"✅ Visualizações salvas: {self.results_dir}/advanced_visualizations.png")
            
        except Exception as e:
            print(f"⚠️ Erro ao criar visualizações: {e}")
    
    def run_complete_analysis(self):
        """Executa análise completa"""
        print("🚀 Iniciando análise completa de Machine Learning...")
        
        # 1. Carregar dados
        data = self.load_all_data()
        
        # 2. Extrair features
        features_df = self.extract_comprehensive_features(data)
        
        if len(features_df) == 0:
            print("❌ Nenhum dado válido encontrado para análise")
            return
        
        # 3. Análise financeira
        financial_analysis = self.analyze_financial_impact(data)
        
        # 4. Treinar modelos
        features_df = self.train_advanced_models(features_df)
        
        # 5. Gerar relatórios
        report = self.generate_comprehensive_report(features_df, financial_analysis)
        
        # 6. Criar visualizações
        self.create_advanced_visualizations(features_df)
        
        # 7. Salvar dados processados
        features_df.to_csv(f"{self.results_dir}/complete_features.csv", index=False)
        
        print("\n" + "=" * 70)
        print("✅ ANÁLISE COMPLETA DE MACHINE LEARNING CONCLUÍDA!")
        print("=" * 70)
        print(f"📁 Resultados salvos em: {self.results_dir}")
        print(f"📊 Features analisadas: {len(features_df)}")
        print(f"🎯 Vulnerabilidades detectadas: {report['data_summary']['vulnerabilities_detected']}")
        print(f"💰 Volume total: ${financial_analysis['total_volume_usd']:,.0f}")
        print(f"🤖 Modelos treinados: {len(self.models)}")
        print("=" * 70)

def main():
    """Função principal"""
    analyzer = CompleteCryptoMLAnalyzer()
    analyzer.run_complete_analysis()

if __name__ == "__main__":
    main()
