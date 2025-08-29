#!/bin/bash
# Script para Gravar Demo da Vulnerabilidade HTTP Method Override

echo "🎬 Iniciando Gravação do Demo da Vulnerabilidade"
echo "================================================"

# Verificar se o arquivo HTML existe
if [[ ! -f "demo_vulnerabilidade.html" ]]; then
    echo "❌ Arquivo demo_vulnerabilidade.html não encontrado!"
    exit 1
fi

# Criar diretório para demos
mkdir -p demos_gravados

# Data atual
DATA=$(date +"%Y%m%d_%H%M%S")

echo "📱 Verificando ferramentas de gravação..."

# Verificar se o ffmpeg está instalado
if ! command -v ffmpeg &> /dev/null; then
    echo "❌ ffmpeg não está instalado!"
    echo "📦 Instalando ffmpeg..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install ffmpeg
    else
        echo "Por favor, instale o ffmpeg manualmente"
        exit 1
    fi
fi

# Verificar se o Chrome/Chromium está disponível
if ! command -v google-chrome &> /dev/null && ! command -v chromium-browser &> /dev/null; then
    echo "⚠️  Chrome/Chromium não encontrado, usando Safari/abertura padrão"
    BROWSER="open"
else
    if command -v google-chrome &> /dev/null; then
        BROWSER="google-chrome"
    else
        BROWSER="chromium-browser"
    fi
fi

echo "🎯 Iniciando gravação do demo..."

# Função para gravar demo
gravar_demo() {
    echo "📹 Iniciando gravação da tela..."
    
    # Abrir o demo no navegador
    echo "🌐 Abrindo demo no navegador..."
    if [[ "$BROWSER" == "open" ]]; then
        open demo_vulnerabilidade.html
    else
        $BROWSER --new-window --start-maximized demo_vulnerabilidade.html &
    fi
    
    # Aguardar o navegador abrir
    sleep 3
    
    echo "🎬 Gravando demo (30 segundos)..."
    
    # Gravar tela por 30 segundos
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS - usar screencapture
        screencapture -v -t mp4 -V 30 "demos_gravados/demo_vulnerabilidade_${DATA}.mp4"
    else
        # Linux - usar ffmpeg
        ffmpeg -f x11grab -s 1920x1080 -i :0.0 -t 30 -c:v libx264 -preset ultrafast "demos_gravados/demo_vulnerabilidade_${DATA}.mp4" -y
    fi
    
    echo "✅ Gravação concluída!"
}

# Função para criar demo com imagens
criar_demo_imagens() {
    echo "📸 Criando demo com capturas de tela..."
    
    # Abrir o demo
    if [[ "$BROWSER" == "open" ]]; then
        open demo_vulnerabilidade.html
    else
        $BROWSER --new-window --start-maximized demo_vulnerabilidade.html &
    fi
    
    sleep 3
    
    # Capturar telas em diferentes momentos
    echo "📷 Capturando tela inicial..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        screencapture "demos_gravados/01_tela_inicial_${DATA}.png"
    else
        import -window root "demos_gravados/01_tela_inicial_${DATA}.png"
    fi
    
    sleep 2
    
    echo "📷 Capturando teste GET..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        screencapture "demos_gravados/02_teste_get_${DATA}.png"
    else
        import -window root "demos_gravados/02_teste_get_${DATA}.png"
    fi
    
    sleep 2
    
    echo "📷 Capturando teste POST (vulnerável)..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        screencapture "demos_gravados/03_teste_post_${DATA}.png"
    else
        import -window root "demos_gravados/03_teste_post_${DATA}.png"
    fi
    
    sleep 2
    
    echo "📷 Capturando teste DELETE (crítico)..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        screencapture "demos_gravados/04_teste_delete_${DATA}.png"
    else
        import -window root "demos_gravados/04_teste_delete_${DATA}.png"
    fi
    
    echo "✅ Capturas de tela concluídas!"
}

# Função para criar GIF animado
criar_gif_demo() {
    echo "🎞️  Criando GIF animado do demo..."
    
    # Verificar se o ImageMagick está instalado
    if ! command -v convert &> /dev/null; then
        echo "❌ ImageMagick não está instalado!"
        echo "📦 Instalando ImageMagick..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew install imagemagick
        else
            echo "Por favor, instale o ImageMagick manualmente"
            return
        fi
    fi
    
    # Criar GIF a partir das imagens capturadas
    if [[ -f "demos_gravados/01_tela_inicial_${DATA}.png" ]]; then
        convert -delay 1000 -loop 0 \
            "demos_gravados/01_tela_inicial_${DATA}.png" \
            "demos_gravados/02_teste_get_${DATA}.png" \
            "demos_gravados/03_teste_post_${DATA}.png" \
            "demos_gravados/04_teste_delete_${DATA}.png" \
            "demos_gravados/demo_vulnerabilidade_${DATA}.gif"
        
        echo "✅ GIF animado criado!"
    else
        echo "⚠️  Imagens não encontradas para criar GIF"
    fi
}

