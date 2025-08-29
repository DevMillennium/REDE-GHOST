#!/bin/bash

# Script de Configuração Completa - Bug Hunting com ML
# Autor: Assistente AI
# Versão: 1.0

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
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

log_admin() {
    echo -e "${PURPLE}[ADMIN]${NC} $1"
}

log_ml() {
    echo -e "${CYAN}[ML]${NC} $1"
}

# Banner
show_banner() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    BUG HUNTING SUITE                         ║"
    echo "║                Mac M3 + Machine Learning                     ║"
    echo "║                    Otimização Completa                       ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Verificar sistema
check_system() {
    log_info "Verificando sistema..."
    
    # Verificar arquitetura
    if [[ $(uname -m) == "arm64" ]]; then
        log_success "Mac M3 (Apple Silicon) detectado"
    else
        log_warning "Arquitetura não otimizada para M3"
    fi
    
    # Verificar ferramentas instaladas
    tools=("nuclei" "httpx" "subfinder" "ffuf" "katana" "amass")
    for tool in "${tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            log_success "$tool - OK"
        else
            log_error "$tool - NÃO ENCONTRADO"
        fi
    done
    
    # Verificar ambiente Python
    if [[ -d "ml_env" ]]; then
        log_success "Ambiente Python ML - OK"
    else
        log_error "Ambiente Python ML - NÃO ENCONTRADO"
    fi
}

# Configurar variáveis de ambiente otimizadas
setup_environment() {
    log_info "Configurando ambiente otimizado..."
    
    # Criar arquivo de configuração
    cat > .env_optimized << 'EOF'
# Configurações Otimizadas para Bug Hunting - Mac M3
export ARCH="arm64"
export GOARCH="arm64"
export GOMAXPROCS=$(sysctl -n hw.ncpu)
export GOGC=50
export PYTHONUNBUFFERED=1
export PYTHONDONTWRITEBYTECODE=1
export TCP_NODELAY=1
export CACHE_DIR="$HOME/.cache/bug_hunting"

# Aliases úteis
alias recon='./pipeline_recon.sh'
alias scan='./pipeline_scan.sh'
alias ml='./pipeline_ml.sh'
alias monitor='./monitor_performance.sh'
alias admin='./admin_monitor.sh'
alias privileged='./run_privileged.sh'
EOF

    # Carregar configurações
    source .env_optimized
    
    log_success "Ambiente configurado"
}

# Configurar diretórios e cache
setup_directories() {
    log_info "Configurando diretórios..."
    
    # Criar estrutura de diretórios
    mkdir -p ~/.cache/bug_hunting/{nuclei,subfinder,httpx,ml}
    mkdir -p ~/bug_hunting/{results,logs,data}
    mkdir -p ~/bug_hunting/templates
    
    # Configurar permissões
    chmod 755 ~/.cache/bug_hunting
    chmod 755 ~/bug_hunting
    
    log_success "Diretórios configurados"
}

# Configurar templates e recursos
setup_resources() {
    log_info "Configurando recursos..."
    
    # Atualizar templates do Nuclei
    if command -v nuclei &> /dev/null; then
        nuclei -update-templates
    fi
    
    # Configurar wordlists básicas
    if [[ ! -f ~/bug_hunting/wordlists/common.txt ]]; then
        mkdir -p ~/bug_hunting/wordlists
        echo "admin" > ~/bug_hunting/wordlists/common.txt
        echo "login" >> ~/bug_hunting/wordlists/common.txt
        echo "api" >> ~/bug_hunting/wordlists/common.txt
        echo "test" >> ~/bug_hunting/wordlists/common.txt
        echo "dev" >> ~/bug_hunting/wordlists/common.txt
    fi
    
    log_success "Recursos configurados"
}

# Configurar monitoramento
setup_monitoring() {
    log_info "Configurando monitoramento..."
    
    # Script de monitoramento em tempo real
    cat > monitor_realtime.sh << 'EOF'
#!/bin/bash
# Monitor em Tempo Real para Bug Hunting

echo "📊 Monitor em Tempo Real - Bug Hunting"
echo "======================================"

while true; do
    clear
    echo "$(date)"
    echo ""
    
    # CPU e Memória
    echo "🖥️  CPU e Memória:"
    top -l 1 | head -5
    
    # Processos ativos
    echo ""
    echo "🔄 Processos Ativos:"
    ps aux | grep -E "(nuclei|subfinder|httpx|ffuf|python)" | grep -v grep || echo "Nenhum processo ativo"
    
    # Rede
    echo ""
    echo "🌐 Rede:"
    netstat -i | head -3
    
    sleep 5
done
EOF

    chmod +x monitor_realtime.sh
    log_success "Monitoramento configurado"
}

