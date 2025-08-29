#!/bin/bash
# Gravação de Tela - Demonstração Real para HackerOne
# Processo Legal e Aprovado de Bug Bounty

echo "🎥 GRAVAÇÃO DE DEMONSTRAÇÃO - HACKERONE"
echo "======================================="
echo "📋 Processo Legal e Aprovado"
echo "🎯 Demonstração Real das Vulnerabilidades"
echo ""

# Verificar se ffmpeg está instalado
if ! command -v ffmpeg &> /dev/null; then
    echo "❌ FFmpeg não encontrado. Instalando..."
    brew install ffmpeg
fi

# Verificar se o sistema suporta gravação
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "✅ macOS detectado - Suporte nativo para gravação"
    RECORDING_METHOD="macos"
else
    echo "⚠️ Sistema não suportado para gravação automática"
    echo "📝 Use ferramentas como OBS Studio ou similar"
    exit 1
fi

# Criar diretório para gravações
RECORDINGS_DIR="demonstracoes_hackerone_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$RECORDINGS_DIR"

echo "📁 Diretório criado: $RECORDINGS_DIR"
echo ""

# Função para gravar demonstração
record_demonstration() {
    local title="$1"
    local description="$2"
    local duration="$3"
    local output_file="$RECORDINGS_DIR/${title//[^a-zA-Z0-9]/_}.mp4"
    
    echo "🎬 Iniciando gravação: $title"
    echo "📝 Descrição: $description"
    echo "⏱️ Duração: $duration segundos"
    echo ""
    
    # Gravar tela usando ffmpeg (macOS)
    if [[ "$RECORDING_METHOD" == "macos" ]]; then
        echo "🎥 Iniciando gravação em 3 segundos..."
        echo "📋 Prepare-se para demonstrar:"
        echo "   - Acesso ao endpoint vulnerável"
        echo "   - Evidência da vulnerabilidade"
        echo "   - Dados expostos (sem informações sensíveis)"
        echo ""
        
        sleep 3
        
        # Gravar tela com áudio do sistema
        ffmpeg -f avfoundation \
               -i "1:none" \
               -framerate 30 \
               -video_size 1920x1080 \
               -c:v libx264 \
               -preset ultrafast \
               -crf 18 \
               -t "$duration" \
               "$output_file" &
        
        FFMPEG_PID=$!
        
        echo "🎥 Gravação iniciada! (PID: $FFMPEG_PID)"
        echo "⏱️ Aguardando $duration segundos..."
        
        # Aguardar tempo da gravação
        sleep "$duration"
        
        # Parar gravação
        kill $FFMPEG_PID 2>/dev/null
        wait $FFMPEG_PID 2>/dev/null
        
        echo "✅ Gravação finalizada: $output_file"
    fi
    
    echo ""
}

