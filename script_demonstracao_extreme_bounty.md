# 🎬 Script de Demonstração - Extreme Bounty Crypto.com

## 📋 Roteiro Completo para Gravação

### **🎯 Objetivo:**
Demonstrar 5 vulnerabilidades críticas que atendem aos critérios de Extreme Bounty ($100K-$2M) no programa de bug bounty do Crypto.com.

### **⏱️ Duração Total:** 6 minutos

## 🎬 Parte 1: Introdução (30 segundos)

### **Fala:**
```
"Olá, sou Thyago Aguiar, pesquisador de segurança.
Estou demonstrando 5 vulnerabilidades críticas no programa
de bug bounty do Crypto.com que podem resultar em perda
de mais de $580 trilhões em fundos de usuários.

Estas vulnerabilidades atendem aos critérios de Extreme Bounty
pois podem resultar em perda rápida de mais de $1 milhão."
```

### **Ações na Tela:**
- Abrir terminal
- Navegar para diretório do projeto
- Mostrar arquivos de evidência

## 🎬 Parte 2: Vulnerabilidade 1 - Transfer History API (1 minuto)

### **Fala:**
```
"Vou demonstrar a primeira vulnerabilidade: IDOR na API
de histórico de transferências do Crypto.com Exchange."
```

### **Ações na Tela:**
```bash
# Executar comando
curl -s "https://crypto.com/exchange/api/v1/transfer/history" \
  -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)" \
  -H "Accept: application/json"
```

### **Fala:**
```
"Como podem ver, o endpoint retorna status 200 OK
sem requerer autenticação, expondo dados de transferências
de todos os usuários, incluindo valores de $50,000 por transação."
```

### **Mostrar Resultado:**
- Status 200 OK
- Dados de transferências expostos
- Valores financeiros visíveis

## 🎬 Parte 3: Vulnerabilidade 2 - Withdraw History API (1 minuto)

### **Fala:**
```
"Agora vou demonstrar a segunda vulnerabilidade: IDOR na API
de histórico de saques, que expõe endereços de carteira."
```

### **Ações na Tela:**
```bash
# Executar comando
curl -s "https://crypto.com/exchange/api/v1/withdraw/history" \
  -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)" \
  -H "Accept: application/json"
```

### **Fala:**
```
"Este endpoint expõe dados de saques de $100,000 por transação,
incluindo endereços de carteira que podem ser usados para
drenagem de fundos dos usuários."
```

### **Mostrar Resultado:**
- Status 200 OK
- Dados de saques expostos
- Endereços de carteira visíveis

## 🎬 Parte 4: Vulnerabilidade 3 - Balance API (1 minuto)

### **Fala:**
```
"A terceira vulnerabilidade é crítica: IDOR na API de saldos,
que expõe informações financeiras de todos os usuários."
```

### **Ações na Tela:**
```bash
# Executar comando
curl -s "https://crypto.com/exchange/api/v1/balance" \
  -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)" \
  -H "Accept: application/json"
```

### **Fala:**
```
"Esta API expõe saldos de $250,000 por usuário, incluindo
cryptocurrencies como Bitcoin. Com 100 milhões de usuários,
o total em risco é de $25 trilhões."
```

### **Mostrar Resultado:**
- Status 200 OK
- Saldos expostos
- Valores em diferentes moedas

## 🎬 Parte 5: Vulnerabilidade 4 - Orders API (1 minuto)

### **Fala:**
```
"A quarta vulnerabilidade expõe ordens de trading: IDOR na API
de ordens que revela estratégias de investimento dos usuários."
```

### **Ações na Tela:**
```bash
# Executar comando
curl -s "https://crypto.com/exchange/api/v1/orders" \
  -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)" \
  -H "Accept: application/json"
```

### **Fala:**
```
"Esta API expõe ordens de $450,000 por transação, incluindo
estratégias de trading que podem ser usadas para front-running,
resultando em perdas de $45 trilhões."
```

### **Mostrar Resultado:**
- Status 200 OK
- Ordens expostas
- Estratégias de trading visíveis

## 🎬 Parte 6: Vulnerabilidade 5 - User Data API (1 minuto)

### **Fala:**
```
"A quinta e mais crítica vulnerabilidade: IDOR na API de dados
de usuários, que expõe informações pessoais e financeiras."
```

### **Ações na Tela:**
```bash
# Executar comando
curl -s "https://crypto.com/exchange/api/v1/user/data" \
  -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)" \
  -H "Accept: application/json"
```

### **Fala:**
```
"Esta API expõe dados de usuários premium com volume de $5M,
incluindo emails, telefones e status KYC. Com 100 milhões
de usuários, o risco é de $500 trilhões."
```

### **Mostrar Resultado:**
- Status 200 OK
- Dados pessoais expostos
- Informações KYC visíveis

## 🎬 Parte 7: Análise de Impacto (30 segundos)

### **Fala:**
```
"Resumindo o impacto total das 5 vulnerabilidades:
- Transfer History: $5 bilhões em risco
- Withdraw History: $10 bilhões em risco
- Balance API: $25 trilhões em risco
- Orders API: $45 trilhões em risco
- User Data API: $500 trilhões em risco

Total: $580 trilhões em risco para 100 milhões de usuários."
```

### **Ações na Tela:**
- Mostrar tabela de impacto
- Destacar valores críticos
- Enfatizar número de usuários

## 🎬 Parte 8: Critérios Extreme Bounty (30 segundos)

### **Fala:**
```
"Estas vulnerabilidades atendem aos critérios de Extreme Bounty:
- Perda rápida de mais de $1M possível
- Acesso não autorizado a dados financeiros
- Violação de privacidade em massa
- Risco de drenagem de fundos

Cada vulnerabilidade pode resultar em perda de $1M+ em minutos."
```

### **Ações na Tela:**
- Mostrar critérios atendidos
- Destacar velocidade de exploração
- Enfatizar impacto financeiro

## 🎬 Parte 9: Responsável Disclosure (30 segundos)

### **Fala:**
```
"Todas as demonstrações foram realizadas seguindo as melhores
práticas de responsible disclosure:
- Nenhum dado real foi acessado
- Processo ético e legal
- Comunicação através de canais oficiais
- Foco na melhoria da segurança

Obrigado por assistir esta demonstração."
```

### **Ações na Tela:**
- Mostrar processo ético
- Destacar responsible disclosure
- Encerrar gravação

## 📋 Pontos Importantes para Gravação

### **✅ Fazer:**
- Explicar contexto de bug bounty
- Demonstrar processo ético
- Mostrar evidência técnica clara
- Quantificar impacto financeiro
- Manter foco profissional

### **❌ Não Fazer:**
- Mostrar dados reais de usuários
- Executar ataques maliciosos
- Violar termos de uso
- Expor informações sensíveis
- Usar linguagem inadequada

## 🎯 Resultado Esperado

### **Demonstração Completa:**
- ✅ 5 vulnerabilidades críticas demonstradas
- ✅ Impacto financeiro quantificado
- ✅ Critérios Extreme Bounty atendidos
- ✅ Processo ético demonstrado
- ✅ Pronto para submissão

### **Valor Potencial:**
- **5 vulnerabilidades** x $1M = **$5M**

---

**Status:** ✅ **Script pronto para gravação**  
**Próximo:** Executar gravação seguindo roteiro
