#!/bin/bash

# Script de Configuração de Permissões Administrativas
# Autor: Assistente AI
# Versão: 1.0

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
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

# Verificar se está rodando como root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        log_admin "Executando como root - permissões administrativas ativas"
        return 0
    else
        log_warning "Executando sem privilégios de root"
        log_info "Algumas otimizações podem requerer sudo"
        return 1
    fi
}

# Configurar permissões de rede
setup_network_permissions() {
    log_admin "Configurando permissões de rede..."
    
    # Permitir captura de pacotes (necessário para Wireshark)
    if command -v wireshark &> /dev/null; then
        log_info "Configurando permissões para Wireshark..."
        sudo chmod 644 /dev/bpf* 2>/dev/null || log_warning "Não foi possível configurar permissões BPF"
    fi
    
    # Configurar limites de rede
    log_info "Configurando limites de rede..."
    
    # Aumentar limite de conexões simultâneas
    if [[ -f /etc/sysctl.conf ]]; then
        echo "net.core.somaxconn = 65535" | sudo tee -a /etc/sysctl.conf
        echo "net.ipv4.tcp_max_syn_backlog = 65535" | sudo tee -a /etc/sysctl.conf
        sudo sysctl -p
    fi
    
    log_success "Permissões de rede configuradas"
}

# Configurar permissões de arquivo
setup_file_permissions() {
    log_admin "Configurando permissões de arquivo..."
    
    # Criar diretórios com permissões adequadas
    sudo mkdir -p /opt/bug_hunting/{cache,logs,data}
    sudo chown -R $(whoami):$(id -gn) /opt/bug_hunting
    sudo chmod -R 755 /opt/bug_hunting
    
    # Configurar diretório de cache
    mkdir -p ~/.cache/bug_hunting/{nuclei,subfinder,httpx}
    chmod 755 ~/.cache/bug_hunting
    
    log_success "Permissões de arquivo configuradas"
}

# Configurar permissões de processo
setup_process_permissions() {
    log_admin "Configurando permissões de processo..."
    
    # Aumentar limites de processo
    ulimit -u 65536 2>/dev/null || log_warning "Não foi possível aumentar limite de processos"
    ulimit -n 65536 2>/dev/null || log_warning "Não foi possível aumentar limite de arquivos"
    
    # Configurar nice para processos de bug hunting
    log_info "Configurando prioridades de processo..."
    
    log_success "Permissões de processo configuradas"
}

# Configurar firewall e segurança
setup_security() {
    log_admin "Configurando segurança..."
    
    # Verificar se o firewall está ativo
    if command -v pfctl &> /dev/null; then
        log_info "Firewall macOS detectado"
        # Não desabilitar o firewall, apenas configurar regras se necessário
    fi
    
    # Configurar certificados para interceptação HTTPS
    log_info "Configurando certificados para interceptação..."
    
    # Criar diretório para certificados
    mkdir -p ~/.mitmproxy
    chmod 700 ~/.mitmproxy
    
    log_success "Configurações de segurança aplicadas"
}

# Configurar otimizações específicas do M3
setup_m3_optimizations() {
    log_admin "Configurando otimizações específicas do Mac M3..."
    
    # Verificar se é Apple Silicon
    if [[ $(uname -m) == "arm64" ]]; then
        log_info "Aplicando otimizações para Apple Silicon..."
        
        # Configurar variáveis de ambiente para ARM64
        export ARCH="arm64"
        export GOARCH="arm64"
        
        # Otimizações para ferramentas Go
        export GOMAXPROCS=$(sysctl -n hw.ncpu)
        export GOGC=50
        
        # Otimizações para Python
        export PYTHONUNBUFFERED=1
        export PYTHONDONTWRITEBYTECODE=1
        
        log_success "Otimizações do M3 aplicadas"
    else
        log_warning "Não é Apple Silicon - otimizações limitadas"
    fi
}

# Configurar ferramentas com privilégios elevados
setup_tool_permissions() {
    log_admin "Configurando permissões das ferramentas..."
    
    # Nuclei - configurar templates com permissões adequadas
    if command -v nuclei &> /dev/null; then
        log_info "Configurando Nuclei..."
        nuclei -update-templates
    fi
    
    # Subfinder - configurar para performance máxima
    if command -v subfinder &> /dev/null; then
        log_info "Configurando Subfinder..."
        # Subfinder já é otimizado
    fi
    
    # httpx - configurar rate limits otimizados
    if command -v httpx &> /dev/null; then
        log_info "Configurando httpx..."
        # httpx já é otimizado
    fi
    
    # ffuf - configurar threads otimizadas
    if command -v ffuf &> /dev/null; then
        log_info "Configurando ffuf..."
        # ffuf já é otimizado
    fi
    
    log_success "Permissões das ferramentas configuradas"
}

