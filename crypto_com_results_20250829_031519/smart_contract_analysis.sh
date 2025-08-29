#!/bin/bash
# Análise de Smart Contracts para Crypto.com

echo "🔍 Analisando smart contracts..."

# Contratos conhecidos do Crypto.com
CONTRACTS=(
    "0xfe18ae03741a5b84e39c295ac9c856ed7991c38e"
    "0x626E8036dab333b39Be2c9F55e8bE7C8F5C2F3A1"
    "0x8B396ddF906D552b2Fc4A8C5C4B4C4C4C4C4C4C4"
)

for contract in "${CONTRACTS[@]}"; do
    echo "   Analisando contrato: $contract"
    
    # Verificar se o contrato existe no Etherscan
    curl -s "https://api.etherscan.io/api?module=contract&action=getsourcecode&address=$contract" > "$RESULTS_DIR/contract_$contract.json"
    
    # Verificar transações recentes
    curl -s "https://api.etherscan.io/api?module=account&action=txlist&address=$contract&startblock=0&endblock=99999999&sort=desc" > "$RESULTS_DIR/tx_$contract.json"
    
    # Verificar eventos
    curl -s "https://api.etherscan.io/api?module=logs&action=getLogs&address=$contract&fromBlock=0&toBlock=latest" > "$RESULTS_DIR/events_$contract.json"
done

echo "✅ Análise de smart contracts concluída"
