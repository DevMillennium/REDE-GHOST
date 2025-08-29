#!/usr/bin/env python3
"""
Sistema de Machine Learning para Otimização de Bug Hunting
Autor: Assistente AI
Versão: 1.0
"""

import os
import sys
import json
import time
import subprocess
import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report
import requests
from bs4 import BeautifulSoup
import logging
from datetime import datetime
import threading
from concurrent.futures import ThreadPoolExecutor, as_completed

# Configuração de logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('ml_bug_hunter.log'),
        logging.StreamHandler()
    ]
)

class MLBugHunter:
    def __init__(self):
        self.model = None
        self.features = []
        self.targets = []
        self.data_file = 'bug_hunting_data.json'
        self.model_file = 'bug_hunting_model.pkl'
        self.load_data()
        
    def load_data(self):
        """Carrega dados históricos de bug hunting"""
        if os.path.exists(self.data_file):
            with open(self.data_file, 'r') as f:
                data = json.load(f)
                self.features = data.get('features', [])
                self.targets = data.get('targets', [])
                logging.info(f"Carregados {len(self.features)} registros históricos")
    
    def save_data(self):
        """Salva dados para treinamento futuro"""
        data = {
            'features': self.features,
            'targets': self.targets,
            'timestamp': datetime.now().isoformat()
        }
        with open(self.data_file, 'w') as f:
            json.dump(data, f, indent=2)
    
    def extract_features(self, target_url):
        """Extrai características do alvo para ML"""
        features = {
            'url_length': len(target_url),
            'has_https': 1 if 'https' in target_url else 0,
            'has_api': 1 if '/api' in target_url else 0,
            'has_admin': 1 if 'admin' in target_url else 0,
            'has_login': 1 if 'login' in target_url else 0,
            'subdomain_count': len(target_url.split('.')) - 1,
            'path_depth': len([x for x in target_url.split('/') if x]) - 1,
            'has_parameters': 1 if '?' in target_url else 0,
            'has_js': 0,  # Será atualizado
            'has_forms': 0,  # Será atualizado
            'response_time': 0,  # Será atualizado
            'status_code': 0,  # Será atualizado
        }
        
        try:
            start_time = time.time()
            response = requests.get(target_url, timeout=10)
            features['response_time'] = time.time() - start_time
            features['status_code'] = response.status_code
            
            if response.status_code == 200:
                soup = BeautifulSoup(response.text, 'html.parser')
                features['has_js'] = 1 if soup.find_all('script') else 0
                features['has_forms'] = 1 if soup.find_all('form') else 0
                
        except Exception as e:
            logging.warning(f"Erro ao analisar {target_url}: {e}")
        
        return features
    
    def run_subfinder(self, domain):
        """Executa subfinder com otimização"""
        try:
            cmd = f"subfinder -d {domain} -silent"
            result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
            subdomains = result.stdout.strip().split('\n')
            return [s for s in subdomains if s]
        except Exception as e:
            logging.error(f"Erro no subfinder: {e}")
            return []
    
    def run_httpx(self, urls):
        """Executa httpx em paralelo"""
        def check_url(url):
            try:
                cmd = f"httpx -u {url} -silent -status-code -title -tech-detect"
                result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
                return result.stdout.strip()
            except Exception as e:
                return None
        
        with ThreadPoolExecutor(max_workers=10) as executor:
            futures = [executor.submit(check_url, url) for url in urls]
            results = []
            for future in as_completed(futures):
                result = future.result()
                if result:
                    results.append(result)
        
        return results
    
    def run_nuclei(self, urls):
        """Executa nuclei com templates otimizados"""
        try:
            urls_str = '\n'.join(urls)
            cmd = f"echo '{urls_str}' | nuclei -t nuclei-templates -severity medium,high,critical -silent -json"
            result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
            return result.stdout.strip()
        except Exception as e:
            logging.error(f"Erro no nuclei: {e}")
            return ""
    
    def predict_vulnerability_score(self, features):
        """Prediz score de vulnerabilidade usando ML"""
        if self.model is None:
            return 0.5  # Score padrão se não há modelo treinado
        
        try:
            feature_vector = np.array([list(features.values())])
            score = self.model.predict_proba(feature_vector)[0][1]
            return score
        except Exception as e:
            logging.error(f"Erro na predição: {e}")
            return 0.5
    
    def train_model(self):
        """Treina o modelo de ML"""
        if len(self.features) < 10:
            logging.warning("Dados insuficientes para treinar modelo")
            return
        
        try:
            X = pd.DataFrame(self.features)
            y = np.array(self.targets)
            
            X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
            
            self.model = RandomForestClassifier(n_estimators=100, random_state=42)
            self.model.fit(X_train, y_train)
            
            y_pred = self.model.predict(X_test)
            logging.info("Relatório de Classificação:")
            logging.info(classification_report(y_test, y_pred))
            
            # Salvar modelo
            import pickle
            with open(self.model_file, 'wb') as f:
                pickle.dump(self.model, f)
            
            logging.info("Modelo treinado e salvo com sucesso")
            
        except Exception as e:
            logging.error(f"Erro no treinamento: {e}")
    
    def optimize_scan_strategy(self, domain):
        """Otimiza estratégia de scan baseada em ML"""
        logging.info(f"🔍 Iniciando scan otimizado para: {domain}")
        
        # 1. Reconhecimento com subfinder
        logging.info("📡 Executando reconhecimento de subdomínios...")
        subdomains = self.run_subfinder(domain)
        logging.info(f"Encontrados {len(subdomains)} subdomínios")
        
        # 2. Verificação de URLs ativas
        logging.info("🌐 Verificando URLs ativas...")
        active_urls = self.run_httpx(subdomains)
        logging.info(f"Encontradas {len(active_urls)} URLs ativas")
        
        # 3. Análise de características e predição
        logging.info("🤖 Analisando características com ML...")
        prioritized_urls = []
        
        for url in active_urls[:50]:  # Limitar para performance
            features = self.extract_features(url)
            vulnerability_score = self.predict_vulnerability_score(features)
            
            prioritized_urls.append({
                'url': url,
                'features': features,
                'vulnerability_score': vulnerability_score
            })
        
        # 4. Ordenar por score de vulnerabilidade
        prioritized_urls.sort(key=lambda x: x['vulnerability_score'], reverse=True)
        
        # 5. Scan com nuclei nos mais promissores
        logging.info("🎯 Executando scan de vulnerabilidades...")
        top_urls = [item['url'] for item in prioritized_urls[:20]]
        vulnerabilities = self.run_nuclei(top_urls)
        
        # 6. Salvar dados para treinamento futuro
        for item in prioritized_urls:
            self.features.append(item['features'])
            # Simular target baseado em vulnerabilidades encontradas
            self.targets.append(1 if item['vulnerability_score'] > 0.7 else 0)
        
        self.save_data()
        
        return {
            'domain': domain,
            'subdomains_found': len(subdomains),
            'active_urls': len(active_urls),
            'prioritized_urls': prioritized_urls[:10],
            'vulnerabilities_found': vulnerabilities
        }
    
    def run_parallel_scans(self, domains):
        """Executa scans em paralelo"""
        with ThreadPoolExecutor(max_workers=3) as executor:
            futures = [executor.submit(self.optimize_scan_strategy, domain) for domain in domains]
            results = []
            for future in as_completed(futures):
                result = future.result()
                results.append(result)
        return results

