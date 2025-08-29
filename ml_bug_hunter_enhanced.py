#!/usr/bin/env python3
"""
Sistema de Machine Learning Avançado para Bug Hunting com Aprendizado Contínuo
Autor: Assistente AI
Versão: 2.0 - Enhanced
"""

import os
import sys
import json
import time
import subprocess
import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.metrics import classification_report, confusion_matrix
from sklearn.preprocessing import StandardScaler
import requests
from bs4 import BeautifulSoup
import logging
from datetime import datetime
import threading
from concurrent.futures import ThreadPoolExecutor, as_completed
import pickle
import joblib

# Configuração de logging avançada
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('ml_bug_hunter_enhanced.log'),
        logging.StreamHandler()
    ]
)

class EnhancedMLBugHunter:
    def __init__(self):
        self.model = None
        self.scaler = StandardScaler()
        self.features = []
        self.targets = []
        self.data_file = 'enhanced_bug_hunting_data.json'
        self.model_file = 'enhanced_bug_hunting_model.pkl'
        self.scaler_file = 'enhanced_bug_hunting_scaler.pkl'
        self.results_history = []
        self.load_data()
        
    def load_data(self):
        """Carrega dados históricos de bug hunting"""
        if os.path.exists(self.data_file):
            with open(self.data_file, 'r') as f:
                data = json.load(f)
                self.features = data.get('features', [])
                self.targets = data.get('targets', [])
                self.results_history = data.get('results_history', [])
                logging.info(f"Carregados {len(self.features)} registros históricos")
    
    def save_data(self):
        """Salva dados para treinamento futuro"""
        data = {
            'features': self.features,
            'targets': self.targets,
            'results_history': self.results_history,
            'timestamp': datetime.now().isoformat()
        }
        with open(self.data_file, 'w') as f:
            json.dump(data, f, indent=2)
    
    def extract_enhanced_features(self, target_url, scan_results=None):
        """Extrai características avançadas do alvo para ML"""
        features = {
            'url_length': len(target_url),
            'has_https': 1 if 'https' in target_url else 0,
            'has_api': 1 if '/api' in target_url else 0,
            'has_admin': 1 if 'admin' in target_url else 0,
            'has_login': 1 if 'login' in target_url else 0,
            'subdomain_count': len(target_url.split('.')) - 1,
            'path_depth': len([x for x in target_url.split('/') if x]) - 1,
            'has_parameters': 1 if '?' in target_url else 0,
            'has_corp': 1 if 'corp' in target_url else 0,
            'has_internal': 1 if 'internal' in target_url else 0,
            'has_dev': 1 if 'dev' in target_url else 0,
            'has_staging': 1 if 'staging' in target_url else 0,
            'has_test': 1 if 'test' in target_url else 0,
            'has_github': 1 if 'github' in target_url else 0,
            'has_jenkins': 1 if 'jenkins' in target_url else 0,
            'has_grafana': 1 if 'grafana' in target_url else 0,
            'has_kibana': 1 if 'kibana' in target_url else 0,
            'has_mysql': 1 if 'mysql' in target_url else 0,
            'has_cassandra': 1 if 'cassandra' in target_url else 0,
            'has_js': 0,
            'has_forms': 0,
            'response_time': 0,
            'status_code': 0,
            'content_length': 0,
            'has_cloudfront': 0,
            'has_aws': 0,
            'has_azure': 0,
            'has_google_cloud': 0,
            'vulnerability_score': 0.0
        }
        
        try:
            start_time = time.time()
            response = requests.get(target_url, timeout=10)
            features['response_time'] = time.time() - start_time
            features['status_code'] = response.status_code
            features['content_length'] = len(response.content)
            
            # Detectar tecnologias
            headers = response.headers
            features['has_cloudfront'] = 1 if 'cloudfront' in str(headers).lower() else 0
            features['has_aws'] = 1 if 'aws' in str(headers).lower() else 0
            features['has_azure'] = 1 if 'azure' in str(headers).lower() else 0
            features['has_google_cloud'] = 1 if 'google' in str(headers).lower() else 0
            
            if response.status_code == 200:
                soup = BeautifulSoup(response.text, 'html.parser')
                features['has_js'] = 1 if soup.find_all('script') else 0
                features['has_forms'] = 1 if soup.find_all('form') else 0
                
        except Exception as e:
            logging.warning(f"Erro ao analisar {target_url}: {e}")
        
        # Calcular score de vulnerabilidade baseado em características
        vulnerability_score = 0.0
        
        # Subdomínios corporativos são mais vulneráveis
        if features['has_corp'] or features['has_internal']:
            vulnerability_score += 0.3
        
        # Sistemas de desenvolvimento são mais vulneráveis
        if features['has_dev'] or features['has_staging'] or features['has_test']:
            vulnerability_score += 0.2
        
        # Sistemas críticos são mais vulneráveis
        if features['has_github'] or features['has_jenkins'] or features['has_grafana']:
            vulnerability_score += 0.25
        
        # Bancos de dados são muito vulneráveis
        if features['has_mysql'] or features['has_cassandra']:
            vulnerability_score += 0.4
        
        # APIs são vulneráveis
        if features['has_api']:
            vulnerability_score += 0.15
        
        features['vulnerability_score'] = min(vulnerability_score, 1.0)
        
        return features
    
    def analyze_scan_results(self, scan_results_file):
        """Analisa resultados de scan para aprendizado"""
        if not os.path.exists(scan_results_file):
            return []
        
        try:
            with open(scan_results_file, 'r') as f:
                content = f.read()
            
            # Extrair URLs e status codes dos resultados
            results = []
            lines = content.split('\n')
            
            for line in lines:
                if 'Alvo:' in line and 'Tipo:' in line:
                    parts = line.split(' - ')
                    if len(parts) >= 2:
                        url = parts[0].replace('Alvo: ', '').strip()
                        scan_type = parts[1].replace('Tipo: ', '').strip()
                        
                        # Procurar por resultados JSON na linha seguinte
                        results.append({
                            'url': url,
                            'scan_type': scan_type,
                            'found_endpoints': [],
                            'status_codes': []
                        })
            
            return results
            
        except Exception as e:
            logging.error(f"Erro ao analisar resultados: {e}")
            return []
    
    def learn_from_results(self, scan_results):
        """Aprende com os resultados de scan"""
        for result in scan_results:
            url = result['url']
            scan_type = result['scan_type']
            
            # Extrair características da URL
            features = self.extract_enhanced_features(url)
            
            # Determinar se encontrou algo interessante
            target = 1 if result['found_endpoints'] else 0
            
            # Adicionar aos dados de treinamento
            self.features.append(list(features.values()))
            self.targets.append(target)
            
            # Adicionar ao histórico
            self.results_history.append({
                'url': url,
                'scan_type': scan_type,
                'features': features,
                'target': target,
                'timestamp': datetime.now().isoformat()
            })
        
        # Salvar dados atualizados
        self.save_data()
        
        # Retreinar modelo se temos dados suficientes
        if len(self.features) >= 10:
            self.train_model()
    
    def train_model(self):
        """Treina o modelo com dados atualizados"""
        if len(self.features) < 5:
            logging.warning("Dados insuficientes para treinar modelo")
            return
        
        try:
            X = np.array(self.features)
            y = np.array(self.targets)
            
            # Normalizar features
            X_scaled = self.scaler.fit_transform(X)
            
            # Dividir dados
            X_train, X_test, y_train, y_test = train_test_split(
                X_scaled, y, test_size=0.2, random_state=42
            )
            
            # Treinar modelo
            self.model = GradientBoostingClassifier(
                n_estimators=100,
                learning_rate=0.1,
                max_depth=5,
                random_state=42
            )
            
            self.model.fit(X_train, y_train)
            
            # Avaliar modelo
            train_score = self.model.score(X_train, y_train)
            test_score = self.model.score(X_test, y_test)
            
            logging.info(f"Modelo treinado - Train Score: {train_score:.3f}, Test Score: {test_score:.3f}")
            
            # Salvar modelo
            joblib.dump(self.model, self.model_file)
            joblib.dump(self.scaler, self.scaler_file)
            
        except Exception as e:
            logging.error(f"Erro ao treinar modelo: {e}")
    
    def predict_vulnerability(self, target_url):
        """Prediz vulnerabilidade de um alvo"""
        if self.model is None:
            logging.warning("Modelo não treinado")
            return 0.5
        
        try:
            features = self.extract_enhanced_features(target_url)
            X = np.array([list(features.values())])
            X_scaled = self.scaler.transform(X)
            
            prediction = self.model.predict_proba(X_scaled)[0]
            return prediction[1]  # Probabilidade de ser vulnerável
            
        except Exception as e:
            logging.error(f"Erro na predição: {e}")
            return 0.5
    
    def generate_enhanced_report(self, domain, scan_results_file):
        """Gera relatório avançado com insights de ML"""
        logging.info(f"🔍 Iniciando análise avançada para: {domain}")
        
        # Analisar resultados de scan
        scan_results = self.analyze_scan_results(scan_results_file)
        
        # Aprender com os resultados
        self.learn_from_results(scan_results)
        
        # Gerar insights
        insights = {
            'domain': domain,
            'total_targets': len(scan_results),
            'vulnerable_targets': sum(1 for r in scan_results if r['found_endpoints']),
            'scan_types': list(set(r['scan_type'] for r in scan_results)),
            'ml_predictions': [],
            'recommendations': []
        }
        
        # Predições de ML para cada alvo
        for result in scan_results:
            prediction = self.predict_vulnerability(result['url'])
            insights['ml_predictions'].append({
                'url': result['url'],
                'predicted_vulnerability': prediction,
                'confidence': 'high' if prediction > 0.7 else 'medium' if prediction > 0.4 else 'low'
            })
        
        # Gerar recomendações
        high_risk_targets = [p for p in insights['ml_predictions'] if p['predicted_vulnerability'] > 0.7]
        if high_risk_targets:
            insights['recommendations'].append(f"Priorizar {len(high_risk_targets)} alvos de alto risco")
        
        # Salvar relatório
        report_file = f"enhanced_report_{domain}_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        with open(report_file, 'w') as f:
            json.dump(insights, f, indent=2)
        
        logging.info(f"📊 Relatório avançado salvo em: {report_file}")
        return insights

def main():
    """Função principal"""
    if len(sys.argv) != 2:
        print("Uso: python3 ml_bug_hunter_enhanced.py <dominio>")
        sys.exit(1)
    
    domain = sys.argv[1]
    hunter = EnhancedMLBugHunter()
    
    # Analisar resultados existentes
    scan_results_file = "resultados_renda_real.txt"
    if os.path.exists(scan_results_file):
        insights = hunter.generate_enhanced_report(domain, scan_results_file)
        print(f"✅ Análise avançada concluída para {domain}")
        print(f"🎯 Alvos de alto risco identificados: {len([p for p in insights['ml_predictions'] if p['predicted_vulnerability'] > 0.7])}")
    else:
        print(f"❌ Arquivo de resultados não encontrado: {scan_results_file}")

if __name__ == "__main__":
    main()
