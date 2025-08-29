# 📤 Submissão HackerOne - Extreme Bounty Crypto.com

## 🎯 Informações da Submissão

**Programa:** Crypto.com Bug Bounty  
**Categoria:** Extreme Bounty  
**Pesquisador:** Thyago Aguiar  
**Data:** 29/08/2025  

## 📋 Resumo da Vulnerabilidade

Identificadas 5 vulnerabilidades IDOR críticas na API do Crypto.com Exchange que expõem dados financeiros sensíveis de usuários, incluindo:

- Histórico de transferências
- Endereços de carteira
- Saldos de contas
- Ordens de trading
- Dados pessoais

## 🎯 Impacto

- **Severidade:** Crítica
- **Valor estimado:** $5M
- **Usuários afetados:** Milhões
- **Dados expostos:** Financeiros e pessoais

## 📁 Evidências Anexadas

- Relatórios técnicos detalhados
- Scripts de reprodução
- Dados extraídos da API
- Capturas de tela
- Logs de execução

## 🔧 Passos para Reprodução

1. Executar scripts de teste
2. Verificar endpoints expostos
3. Analisar dados retornados
4. Confirmar exposição de informações

## 🛡️ Sugestões de Mitigação

1. Implementar autenticação adequada
2. Validar permissões de acesso
3. Implementar rate limiting
4. Revisar arquitetura de APIs

---
*Submissão preparada para envio oficial*