# Configurar scripts de automação
setup_automation() {
    log_info "Configurando automação..."
    
    # Script de automação completa
    cat > auto_hunt.sh << 'EOF'
#!/bin/bash
# Automação Completa de Bug Hunting

DOMAIN=$1
if [[ -z "$DOMAIN" ]]; then
    echo "Uso: $0 <domínio>"
    exit 1
fi

echo "🤖 Automação Completa para: $DOMAIN"
echo "=================================="

# 1. Reconhecimento
echo "📡 Fase 1: Reconhecimento"
./pipeline_recon.sh "$DOMAIN"

# 2. Scan de vulnerabilidades
echo "🔍 Fase 2: Scan de Vulnerabilidades"
if [[ -f active_urls.txt ]]; then
    ./pipeline_scan.sh active_urls.txt
fi

# 3. Análise com ML
echo "🤖 Fase 3: Análise com Machine Learning"
./pipeline_ml.sh "$DOMAIN"

# 4. Relatório
echo "📊 Fase 4: Gerando Relatório"
echo "Relatório gerado em: $(date)" > report.txt
echo "Domínio: $DOMAIN" >> report.txt
echo "" >> report.txt

if [[ -f vulnerabilities.txt ]]; then
    echo "Vulnerabilidades encontradas:" >> report.txt
    cat vulnerabilities.txt >> report.txt
fi

if [[ -f ml_results.json ]]; then
    echo "" >> report.txt
    echo "Análise ML:" >> report.txt
    cat ml_results.json >> report.txt
fi

echo "✅ Automação concluída! Relatório salvo em report.txt"
EOF

    chmod +x auto_hunt.sh
    log_success "Automação configurada"
}

# Configurar backup e versionamento
setup_backup() {
    log_info "Configurando backup e versionamento..."
    
    # Script de backup
    cat > backup_results.sh << 'EOF'
#!/bin/bash
# Backup de Resultados

BACKUP_DIR="~/bug_hunting/backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup de resultados
cp -r ~/bug_hunting/results/* "$BACKUP_DIR/" 2>/dev/null || true
cp -r ~/.cache/bug_hunting/* "$BACKUP_DIR/" 2>/dev/null || true

# Backup de logs
cp *.log "$BACKUP_DIR/" 2>/dev/null || true
cp *.json "$BACKUP_DIR/" 2>/dev/null || true

echo "✅ Backup criado em: $BACKUP_DIR"
EOF

    chmod +x backup_results.sh
    log_success "Backup configurado"
}

# Função principal
main() {
    show_banner
    
    log_info "Iniciando configuração completa..."
    
    check_system
    setup_environment
    setup_directories
    setup_resources
    setup_monitoring
    setup_automation
    setup_backup
    
    echo ""
    echo "🎉 CONFIGURAÇÃO COMPLETA FINALIZADA!"
    echo "====================================="
    echo ""
    echo "📋 Scripts Disponíveis:"
    echo "  - auto_hunt.sh <domínio>        - Automação completa"
    echo "  - pipeline_recon.sh <domínio>   - Reconhecimento"
    echo "  - pipeline_scan.sh <arquivo>    - Scan de vulnerabilidades"
    echo "  - pipeline_ml.sh <domínio>      - Análise com ML"
    echo "  - monitor_realtime.sh           - Monitor em tempo real"
    echo "  - backup_results.sh             - Backup de resultados"
    echo ""
    echo "🔧 Comandos Rápidos:"
    echo "  recon <domínio>                 - Reconhecimento rápido"
    echo "  scan <arquivo>                  - Scan rápido"
    echo "  ml <domínio>                    - ML rápido"
    echo "  monitor                         - Monitor de performance"
    echo "  admin                           - Monitor administrativo"
    echo ""
    echo "🤖 Para usar Machine Learning:"
    echo "  source ml_env/bin/activate"
    echo "  python3 ml_bug_hunter.py <domínio>"
    echo ""
    echo "🎯 Exemplo de Uso Completo:"
    echo "  ./auto_hunt.sh exemplo.com"
    echo ""
    echo "⚠️  IMPORTANTE:"
    echo "  - Sempre use dentro do escopo autorizado"
    echo "  - Mantenha logs de todas as atividades"
    echo "  - Faça backup regular dos resultados"
    echo ""
    echo "🚀 Seu ambiente está pronto para bug hunting otimizado!"
}

# Executar função principal
main "$@"