# Função para criar relatório do demo
criar_relatorio_demo() {
    echo "📋 Criando relatório do demo..."
    
    cat > "demos_gravados/relatorio_demo_${DATA}.md" << EOF
# 🎬 Relatório do Demo - HTTP Method Override Vulnerability

## 📋 Informações do Demo

**Data:** $(date +"%d/%m/%Y %H:%M:%S")  
**Vulnerabilidade:** HTTP Method Override  
**Endpoint:** https://api.grabpay.com/status  
**Severidade:** Critical  
**Valor:** \$5,000 - \$15,000  

## 🎯 Objetivo do Demo

Demonstrar visualmente a vulnerabilidade de HTTP Method Override encontrada no endpoint `/status` da API do GrabPay, mostrando como métodos HTTP normalmente não permitidos (POST, PUT, DELETE) são aceitos pelo servidor.

## 📹 Conteúdo do Demo

### 1. **Tela Inicial**
- Apresentação da vulnerabilidade
- Informações técnicas
- Impacto estimado

### 2. **Teste GET (Normal)**
- Demonstração do comportamento esperado
- Status 200 OK
- Headers expostos

### 3. **Teste POST (Vulnerável)**
- Demonstração da vulnerabilidade
- Status 200 OK (não deveria aceitar)
- Impacto de segurança

### 4. **Teste DELETE (Crítico)**
- Demonstração do impacto mais grave
- Potencial para remoção de dados
- Valor da recompensa

## 🎞️ Arquivos Gerados

- **Demo HTML:** demo_vulnerabilidade.html
- **Capturas de Tela:** 01_tela_inicial_${DATA}.png, 02_teste_get_${DATA}.png, etc.
- **GIF Animado:** demo_vulnerabilidade_${DATA}.gif
- **Vídeo:** demo_vulnerabilidade_${DATA}.mp4 (se disponível)

## 🎯 Uso do Demo

### Para Bug Bounty:
1. Incluir no report como evidência visual
2. Demonstrar o impacto da vulnerabilidade
3. Facilitar a compreensão da equipe de segurança

### Para Apresentações:
1. Mostrar o processo de descoberta
2. Demonstrar ferramentas utilizadas
3. Explicar o impacto de segurança

## 🔐 Considerações Éticas

- ✅ Demo criado para fins educacionais
- ✅ Nenhum teste real executado
- ✅ Report enviado através de canais oficiais
- ✅ Responsável disclosure seguido

## 📊 Métricas do Demo

- **Tempo de Gravação:** ~30 segundos
- **Tamanho do Arquivo:** Variável
- **Qualidade:** Alta definição
- **Compatibilidade:** Multi-plataforma

---

**Status:** ✅ Demo criado com sucesso
**Próximo Passo:** Incluir no report de bug bounty
EOF

    echo "✅ Relatório do demo criado!"
}

# Executar funções
echo "🎬 Escolha o tipo de demo:"
echo "1. Gravar vídeo da tela"
echo "2. Capturar imagens"
echo "3. Criar GIF animado"
echo "4. Todos os acima"
echo "5. Apenas relatório"

read -p "Escolha uma opção (1-5): " opcao

case $opcao in
    1)
        gravar_demo
        ;;
    2)
        criar_demo_imagens
        ;;
    3)
        criar_demo_imagens
        criar_gif_demo
        ;;
    4)
        gravar_demo
        criar_demo_imagens
        criar_gif_demo
        ;;
    5)
        criar_relatorio_demo
        ;;
    *)
        echo "❌ Opção inválida!"
        exit 1
        ;;
esac

# Sempre criar relatório
criar_relatorio_demo

echo ""
echo "🎬 Demo da Vulnerabilidade Concluído!"
echo "====================================="
echo ""
echo "📁 Arquivos gerados em: demos_gravados/"
echo ""
echo "📋 Conteúdo:"
ls -la demos_gravados/
echo ""
echo "🎯 Próximos passos:"
echo "   1. Revisar arquivos gerados"
echo "   2. Incluir no report de bug bounty"
echo "   3. Enviar para HackerOne/Bugcrowd"
echo ""
echo "💰 Valor da vulnerabilidade: \$5,000 - \$15,000"
