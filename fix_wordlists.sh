#!/bin/bash
# Script para Corrigir Problemas de Wordlists e Dependências

echo "🔧 Corrigindo Problemas de Wordlists e Dependências"
echo "=================================================="

# 1. Verificar se ffuf está instalado
if ! command -v ffuf &> /dev/null; then
    echo "❌ ffuf não está instalado!"
    echo "📦 Instalando ffuf..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install ffuf
    else
        echo "Por favor, instale o ffuf manualmente: https://github.com/ffuf/ffuf"
    fi
else
    echo "✅ ffuf está instalado"
fi

# 2. Verificar se subfinder está instalado
if ! command -v subfinder &> /dev/null; then
    echo "❌ subfinder não está instalado!"
    echo "📦 Instalando subfinder..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install subfinder
    else
        echo "Por favor, instale o subfinder manualmente: https://github.com/projectdiscovery/subfinder"
    fi
else
    echo "✅ subfinder está instalado"
fi

# 3. Verificar se nuclei está instalado
if ! command -v nuclei &> /dev/null; then
    echo "❌ nuclei não está instalado!"
    echo "📦 Instalando nuclei..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install nuclei
    else
        echo "Por favor, instale o nuclei manualmente: https://github.com/projectdiscovery/nuclei"
    fi
else
    echo "✅ nuclei está instalado"
fi

# 4. Criar diretório de wordlists se não existir
if [[ ! -d "wordlists" ]]; then
    echo "📁 Criando diretório wordlists..."
    mkdir -p wordlists
fi

# 5. Verificar wordlists essenciais
ESSENTIAL_WORDLISTS=("common.txt" "extensions.txt")

for wordlist in "${ESSENTIAL_WORDLISTS[@]}"; do
    if [[ ! -f "wordlists/$wordlist" ]]; then
        echo "❌ Wordlist $wordlist não encontrada!"
        echo "📝 Criando wordlist básica..."
        
        case $wordlist in
            "common.txt")
                cat > "wordlists/common.txt" << 'EOF'
admin
login
api
wp-admin
phpmyadmin
config
backup
test
dev
staging
prod
assets
images
css
js
uploads
downloads
docs
help
support
contact
about
blog
news
forum
shop
cart
checkout
user
profile
dashboard
panel
console
shell
terminal
ssh
ftp
mail
webmail
cpanel
plesk
wordpress
joomla
drupal
magento
shopify
.git
.svn
.env
.htaccess
robots.txt
sitemap.xml
favicon.ico
manifest.json
service-worker.js
EOF
                ;;
            "extensions.txt")
                cat > "wordlists/extensions.txt" << 'EOF'
.php
.html
.htm
.js
.css
.jpg
.jpeg
.png
.gif
.pdf
.txt
.xml
.json
.zip
.tar.gz
.sql
.bak
.old
.tmp
.log
.conf
.ini
.yml
.yaml
.env
.htaccess
.htpasswd
EOF
                ;;
        esac
        echo "✅ Wordlist $wordlist criada!"
    else
        echo "✅ Wordlist $wordlist encontrada"
    fi
done

# 6. Verificar permissões dos scripts
echo "🔐 Verificando permissões dos scripts..."
chmod +x *.sh 2>/dev/null || true

# 7. Verificar ambiente Python
echo "🐍 Verificando ambiente Python..."
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 não está instalado!"
else
    echo "✅ Python3 está instalado"
    
    # Verificar se o ambiente virtual existe
    if [[ ! -d "ml_env" ]]; then
        echo "📦 Criando ambiente virtual Python..."
        python3 -m venv ml_env
    fi
    
    echo "📦 Instalando dependências Python..."
    source ml_env/bin/activate
    pip install pandas numpy scikit-learn requests beautifulsoup4
fi

echo ""
echo "✅ Correções concluídas!"
echo "📋 Próximos passos:"
echo "   1. Execute: ./auto_hunt.sh <dominio>"
echo "   2. Verifique os resultados em vulnerabilities.txt"
echo "   3. Analise os logs em ml_bug_hunter.log"
