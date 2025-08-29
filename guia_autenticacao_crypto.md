# 🔐 Guia de Autenticação Crypto.com

## 📋 Passos para Obter Cookies de Autenticação

### 1. 🌐 Acessar Crypto.com
- Abra o Chrome
- Navegue para: `https://crypto.com/exchange`
- Faça login na sua conta

### 2. 🔍 Abrir DevTools
- Pressione `F12` ou `Cmd+Option+I` (Mac)
- Vá para a aba **Application**
- No painel esquerdo, expanda **Cookies**
- Clique em `https://crypto.com`

### 3. 📋 Copiar Cookies Importantes
Procure e copie estes cookies:
- `session`
- `auth_token`
- `access_token`
- `jwt_token`
- `user_token`
- `api_token`

### 4. 🔗 Formato dos Cookies
Cole no formato: `nome=valor; nome2=valor2`

Exemplo:
```
session=abc123; auth_token=xyz789; access_token=def456
```

## 🚀 Executar Bug Hunter

Após obter os cookies, execute:

```bash
python3 crypto_auth_hunter_simple.py
```

## 💰 Potencial de Descobertas

### Vulnerabilidades Autenticadas:
- **Transferências financeiras** ($500K - $2M)
- **Vazamento de dados PII** ($600K - $2M)
- **Business logic flaws** ($200K - $1.2M)
- **Smart contract issues** ($400K - $2M)

### APIs Testadas:
- `https://api.crypto.com/v1/user/profile`
- `https://api.crypto.com/v1/account/balance`
- `https://api.crypto.com/v1/wallet/addresses`
- `https://api.crypto.com/v1/trading/orders`
- `https://api.crypto.com/v1/transactions/history`
- `https://web.crypto.com/api/v1/user/profile`
- `https://exchange.crypto.com/api/v1/user/profile`
- `https://merchant.crypto.com/api/v1/user/profile`
- `https://developer.crypto.com/api/v1/user/profile`
- `https://app.mona.co/api/v1/user/profile`

## 🎯 Próximos Passos

1. **Obter cookies** seguindo o guia acima
2. **Executar o bug hunter** com autenticação
3. **Analisar descobertas** de valor extremo
4. **Desenvolver PoCs** para vulnerabilidades
5. **Submeter reports** para HackerOne

## 📊 Valor Total Potencial

**Estimativa:** $100K - $2M por vulnerabilidade descoberta

**Foco:** APIs autenticadas com dados sensíveis