def main():
    """Função principal"""
    if len(sys.argv) < 2 or "--help" in sys.argv or "-h" in sys.argv:
        print("🤖 Sistema de Machine Learning para Bug Hunting")
        print("=" * 50)
        print("Uso: python ml_bug_hunter.py <domínio> [domínio2] [domínio3]...")
        print("Exemplo: python ml_bug_hunter.py exemplo.com")
        print("")
        print("Funcionalidades:")
        print("  - Reconhecimento automatizado de subdomínios")
        print("  - Análise de características com ML")
        print("  - Predição de vulnerabilidades")
        print("  - Scan otimizado baseado em ML")
        print("  - Execução paralela para múltiplos domínios")
        print("")
        print("Arquivos gerados:")
        print("  - bug_hunting_data.json: Dados para treinamento")
        print("  - bug_hunting_model.pkl: Modelo treinado")
        print("  - ml_bug_hunter.log: Logs de execução")
        sys.exit(0)
    
    hunter = MLBugHunter()
    
    # Treinar modelo se há dados suficientes
    if len(hunter.features) >= 10:
        logging.info("🤖 Treinando modelo de ML...")
        hunter.train_model()
    
    domains = sys.argv[1:]
    
    if len(domains) == 1:
        # Scan único
        result = hunter.optimize_scan_strategy(domains[0])
        print(json.dumps(result, indent=2))
    else:
        # Scan paralelo
        results = hunter.run_parallel_scans(domains)
        for result in results:
            print(f"\n=== Resultados para {result['domain']} ===")
            print(json.dumps(result, indent=2))

if __name__ == "__main__":
    main()
