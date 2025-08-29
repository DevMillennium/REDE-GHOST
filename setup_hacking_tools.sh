#!/bin/bash

# Script de configuração para ferramentas de hacking
# Autor: Assistente AI
# Data: $(date)

echo "🔧 Configurando ambiente de hacking..."

# Verificar se as ferramentas estão instaladas
echo "📋 Verificando ferramentas instaladas..."

# Ferramentas principais
tools=("nuclei" "httpx" "subfinder" "dnsx" "naabu" "katana" "ffuf" "amass" "mitmproxy" "wireshark")

for tool in "${tools[@]}"; do
    if command -v "$tool" &> /dev/null; then
        echo "✅ $tool - OK"
    else
        echo "❌ $tool - NÃO ENCONTRADO"
    fi
done

# Verificar ferramentas Python
if command -v arjun &> /dev/null; then
    echo "✅ arjun - OK"
else
    echo "❌ arjun - NÃO ENCONTRADO"
fi

# Verificar JWT-Tool
if [ -d "jwt_tool" ]; then
    echo "✅ jwt_tool - OK (pasta local)"
else
    echo "❌ jwt_tool - NÃO ENCONTRADO"
fi

# Verificar templates do Nuclei
if [ -d "nuclei-templates" ]; then
    echo "✅ nuclei-templates - OK"
else
    echo "❌ nuclei-templates - NÃO ENCONTRADO"
fi

echo ""
echo "🚀 Configuração concluída!"
echo ""
echo "📝 Comandos úteis:"
echo "  subfinder -d exemplo.com | httpx"
echo "  nuclei -t nuclei-templates -u https://exemplo.com"
echo "  ffuf -u https://exemplo.com/FUZZ -w /usr/share/wordlists/dirb/common.txt"
echo "  katana -u https://exemplo.com"
echo ""
echo "🔗 Para usar o JWT-Tool:"
echo "  cd jwt_tool && python3 jwt_tool.py"
echo ""
echo "📚 Recursos adicionais:"
echo "  - Burp Suite Community (baixar do site oficial)"
echo "  - OWASP ZAP (baixar do site oficial)"
echo "  - Insomnia/Postman para APIs"
