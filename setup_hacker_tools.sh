#!/bin/bash
# 🎯 Setup Ferramentas Reais de Hacker + ML
# Instalação completa de ferramentas de análise e ataque

echo "🎯 SETUP FERRAMENTAS REAIS DE HACKER + ML"
echo "=========================================="

# Atualizar sistema
echo "📦 Atualizando sistema..."
brew update

# Instalar ferramentas básicas
echo "🔧 Instalando ferramentas básicas..."
brew install nmap
brew install python3
brew install git
brew install curl
brew install wget
brew install jq

# Instalar ferramentas de rede
echo "🌐 Instalando ferramentas de rede..."
brew install whois
brew install dnsutils
brew install netcat
brew install tcpdump
brew install wireshark

# Instalar ferramentas de segurança
echo "🛡️ Instalando ferramentas de segurança..."
brew install sqlmap
brew install nikto
brew install dirb
brew install gobuster
brew install hydra

# Instalar ferramentas de desenvolvimento
echo "💻 Instalando ferramentas de desenvolvimento..."
brew install node
brew install ruby
brew install go

# Instalar Python packages
echo "🐍 Instalando Python packages..."
pip3 install requests
pip3 install pandas
pip3 install numpy
pip3 install scikit-learn
pip3 install matplotlib
pip3 install seaborn
pip3 install python-nmap
pip3 install dnspython
pip3 install python-whois
pip3 install shodan
pip3 install censys
pip3 install virustotal-python
pip3 install builtwith
pip3 install python-wappalyzer
pip3 install paramiko
pip3 install beautifulsoup4
pip3 install lxml
pip3 install selenium
pip3 install aiohttp
pip3 install asyncio

# Instalar ferramentas de reconhecimento
echo "🔍 Instalando ferramentas de reconhecimento..."
pip3 install sublist3r
pip3 install amass
pip3 install theHarvester
pip3 install recon-ng

# Instalar ferramentas de exploração
echo "⚔️ Instalando ferramentas de exploração..."
pip3 install metasploit-framework
pip3 install exploit-db
pip3 install searchsploit

# Configurar ambiente
echo "⚙️ Configurando ambiente..."
mkdir -p ~/tools
mkdir -p ~/reports
mkdir -p ~/evidence

# Criar aliases úteis
echo "📝 Criando aliases..."
echo 'alias nmap="nmap -sS -sV -O -A"' >> ~/.zshrc
echo 'alias scan="nmap -p-"' >> ~/.zshrc
echo 'alias vuln="nmap --script=vuln"' >> ~/.zshrc

# Configurar variáveis de ambiente
echo "🔧 Configurando variáveis de ambiente..."
echo 'export PATH="$HOME/tools:$PATH"' >> ~/.zshrc
echo 'export PYTHONPATH="$HOME/tools:$PYTHONPATH"' >> ~/.zshrc

# Instalar ferramentas adicionais
echo "🛠️ Instalando ferramentas adicionais..."
brew install --cask burp-suite
brew install --cask wireshark
brew install --cask virtualbox

# Configurar permissões
echo "🔐 Configurando permissões..."
chmod +x *.py
chmod +x *.sh

echo "✅ SETUP CONCLUÍDO!"
echo "🎯 Ferramentas de hacker instaladas e configuradas"
echo "🤖 Machine Learning pronto para uso"
echo "📊 Ambiente preparado para análise profunda"
