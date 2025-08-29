# 🚀 Bug Hunting Suite - Mac M3 + Machine Learning

Sistema completo de bug hunting otimizado para Mac M3 (Apple Silicon) com integração de Machine Learning para maximizar a eficiência e descoberta de vulnerabilidades.

## 🎯 Características Principais

### 🤖 Machine Learning Integrado
- **Predição de vulnerabilidades** usando Random Forest
- **Análise de características** automática de URLs
- **Priorização inteligente** de alvos
- **Aprendizado contínuo** com dados históricos
- **Execução paralela** otimizada

### ⚡ Performance Otimizada
- **Configurações específicas** para Apple Silicon
- **Rate limiting inteligente** para evitar detecção
- **Cache otimizado** para ferramentas
- **Threading paralelo** para máxima velocidade
- **Monitoramento em tempo real**

### 🔧 Ferramentas Integradas
- **nuclei** - Scanner de vulnerabilidades
- **subfinder** - Enumeração de subdomínios
- **httpx** - Sonda HTTP multiuso
- **ffuf** - Fuzzing de alta performance
- **katana** - Crawler headless
- **amass** - Mapeamento de ativos
- **Wireshark** - Análise de protocolos

## 📦 Instalação

### Pré-requisitos
- Mac M3 (Apple Silicon)
- Homebrew instalado
- Python 3.11+

### Instalação Automática
```bash
# Clone o repositório
git clone https://github.com/DevMillennium/REDE-GHOST.git
cd REDE-GHOST

# Execute a configuração completa
./setup_complete.sh
```

## 🚀 Uso Rápido

### Automação Completa
```bash
# Executar bug hunting completo em um domínio
./auto_hunt.sh exemplo.com
```

### Pipeline Manual
```bash
# 1. Reconhecimento
./pipeline_recon.sh exemplo.com

# 2. Scan de vulnerabilidades
./pipeline_scan.sh active_urls.txt

# 3. Análise com ML
./pipeline_ml.sh exemplo.com
```

### Machine Learning Direto
```bash
# Ativar ambiente ML
source ml_env/bin/activate

# Executar análise com ML
python3 ml_bug_hunter.py exemplo.com
```

## 📋 Scripts Disponíveis

### 🎯 Scripts Principais
- `auto_hunt.sh` - Automação completa
- `pipeline_recon.sh` - Reconhecimento otimizado
- `pipeline_scan.sh` - Scan de vulnerabilidades
- `pipeline_ml.sh` - Análise com ML

### 🔍 Scripts de Monitoramento
- `monitor_realtime.sh` - Monitor em tempo real
- `monitor_performance.sh` - Monitor de performance
- `admin_monitor.sh` - Monitor administrativo

### 🔧 Scripts de Configuração
- `setup_complete.sh` - Configuração completa
- `performance_optimizer.sh` - Otimização de performance
- `admin_setup.sh` - Configuração administrativa

### 💾 Scripts de Backup
- `backup_results.sh` - Backup de resultados
- `run_privileged.sh` - Execução com privilégios

## 🤖 Machine Learning

### Funcionalidades ML
- **Extração de características** automática
- **Predição de vulnerabilidade** por URL
- **Priorização inteligente** de alvos
- **Aprendizado contínuo** com resultados

### Arquivos ML
- `ml_bug_hunter.py` - Sistema principal de ML
- `bug_hunting_data.json` - Dados de treinamento
- `bug_hunting_model.pkl` - Modelo treinado
- `ml_bug_hunter.log` - Logs de execução

### Exemplo de Uso ML
```bash
# Análise simples
python3 ml_bug_hunter.py exemplo.com

# Múltiplos domínios em paralelo
python3 ml_bug_hunter.py dominio1.com dominio2.com dominio3.com

# Ver ajuda
python3 ml_bug_hunter.py --help
```

## 📊 Monitoramento

### Monitor em Tempo Real
```bash
./monitor_realtime.sh
```