# Função para criar script de demonstração
create_demo_script() {
    local title="$1"
    local endpoint="$2"
    local domain="$3"
    
    local script_file="$RECORDINGS_DIR/demo_script_${title//[^a-zA-Z0-9]/_}.txt"
    
    cat > "$script_file" << EOF
# 🎬 Script de Demonstração - $title
# ======================================

## 📋 Preparação (30 segundos)
1. Abrir terminal
2. Navegar para diretório do projeto
3. Preparar comandos de teste

## 🎯 Demonstração Principal (2 minutos)

### Passo 1: Verificar Endpoint (30 segundos)
\`\`\`bash
# Teste de conectividade
curl -I "https://$domain$endpoint"
\`\`\`

### Passo 2: Acesso sem Autenticação (45 segundos)
\`\`\`bash
# Tentativa de acesso direto
curl -s "https://$domain$endpoint" \\
  -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)" \\
  -H "Accept: application/json"
\`\`\`

### Passo 3: Análise da Resposta (45 segundos)
- Mostrar status code 200
- Demonstrar dados expostos
- Explicar impacto da vulnerabilidade

## 🔐 Responsável Disclosure (30 segundos)
- Explicar que é teste autorizado
- Mostrar que não há dados sensíveis reais
- Demonstrar processo ético

## 📝 Pontos Importantes:
- ✅ Não mostrar dados reais de usuários
- ✅ Explicar contexto de bug bounty
- ✅ Demonstrar processo ético
- ✅ Mostrar evidência técnica clara
EOF

    echo "📝 Script criado: $script_file"
}

# Lista de demonstrações para gravar
declare -a demonstrations=(
    "IDOR_Transfer_History:Vulnerabilidade IDOR em Histórico de Transferências:180"
    "Auth_Bypass_Admin:Vulnerabilidade de Bypass de Autenticação Admin:180"
    "HTTP_Method_Override:Vulnerabilidade HTTP Method Override:180"
    "Data_Exposure:Exposição de Dados Sensíveis:180"
)

# Criar scripts de demonstração
echo "📝 Criando scripts de demonstração..."
for demo in "${demonstrations[@]}"; do
    title=$(echo "$demo" | cut -d':' -f1)
    description=$(echo "$demo" | cut -d':' -f2)
    duration=$(echo "$demo" | cut -d':' -f3)
    
    create_demo_script "$title" "/api/v1/transfer/history" "crypto.com"
done

# Gravar demonstrações
echo ""
echo "🎬 Iniciando gravações..."
echo ""

for demo in "${demonstrations[@]}"; do
    title=$(echo "$demo" | cut -d':' -f1)
    description=$(echo "$demo" | cut -d':' -f2)
    duration=$(echo "$demo" | cut -d':' -f3)
    
    record_demonstration "$title" "$description" "$duration"
    
    echo "⏸️ Pausa de 10 segundos entre gravações..."
    sleep 10
done

# Criar arquivo de instruções
cat > "$RECORDINGS_DIR/INSTRUCOES_GRAVACAO.md" << 'EOF'
# 🎥 Instruções para Gravação - HackerOne

## 📋 Preparação

### 1. Configuração do Ambiente
- Terminal limpo e organizado
- Navegador aberto para demonstração web
- Ferramentas de teste preparadas

### 2. Script de Demonstração
- Seguir roteiro criado para cada vulnerabilidade
- Manter foco na evidência técnica
- Explicar impacto de forma clara

## 🎯 Demonstração Real

### Passo 1: Contexto (30 segundos)
```
"Olá, sou Thyago Aguiar, pesquisador de segurança.
Estou demonstrando vulnerabilidades descobertas no programa
de bug bounty do Crypto.com, seguindo as melhores práticas
de responsible disclosure."
```

### Passo 2: Evidência Técnica (2 minutos)
- Mostrar endpoint vulnerável
- Executar teste de acesso
- Demonstrar dados expostos
- Explicar impacto da vulnerabilidade

### Passo 3: Responsável Disclosure (30 segundos)
```
"Esta demonstração foi realizada em ambiente controlado,
sem acesso a dados reais de usuários, seguindo as diretrizes
do programa de bug bounty."
```

## 📹 Configurações de Gravação

### Resolução: 1920x1080
### Frame Rate: 30 FPS
### Codec: H.264
### Qualidade: CRF 18 (alta qualidade)

## 🎬 Roteiro de Gravação

### Demonstração 1: IDOR Transfer History
1. Abrir terminal
2. Executar curl para endpoint
3. Mostrar resposta 200 OK
4. Explicar dados expostos
5. Demonstrar impacto

### Demonstração 2: Auth Bypass Admin
1. Mostrar tentativa de acesso admin
2. Demonstrar bypass de autenticação
3. Explicar riscos de segurança
4. Mostrar evidência técnica

### Demonstração 3: HTTP Method Override
1. Demonstrar override de método HTTP
2. Mostrar comportamento inesperado
3. Explicar implicações de segurança
4. Evidenciar vulnerabilidade

### Demonstração 4: Data Exposure
1. Mostrar dados sensíveis expostos
2. Explicar violação de privacidade
3. Demonstrar impacto em compliance
4. Evidenciar necessidade de correção

## 🔐 Pontos Importantes

### ✅ Fazer:
- Explicar contexto de bug bounty
- Demonstrar processo ético
- Mostrar evidência técnica clara
- Explicar impacto da vulnerabilidade
- Manter foco profissional

### ❌ Não Fazer:
- Mostrar dados reais de usuários
- Executar ataques maliciosos
- Violar termos de uso
- Comprometer sistemas
- Expor informações sensíveis

## 📤 Submissão para HackerOne

### 1. Preparar Vídeos
- Comprimir para tamanho adequado
- Verificar qualidade de áudio/vídeo
- Adicionar legendas se necessário

### 2. Criar Report
- Incluir link para vídeos
- Explicar contexto da gravação
- Demonstrar processo ético

### 3. Submeter
- Anexar vídeos ao report
- Incluir evidências técnicas
- Seguir formato solicitado
EOF

# Criar script de compressão
cat > "$RECORDINGS_DIR/comprimir_videos.sh" << 'EOF'
#!/bin/bash
# Comprimir vídeos para submissão

echo "🎬 Comprimindo vídeos para HackerOne..."
echo ""

for video in *.mp4; do
    if [[ -f "$video" ]]; then
        echo "📹 Comprimindo: $video"
        
        # Comprimir mantendo qualidade
        ffmpeg -i "$video" \
               -c:v libx264 \
               -preset medium \
               -crf 23 \
               -c:a aac \
               -b:a 128k \
               "compressed_$video"
        
        echo "✅ Compressão concluída: compressed_$video"
        echo ""
    fi
done

echo "🎉 Todos os vídeos foram comprimidos!"
echo "📁 Arquivos prontos para submissão:"
ls -la compressed_*.mp4
EOF

chmod +x "$RECORDINGS_DIR/comprimir_videos.sh"

echo ""
echo "🎉 GRAVAÇÕES PREPARADAS COM SUCESSO!"
echo "===================================="
echo ""
echo "📁 Diretório: $RECORDINGS_DIR"
echo "📝 Scripts criados:"
ls -la "$RECORDINGS_DIR"/*.txt
echo ""
echo "🎬 Próximos passos:"
echo "1. Revisar scripts de demonstração"
echo "2. Preparar ambiente de gravação"
echo "3. Executar gravações seguindo roteiro"
echo "4. Comprimir vídeos para submissão"
echo "5. Anexar ao report da HackerOne"
echo ""
echo "📋 Instruções detalhadas em: $RECORDINGS_DIR/INSTRUCOES_GRAVACAO.md"
echo ""
echo "🚀 Para iniciar gravação manual:"
echo "   ffmpeg -f avfoundation -i '1:none' -framerate 30 -video_size 1920x1080 -c:v libx264 -preset ultrafast -crf 18 output.mp4"
