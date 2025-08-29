# 🛠️ Kit de Ferramentas de Hacking - Mac M3

Este kit foi configurado especificamente para o Mac M3 (Apple Silicon) e contém as principais ferramentas para bug hunting e pentesting.

## 📋 Ferramentas Instaladas

### 🔍 Reconhecimento e Descoberta
- **subfinder** - Enumeração passiva de subdomínios
- **httpx** - Sonda HTTP multiuso (status, tech, títulos, TLS)
- **katana** - Crawler headless para endpoints (SPA-friendly)
- **dnsx** - Toolkit DNS veloz para resolver/filtrar wildcard
- **naabu** - Port scanner rápido
- **amass** - Mapeamento profundo de ativos externos

### 🎯 Fuzzing e Testes
- **ffuf** - Fuzzing de paths, vhosts e parâmetros
- **arjun** - Descoberta de parâmetros ocultos
- **nuclei** - Scanner baseado em templates YAML

### 🔐 Análise de Segurança
- **gitleaks** - Detecção de secrets em repositórios
- **trufflehog** - Scanner de secrets em Git
- **mitmproxy** - Proxy HTTP(S) para interceptação
- **Wireshark** - Analisador de protocolos de rede

### 📚 Templates e Recursos
- **nuclei-templates** - Templates atualizados para o Nuclei
- **jwt_tool** - Ferramenta para análise e exploração de JWTs

## 🚀 Comandos Úteis

### Pipeline Básico de Reconhecimento
```bash
# 1. Encontrar subdomínios
subfinder -d exemplo.com

# 2. Verificar quais estão ativos
subfinder -d exemplo.com | httpx

# 3. Crawlear para encontrar endpoints
katana -u https://exemplo.com

# 4. Fuzzing de paths
ffuf -u https://exemplo.com/FUZZ -w /usr/share/wordlists/dirb/common.txt

# 5. Scan com Nuclei
nuclei -t nuclei-templates -u https://exemplo.com
```

### Descoberta de Parâmetros
```bash
# Encontrar parâmetros ocultos
arjun -u https://exemplo.com/api/endpoint

# Fuzzing de parâmetros
ffuf -u https://exemplo.com/api/endpoint?FUZZ=test -w wordlist.txt
```

### Análise de JWT
```bash
cd jwt_tool
python3 jwt_tool.py <seu_jwt_token>
```

## 📁 Estrutura de Arquivos

```
REDE-GHOST/
├── setup_hacking_tools.sh          # Script de verificação
├── README_FERRAMENTAS_HACKING.md   # Este arquivo
├── nuclei-templates/               # Templates do Nuclei
├── jwt_tool/                       # Ferramenta JWT
└── ag.133-autmt/                   # Seus projetos
```

## 🔧 Configuração Adicional

### Burp Suite
- Baixe o Burp Suite Community do site oficial
- Configure o proxy para 127.0.0.1:8080
- Instale certificados para interceptação HTTPS

### OWASP ZAP
- Baixe do site oficial da OWASP
- Alternativa open-source ao Burp Suite

### Insomnia/Postman
- Para testes de APIs REST/GraphQL
- Útil para IDOR e testes de autorização

## ⚠️ Importante

1. **Sempre use dentro do escopo autorizado** dos programas de bug bounty
2. **Respeite os termos de serviço** dos alvos
3. **Documente tudo** para relatórios claros
4. **Teste em ambiente controlado** primeiro

## 🎯 Dicas para Bug Hunting

### Priorize:
- **APIs mal protegidas** (IDOR, RCE, SQLi)
- **Configurações incorretas** (CORS, CSP, etc.)
- **Subdomínios esquecidos**
- **Parâmetros ocultos**

### Pipeline Recomendado:
1. Reconhecimento passivo (subfinder, amass)
2. Enumeração ativa (httpx, naabu)
3. Descoberta de conteúdo (katana, ffuf)
4. Análise de vulnerabilidades (nuclei, manual)
5. Validação e documentação

## 📞 Suporte

Para problemas ou dúvidas sobre as ferramentas, consulte:
- Documentação oficial de cada ferramenta
- Comunidades de bug hunting (HackerOne, Discord)
- GitHub dos projetos

---

**Lembre-se: Hacking ético é sobre melhorar a segurança, não causar danos! 🔒**