### Monitor de Performance
```bash
./monitor_performance.sh
```

### Monitor Administrativo
```bash
./admin_monitor.sh
```

## 🔐 Permissões Administrativas

### Configuração de Privilégios
```bash
# Configurar permissões administrativas
sudo ./admin_setup.sh

# Executar ferramentas com privilégios
./run_privileged.sh nuclei -u https://exemplo.com
./run_privileged.sh subfinder -d exemplo.com
```

### Ferramentas com Privilégios
- nuclei
- subfinder
- httpx
- ffuf
- wireshark

## 📁 Estrutura de Arquivos

```
REDE-GHOST/
├── ml_bug_hunter.py              # Sistema de ML
├── setup_complete.sh             # Configuração completa
├── performance_optimizer.sh      # Otimização de performance
├── admin_setup.sh                # Configuração administrativa
├── auto_hunt.sh                  # Automação completa
├── pipeline_recon.sh             # Pipeline de reconhecimento
├── pipeline_scan.sh              # Pipeline de scan
├── pipeline_ml.sh                # Pipeline de ML
├── monitor_realtime.sh           # Monitor em tempo real
├── monitor_performance.sh        # Monitor de performance
├── admin_monitor.sh              # Monitor administrativo
├── backup_results.sh             # Backup de resultados
├── run_privileged.sh             # Execução privilegiada
├── ml_env/                       # Ambiente Python ML
├── nuclei-templates/             # Templates do Nuclei
├── jwt_tool/                     # Ferramenta JWT
├── .env_optimized                # Configurações otimizadas
└── README_FINAL.md               # Este arquivo
```

## 🎯 Pipeline Recomendado

### 1. Reconhecimento Passivo
```bash
./pipeline_recon.sh alvo.com
```

### 2. Análise com ML
```bash
./pipeline_ml.sh alvo.com
```

### 3. Scan de Vulnerabilidades
```bash
./pipeline_scan.sh active_urls.txt
```

### 4. Análise Manual
- Use Burp Suite ou OWASP ZAP
- Valide vulnerabilidades encontradas
- Documente resultados

## ⚠️ Importante

### Segurança
- **Sempre use dentro do escopo autorizado**
- **Respeite os termos de serviço** dos alvos
- **Documente todas as atividades**
- **Mantenha logs de execução**

### Performance
- **Monitore uso de recursos** em tempo real
- **Faça backup regular** dos resultados
- **Atualize templates** periodicamente
- **Otimize configurações** conforme necessário

### Ética
- **Hacking ético** é sobre melhorar a segurança
- **Não cause danos** aos sistemas
- **Reporte vulnerabilidades** de forma responsável
- **Siga as melhores práticas** da comunidade

## 🔄 Atualizações

### Manutenção Regular
```bash
# Atualizar templates do Nuclei
nuclei -update-templates

# Atualizar ferramentas
brew upgrade

# Atualizar ambiente Python
source ml_env/bin/activate
pip install --upgrade scikit-learn pandas numpy
```

### Backup e Versionamento
```bash
# Backup de resultados
./backup_results.sh

# Commit de mudanças
git add .
git commit -m "Atualização de resultados"
git push
```

## 📞 Suporte

### Documentação
- [Nuclei Templates](https://github.com/projectdiscovery/nuclei-templates)
- [Subfinder](https://github.com/projectdiscovery/subfinder)
- [httpx](https://github.com/projectdiscovery/httpx)
- [ffuf](https://github.com/ffuf/ffuf)

### Comunidade
- [HackerOne](https://hackerone.com)
- [Bugcrowd](https://bugcrowd.com)
- [Discord de Bug Hunting](https://discord.gg/bughunting)

---

**🚀 Seu ambiente está pronto para bug hunting otimizado com Machine Learning!**

*Desenvolvido especificamente para Mac M3 (Apple Silicon) com foco em performance e eficiência.*
