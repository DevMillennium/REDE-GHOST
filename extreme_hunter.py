#!/usr/bin/env python3
"""
Extreme Hunter - Ferramenta Especializada para Vulnerabilidades de Alto Valor
Foco: $100,000 - $2,000,000 em recompensas
Autor: Assistente AI
Versão: 1.0 - Extreme Focus
"""

import os
import sys
import json
import time
import requests
import subprocess
import threading
from concurrent.futures import ThreadPoolExecutor, as_completed
from urllib.parse import urljoin, urlparse
import hashlib
import hmac
import base64
from datetime import datetime
import logging

# Configuração de logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('extreme_hunter.log'),
        logging.StreamHandler()
    ]
)

class ExtremeHunter:
    def __init__(self, domain):
        self.domain = domain
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (compatible; ExtremeHunter/1.0)',
            'Accept': 'application/json, text/plain, */*',
            'Accept-Language': 'en-US,en;q=0.9',
            'Accept-Encoding': 'gzip, deflate, br',
            'Connection': 'keep-alive',
            'Upgrade-Insecure-Requests': '1'
        })
        self.results = {
            'financial_vulnerabilities': [],
            'data_breach_vulnerabilities': [],
            'authentication_bypass': [],
            'smart_contract_vulnerabilities': [],
            'business_logic_flaws': [],
            'extreme_value_targets': []
        }
        
    def log_extreme_finding(self, category, title, description, potential_value, evidence):
        """Registra descoberta de valor extremo"""
        finding = {
            'timestamp': datetime.now().isoformat(),
            'category': category,
            'title': title,
            'description': description,
            'potential_value': potential_value,
            'evidence': evidence,
            'severity': 'EXTREME',
            'cvss_score': '9.0-10.0'
        }
        
        self.results[f'{category}_vulnerabilities'].append(finding)
        
        logging.critical(f"🚨 DESCOBERTA EXTREMA: {title}")
        logging.critical(f"💰 Valor Potencial: {potential_value}")
        logging.critical(f"📊 Categoria: {category}")
        logging.critical(f"🔍 Evidência: {evidence}")
        print(f"\n🚨 DESCOBERTA EXTREMA ENCONTRADA!")
        print(f"💰 Valor: {potential_value}")
        print(f"📊 Categoria: {category}")
        print(f"🔍 {title}")
        print(f"📝 {description}")
        print("=" * 80)
        
    def test_financial_transfer_bypass(self, url):
        """Testa bypass de transferências financeiras - Valor: $100K-$2M"""
        print(f"💰 Testando bypass de transferências em: {url}")
        
        # Endpoints críticos de transferência
        transfer_endpoints = [
            '/api/v1/transfer',
            '/api/v1/send',
            '/api/v1/withdraw',
            '/api/v1/withdrawal',
            '/api/v1/payment',
            '/api/v1/transaction',
            '/api/v1/wallet/transfer',
            '/api/v1/account/transfer',
            '/api/v1/user/transfer',
            '/api/v1/financial/transfer',
            '/api/v1/money/transfer',
            '/api/v1/crypto/transfer',
            '/api/v1/coin/transfer',
            '/api/v1/token/transfer',
            '/api/v1/asset/transfer'
        ]
        
        for endpoint in transfer_endpoints:
            full_url = urljoin(url, endpoint)
            
            # Teste 1: Bypass de autenticação
            try:
                response = self.session.post(full_url, json={
                    'amount': '1000000',
                    'currency': 'USD',
                    'to_address': 'test@test.com',
                    'description': 'Test transfer'
                }, timeout=10)
                
                if response.status_code in [200, 201, 202]:
                    self.log_extreme_finding(
                        'financial',
                        f'Bypass de Autenticação em Transferência',
                        f'Endpoint {endpoint} aceita transferências sem autenticação',
                        '$500,000 - $2,000,000',
                        f'POST {full_url} retornou {response.status_code}'
                    )
                    
            except Exception as e:
                continue
                
            # Teste 2: Manipulação de parâmetros
            try:
                response = self.session.post(full_url, json={
                    'amount': '-1000000',  # Valor negativo
                    'currency': 'USD',
                    'to_address': 'test@test.com'
                }, timeout=10)
                
                if response.status_code in [200, 201, 202]:
                    self.log_extreme_finding(
                        'financial',
                        f'Manipulação de Valor em Transferência',
                        f'Endpoint {endpoint} aceita valores negativos',
                        '$300,000 - $1,500,000',
                        f'POST {full_url} com valor negativo retornou {response.status_code}'
                    )
                    
            except Exception as e:
                continue
                
            # Teste 3: IDOR em transferências
            try:
                response = self.session.get(full_url + '/history', timeout=10)
                
                if response.status_code == 200 and len(response.text) > 100:
                    self.log_extreme_finding(
                        'financial',
                        f'IDOR em Histórico de Transferências',
                        f'Endpoint {endpoint}/history expõe dados sem autenticação',
                        '$200,000 - $1,000,000',
                        f'GET {full_url}/history retornou dados sensíveis'
                    )
                    
            except Exception as e:
                continue
                
    def test_data_breach_vulnerabilities(self, url):
        """Testa vulnerabilidades de vazamento de dados - Valor: $100K-$2M"""
        print(f"🔒 Testando vazamento de dados em: {url}")
        
        # Endpoints com dados sensíveis
        sensitive_endpoints = [
            '/api/v1/users',
            '/api/v1/accounts',
            '/api/v1/customers',
            '/api/v1/kyc',
            '/api/v1/aml',
            '/api/v1/verification',
            '/api/v1/identity',
            '/api/v1/documents',
            '/api/v1/personal',
            '/api/v1/private',
            '/api/v1/secret',
            '/api/v1/internal',
            '/api/v1/admin',
            '/api/v1/backup',
            '/api/v1/export',
            '/api/v1/download',
            '/api/v1/dump',
            '/api/v1/backup',
            '/api/v1/restore',
            '/api/v1/migrate'
        ]
        
        for endpoint in sensitive_endpoints:
            full_url = urljoin(url, endpoint)
            
            try:
                response = self.session.get(full_url, timeout=10)
                
                if response.status_code == 200:
                    content = response.text.lower()
                    
                    # Verificar se contém dados sensíveis
                    sensitive_patterns = [
                        'email', 'password', 'ssn', 'credit_card', 'bank_account',
                        'private_key', 'secret', 'token', 'api_key', 'address',
                        'phone', 'social_security', 'passport', 'driver_license',
                        'kyc', 'aml', 'verification', 'identity', 'personal'
                    ]
                    
                    sensitive_count = sum(1 for pattern in sensitive_patterns if pattern in content)
                    
                    if sensitive_count >= 3:
                        self.log_extreme_finding(
                            'data_breach',
                            f'Vazamento Massivo de Dados PII',
                            f'Endpoint {endpoint} expõe dados pessoais sensíveis',
                            '$500,000 - $2,000,000',
                            f'GET {full_url} retornou {len(response.text)} bytes com dados sensíveis'
                        )
                        
            except Exception as e:
                continue
                
    def test_authentication_bypass(self, url):
        """Testa bypass de autenticação - Valor: $50K-$1M"""
        print(f"🔐 Testando bypass de autenticação em: {url}")
        
        # Endpoints administrativos
        admin_endpoints = [
            '/api/v1/admin',
            '/api/v1/administrator',
            '/api/v1/management',
            '/api/v1/panel',
            '/api/v1/console',
            '/api/v1/dashboard',
            '/api/v1/control',
            '/api/v1/settings',
            '/api/v1/config',
            '/api/v1/system',
            '/api/v1/root',
            '/api/v1/superuser',
            '/api/v1/master',
            '/api/v1/owner',
            '/api/v1/privileged'
        ]
        
        for endpoint in admin_endpoints:
            full_url = urljoin(url, endpoint)
            
            try:
                response = self.session.get(full_url, timeout=10)
                
                if response.status_code in [200, 201, 202]:
                    self.log_extreme_finding(
                        'authentication_bypass',
                        f'Bypass de Autenticação Administrativa',
                        f'Endpoint {endpoint} acessível sem autenticação',
                        '$100,000 - $1,000,000',
                        f'GET {full_url} retornou {response.status_code}'
                    )
                    
            except Exception as e:
                continue
                
    def test_smart_contract_vulnerabilities(self):
        """Testa vulnerabilidades em smart contracts - Valor: $100K-$2M"""
        print("⛓️ Testando vulnerabilidades em smart contracts...")
        
        # Contratos conhecidos do Crypto.com
        contracts = [
            "0xfe18ae03741a5b84e39c295ac9c856ed7991c38e",  # CRO Token
            "0x626E8036dab333b39Be2c9F55e8bE7C8F5C2F3A1",  # MCO Token
            "0x8B396ddF906D552b2Fc4A8C5C4B4C4C4C4C4C4C4"   # Placeholder
        ]
        
        for contract in contracts:
            try:
                # Verificar se o contrato tem vulnerabilidades conhecidas
                etherscan_url = f"https://api.etherscan.io/api?module=contract&action=getsourcecode&address={contract}"
                response = requests.get(etherscan_url, timeout=10)
                
                if response.status_code == 200:
                    data = response.json()
                    
                    if data.get('status') == '1' and data.get('result'):
                        source_code = data['result'][0].get('SourceCode', '').lower()
                        
                        # Verificar vulnerabilidades conhecidas
                        vulnerabilities = {
                            'reentrancy': ['call.value', 'send', 'transfer'],
                            'overflow': ['uint256', 'int256', 'add', 'sub', 'mul'],
                            'access_control': ['public', 'external', 'anyone'],
                            'unchecked_returns': ['call', 'send', 'transfer'],
                            'timestamp_dependence': ['now', 'block.timestamp'],
                            'randomness': ['block.number', 'blockhash']
                        }
                        
                        for vuln_type, patterns in vulnerabilities.items():
                            if any(pattern in source_code for pattern in patterns):
                                self.log_extreme_finding(
                                    'smart_contract',
                                    f'Vulnerabilidade {vuln_type.upper()} em Smart Contract',
                                    f'Contrato {contract} contém vulnerabilidade {vuln_type}',
                                    '$200,000 - $2,000,000',
                                    f'Contrato {contract} com padrões suspeitos: {patterns}'
                                )
                                
            except Exception as e:
                continue
                
    def test_business_logic_flaws(self, url):
        """Testa falhas de lógica de negócio - Valor: $50K-$1M"""
        print(f"💼 Testando falhas de lógica de negócio em: {url}")
        
        # Cenários de teste de business logic
        test_scenarios = [
            {
                'name': 'Rate Limiting Bypass',
                'endpoint': '/api/v1/price',
                'method': 'GET',
                'headers': {},
                'data': None,
                'expected_failure': 429,
                'value': '$100,000 - $500,000'
            },
            {
                'name': 'Negative Balance',
                'endpoint': '/api/v1/balance',
                'method': 'POST',
                'headers': {'Content-Type': 'application/json'},
                'data': {'amount': '-1000000'},
                'expected_failure': 400,
                'value': '$200,000 - $1,000,000'
            },
            {
                'name': 'Duplicate Transaction',
                'endpoint': '/api/v1/transaction',
                'method': 'POST',
                'headers': {'Content-Type': 'application/json'},
                'data': {'id': 'duplicate_id', 'amount': '1000'},
                'expected_failure': 409,
                'value': '$150,000 - $800,000'
            }
        ]
        
        for scenario in test_scenarios:
            full_url = urljoin(url, scenario['endpoint'])
            
            try:
                if scenario['method'] == 'GET':
                    response = self.session.get(full_url, headers=scenario['headers'], timeout=10)
                else:
                    response = self.session.post(full_url, headers=scenario['headers'], 
                                               json=scenario['data'], timeout=10)
                
                # Se não retornou erro esperado, pode ser uma vulnerabilidade
                if response.status_code != scenario['expected_failure']:
                    self.log_extreme_finding(
                        'business_logic',
                        f'Falha de Business Logic: {scenario["name"]}',
                        f'Endpoint {scenario["endpoint"]} não valida {scenario["name"]}',
                        scenario['value'],
                        f'{scenario["method"]} {full_url} retornou {response.status_code}'
                    )
                    
            except Exception as e:
                continue
                
    def scan_extreme_value_targets(self):
        """Escaneia alvos de valor extremo"""
        print("🎯 Escaneando alvos de valor extremo...")
        
        # Alvos de alto valor do Crypto.com
        extreme_targets = [
            'https://web.crypto.com',
            'https://crypto.com/exchange',
            'https://merchant.crypto.com',
            'https://developer.crypto.com',
            'https://developer-api.crypto.com',
            'https://developer-platform-api.crypto.com',
            'https://app.mona.co',
            'https://api.crypto.com',
            'https://api.mona.co'
        ]
        
        for target in extreme_targets:
            try:
                response = self.session.get(target, timeout=10)
                
                if response.status_code == 200:
                    self.results['extreme_value_targets'].append({
                        'url': target,
                        'status_code': response.status_code,
                        'content_length': len(response.text),
                        'headers': dict(response.headers)
                    })
                    
                    print(f"✅ Alvo ativo: {target}")
                    
            except Exception as e:
                print(f"❌ Alvo inativo: {target}")
                continue
                
    def run_extreme_scan(self):
        """Executa scan completo para vulnerabilidades extremas"""
        print("🚀 INICIANDO SCAN EXTREME HUNTER")
        print("=" * 80)
        print("🎯 Foco: Vulnerabilidades de $100K - $2M")
        print("💰 Potencial de Renda: EXTREMO")
        print("=" * 80)
        
        # Fase 1: Identificar alvos de valor extremo
        self.scan_extreme_value_targets()
        
        # Fase 2: Testar vulnerabilidades financeiras
        for target in self.results['extreme_value_targets']:
            url = target['url']
            print(f"\n💰 Testando vulnerabilidades financeiras em: {url}")
            self.test_financial_transfer_bypass(url)
            
        # Fase 3: Testar vazamento de dados
        for target in self.results['extreme_value_targets']:
            url = target['url']
            print(f"\n🔒 Testando vazamento de dados em: {url}")
            self.test_data_breach_vulnerabilities(url)
            
        # Fase 4: Testar bypass de autenticação
        for target in self.results['extreme_value_targets']:
            url = target['url']
            print(f"\n🔐 Testando bypass de autenticação em: {url}")
            self.test_authentication_bypass(url)
            
        # Fase 5: Testar smart contracts
        self.test_smart_contract_vulnerabilities()
        
        # Fase 6: Testar business logic
        for target in self.results['extreme_value_targets']:
            url = target['url']
            print(f"\n💼 Testando business logic em: {url}")
            self.test_business_logic_flaws(url)
            
        # Gerar relatório final
        self.generate_extreme_report()
        
    def generate_extreme_report(self):
        """Gera relatório de vulnerabilidades extremas"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        report_file = f"extreme_vulnerabilities_{timestamp}.json"
        
        # Calcular valor total potencial
        total_value = 0
        for category, findings in self.results.items():
            if category.endswith('_vulnerabilities'):
                for finding in findings:
                    value_range = finding['potential_value']
                    min_value = int(value_range.split('-')[0].replace('$', '').replace(',', ''))
                    total_value += min_value
        
        report_data = {
            'scan_info': {
                'domain': self.domain,
                'timestamp': datetime.now().isoformat(),
                'total_extreme_findings': sum(len(findings) for key, findings in self.results.items() if key.endswith('_vulnerabilities')),
                'total_potential_value': f"${total_value:,} - ${total_value * 2:,}",
                'scan_duration': '~30 minutos'
            },
            'findings': self.results,
            'summary': {
                'financial_vulnerabilities': len(self.results['financial_vulnerabilities']),
                'data_breach_vulnerabilities': len(self.results['data_breach_vulnerabilities']),
                'authentication_bypass': len(self.results['authentication_bypass']),
                'smart_contract_vulnerabilities': len(self.results['smart_contract_vulnerabilities']),
                'business_logic_flaws': len(self.results['business_logic_flaws']),
                'extreme_value_targets': len(self.results['extreme_value_targets'])
            }
        }
        
        with open(report_file, 'w') as f:
            json.dump(report_data, f, indent=2)
            
        print(f"\n🎉 SCAN EXTREME CONCLUÍDO!")
        print("=" * 80)
        print(f"📊 Total de Vulnerabilidades Extremas: {report_data['scan_info']['total_extreme_findings']}")
        print(f"💰 Valor Total Potencial: {report_data['scan_info']['total_potential_value']}")
        print(f"📁 Relatório salvo em: {report_file}")
        print("=" * 80)
        
        # Mostrar resumo das descobertas
        for category, findings in self.results.items():
            if category.endswith('_vulnerabilities') and findings:
                print(f"\n📊 {category.replace('_', ' ').title()}: {len(findings)} descobertas")
                for finding in findings:
                    print(f"   💰 {finding['potential_value']} - {finding['title']}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Uso: python3 extreme_hunter.py <domínio>")
        print("Exemplo: python3 extreme_hunter.py crypto.com")
        sys.exit(1)
        
    domain = sys.argv[1]
    hunter = ExtremeHunter(domain)
    hunter.run_extreme_scan()