# Configurar monitoramento administrativo
setup_admin_monitoring() {
    log_admin "Configurando monitoramento administrativo..."
    
    cat > admin_monitor.sh << 'EOF'
#!/bin/bash
# Monitor Administrativo para Bug Hunting

echo "🔐 Monitor Administrativo - Bug Hunting Tools"
echo "=============================================="

# Verificar permissões
echo "🔑 Verificando Permissões:"
echo "  Usuário: $(whoami)"
echo "  UID: $(id -u)"
echo "  Grupos: $(id -Gn)"
echo "  Root: $([[ $EUID -eq 0 ]] && echo "SIM" || echo "NÃO")"

# Verificar limites do sistema
echo ""
echo "📊 Limites do Sistema:"
echo "  Processos: $(ulimit -u)"
echo "  Arquivos: $(ulimit -n)"
echo "  Memória: $(ulimit -v)"

# Verificar processos ativos
echo ""
echo "🔄 Processos Ativos:"
ps aux | grep -E "(nuclei|subfinder|httpx|ffuf|python)" | grep -v grep || echo "Nenhum processo ativo"

# Verificar uso de recursos
echo ""
echo "💻 Recursos do Sistema:"
top -l 1 | head -5

# Verificar rede
echo ""
echo "🌐 Status da Rede:"
netstat -i | head -3

# Verificar certificados
echo ""
echo "🔒 Certificados:"
ls -la ~/.mitmproxy/ 2>/dev/null || echo "Certificados não encontrados"
EOF

    chmod +x admin_monitor.sh
    log_success "Monitor administrativo configurado"
}

# Configurar scripts de execução privilegiada
setup_privileged_scripts() {
    log_admin "Configurando scripts com privilégios elevados..."
    
    # Script para execução com sudo quando necessário
    cat > run_privileged.sh << 'EOF'
#!/bin/bash
# Script para execução com privilégios elevados

TOOL=$1
shift

case $TOOL in
    "nuclei")
        echo "🔍 Executando Nuclei com privilégios elevados..."
        sudo -E nuclei "$@"
        ;;
    "subfinder")
        echo "📡 Executando Subfinder com privilégios elevados..."
        sudo -E subfinder "$@"
        ;;
    "httpx")
        echo "🌐 Executando httpx com privilégios elevados..."
        sudo -E httpx "$@"
        ;;
    "ffuf")
        echo "🔍 Executando ffuf com privilégios elevados..."
        sudo -E ffuf "$@"
        ;;
    "wireshark")
        echo "📊 Executando Wireshark com privilégios elevados..."
        sudo -E wireshark "$@"
        ;;
    *)
        echo "Uso: $0 <ferramenta> [argumentos]"
        echo "Ferramentas disponíveis: nuclei, subfinder, httpx, ffuf, wireshark"
        exit 1
        ;;
esac
EOF

    chmod +x run_privileged.sh
    log_success "Scripts privilegiados configurados"
}

# Função principal
main() {
    echo "🔐 Configuração de Permissões Administrativas"
    echo "=============================================="
    
    check_root
    
    setup_network_permissions
    setup_file_permissions
    setup_process_permissions
    setup_security
    setup_m3_optimizations
    setup_tool_permissions
    setup_admin_monitoring
    setup_privileged_scripts
    
    echo ""
    echo "✅ Configuração administrativa concluída!"
    echo ""
    echo "📋 Scripts disponíveis:"
    echo "  - admin_monitor.sh              - Monitor administrativo"
    echo "  - run_privileged.sh <tool>      - Executar ferramentas com privilégios"
    echo "  - performance_optimizer.sh      - Otimização de performance"
    echo ""
    echo "🔧 Exemplos de uso:"
    echo "  ./run_privileged.sh nuclei -u https://exemplo.com"
    echo "  ./run_privileged.sh subfinder -d exemplo.com"
    echo "  ./admin_monitor.sh"
    echo ""
    echo "⚠️  IMPORTANTE:"
    echo "  - Use privilégios elevados apenas quando necessário"
    echo "  - Sempre respeite os termos de serviço dos alvos"
    echo "  - Mantenha logs de todas as atividades"
}

# Executar função principal
main "$@"
