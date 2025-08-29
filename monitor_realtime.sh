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
