#!/bin/bash
# Testes de Business Logic para Crypto.com

echo "🔍 Testando cenários de business logic..."

# URLs para testar
URLS=(
    "https://web.crypto.com"
    "https://crypto.com/exchange"
    "https://merchant.crypto.com"
    "https://developer.crypto.com"
)

for url in "${URLS[@]}"; do
    echo "   Testando: $url"
    
    # Testar rate limiting
    for i in {1..10}; do
        curl -s -w "%{http_code}\n" -o /dev/null "$url/api/v1/price" &
    done
    wait
    
    # Testar autenticação
    curl -s -X POST "$url/api/v1/auth/login" -H "Content-Type: application/json" -d '{"email":"test@test.com","password":"test"}' > "$RESULTS_DIR/auth_test_$(echo $url | sed 's/[^a-zA-Z0-9]/_/g').json"
    
    # Testar endpoints de trading
    curl -s -X GET "$url/api/v1/trading/orders" -H "Authorization: Bearer test" > "$RESULTS_DIR/trading_test_$(echo $url | sed 's/[^a-zA-Z0-9]/_/g').json"
    
    # Testar endpoints de wallet
    curl -s -X GET "$url/api/v1/wallet/balance" -H "Authorization: Bearer test" > "$RESULTS_DIR/wallet_test_$(echo $url | sed 's/[^a-zA-Z0-9]/_/g').json"
done

echo "✅ Testes de business logic concluídos"
