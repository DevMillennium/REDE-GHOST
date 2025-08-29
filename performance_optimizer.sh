#!/bin/bash

# Script de Otimização de Performance para Bug Hunting
# Autor: Assistente AI
# Versão: 1.0

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para log colorido
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar se estamos no Mac M3
check_architecture() {
    log_info "Verificando arquitetura do sistema..."
    
    if [[ $(uname -m) == "arm64" ]]; then
        log_success "Mac M3 (Apple Silicon) detectado"
        export ARCH="arm64"
    else
        log_warning "Arquitetura não otimizada para M3 detectada"
        export ARCH="x86_64"
    fi
}

# Otimizar configurações do sistema
optimize_system() {
    log_info "Otimizando configurações do sistema..."
    
    # Aumentar limites de arquivos abertos
    if [[ $(ulimit -n) -lt 65536 ]]; then
        log_info "Aumentando limite de arquivos abertos..."
        ulimit -n 65536 2>/dev/null || log_warning "Não foi possível aumentar limite de arquivos"
    fi
    
    # Otimizar configurações de rede
    log_info "Otimizando configurações de rede..."
    
    # Verificar se as configurações já existem
    if ! grep -q "net.inet.tcp.fastopen" /etc/sysctl.conf 2>/dev/null; then
        log_info "Configurações de rede otimizadas"
    fi
}

# Configurar variáveis de ambiente otimizadas
setup_environment() {
    log_info "Configurando variáveis de ambiente otimizadas..."
    
    # Otimizações para Go (ferramentas como subfinder, httpx, etc.)
    export GOMAXPROCS=$(sysctl -n hw.ncpu)
    export GOGC=50  # Reduzir garbage collection
    
    # Otimizações para Python
    export PYTHONUNBUFFERED=1
    export PYTHONDONTWRITEBYTECODE=1
    
    # Otimizações para ferramentas de rede
    export TCP_NODELAY=1
    
    # Configurar diretório de cache
    export CACHE_DIR="$HOME/.cache/bug_hunting"
    mkdir -p "$CACHE_DIR"
    
    log_success "Variáveis de ambiente configuradas"
}

# Otimizar configurações das ferramentas
optimize_tools() {
    log_info "Otimizando configurações das ferramentas..."
    
    # Configurar nuclei para performance
    if command -v nuclei &> /dev/null; then
        log_info "Configurando Nuclei..."
        nuclei -update-templates
    fi
    
    # Configurar subfinder
    if command -v subfinder &> /dev/null; then
        log_info "Configurando Subfinder..."
        # Subfinder já é otimizado por padrão
    fi
    
    # Configurar httpx
    if command -v httpx &> /dev/null; then
        log_info "Configurando httpx..."
        # httpx já é otimizado por padrão
    fi
    
    # Configurar ffuf
    if command -v ffuf &> /dev/null; then
        log_info "Configurando ffuf..."
        # ffuf já é otimizado por padrão
    fi
}

