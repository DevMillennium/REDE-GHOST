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