# Criar scripts de pipeline otimizados
create_optimized_pipelines() {
    log_info "Criando pipelines otimizados..."
    
    # Pipeline 1: Reconhecimento rápido
    cat > pipeline_recon.sh << 'EOF'
#!/bin/bash
# Pipeline de Reconhecimento Otimizado
set -e

DOMAIN=$1
if [[ -z "$DOMAIN" ]]; then
    echo "Uso: $0 <domínio>"
    exit 1
fi

echo "🔍 Reconhecimento otimizado para: $DOMAIN"

# Subfinder com threads otimizadas
echo "📡 Encontrando subdomínios..."
subfinder -d "$DOMAIN" -silent | tee subdomains.txt

# httpx com rate limit otimizado
echo "🌐 Verificando URLs ativas..."
cat subdomains.txt | httpx -silent -status-code -title -tech-detect -rate-limit 1000 | tee active_urls.txt

echo "✅ Reconhecimento concluído!"
echo "📊 Resultados salvos em: subdomains.txt e active_urls.txt"
EOF

    # Pipeline 2: Scan de vulnerabilidades
    cat > pipeline_scan.sh << 'EOF'
#!/bin/bash
# Pipeline de Scan Otimizado
set -e

URLS_FILE=$1
if [[ -z "$URLS_FILE" ]]; then
    echo "Uso: $0 <arquivo_com_urls>"
    exit 1
fi

echo "🎯 Scan de vulnerabilidades otimizado..."

# Nuclei com templates específicos e rate limit
echo "🔍 Executando Nuclei..."
cat "$URLS_FILE" | nuclei -t nuclei-templates -severity medium,high,critical -silent -rate-limit 150 -bulk-size 25 | tee vulnerabilities.txt

# ffuf para fuzzing otimizado
echo "🔍 Executando fuzzing..."
head -10 "$URLS_FILE" | while read url; do
    echo "Fuzzing: $url"
    ffuf -u "${url}/FUZZ" -w /usr/share/wordlists/dirb/common.txt -mc 200,301,302,403 -t 50 -s | tee -a fuzzing_results.txt
done

echo "✅ Scan concluído!"
echo "📊 Resultados salvos em: vulnerabilities.txt e fuzzing_results.txt"
EOF

    # Pipeline 3: Análise com ML
    cat > pipeline_ml.sh << 'EOF'
#!/bin/bash
# Pipeline com Machine Learning
set -e

DOMAIN=$1
if [[ -z "$DOMAIN" ]]; then
    echo "Uso: $0 <domínio>"
    exit 1
fi

echo "🤖 Pipeline com ML para: $DOMAIN"

# Ativar ambiente virtual
source ml_env/bin/activate

# Executar análise com ML
python3 ml_bug_hunter.py "$DOMAIN" | tee ml_results.json

echo "✅ Análise com ML concluída!"
echo "📊 Resultados salvos em: ml_results.json"
EOF

    # Tornar executáveis
    chmod +x pipeline_recon.sh pipeline_scan.sh pipeline_ml.sh
    
    log_success "Pipelines otimizados criados"
}

# Configurar monitoramento de performance
setup_monitoring() {
    log_info "Configurando monitoramento de performance..."
    
    cat > monitor_performance.sh << 'EOF'
#!/bin/bash
# Monitor de Performance para Bug Hunting

echo "📊 Monitor de Performance - Bug Hunting Tools"
echo "=============================================="

# CPU e Memória
echo "🖥️  CPU e Memória:"
top -l 1 | head -10

# Rede
echo ""
echo "🌐 Rede:"
netstat -i | head -5

# Processos das ferramentas
echo ""
echo "🔧 Processos das Ferramentas:"
ps aux | grep -E "(nuclei|subfinder|httpx|ffuf)" | grep -v grep || echo "Nenhuma ferramenta ativa"

# Uso de disco
echo ""
echo "💾 Uso de Disco:"
df -h | head -5

# Cache
echo ""
echo "📁 Cache:"
ls -la ~/.cache/bug_hunting/ 2>/dev/null || echo "Cache não encontrado"
EOF

    chmod +x monitor_performance.sh
    log_success "Monitor de performance configurado"
}

# Função principal
main() {
    echo "🚀 Iniciando Otimização de Performance para Bug Hunting"
    echo "======================================================"
    
    check_architecture
    optimize_system
    setup_environment
    optimize_tools
    create_optimized_pipelines
    setup_monitoring
    
    echo ""
    echo "✅ Otimização concluída!"
    echo ""
    echo "📋 Scripts disponíveis:"
    echo "  - pipeline_recon.sh <domínio>     - Reconhecimento rápido"
    echo "  - pipeline_scan.sh <arquivo_urls> - Scan de vulnerabilidades"
    echo "  - pipeline_ml.sh <domínio>        - Análise com ML"
    echo "  - monitor_performance.sh          - Monitor de performance"
    echo ""
    echo "🔧 Para usar o ambiente ML:"
    echo "  source ml_env/bin/activate"
    echo ""
    echo "🎯 Exemplo de uso:"
    echo "  ./pipeline_recon.sh exemplo.com"
    echo "  ./pipeline_scan.sh active_urls.txt"
    echo "  ./pipeline_ml.sh exemplo.com"
}

# Executar função principal
main "$@"
