# Crypto.com — Diagnóstico dos arquivos enviados & como corrigir as chamadas

**Diagnóstico rápido**:
- `https___api_crypto_com_v2_public_get_trades.json`: resposta JSON com erro `Invalid instrument_name` (código 40004). Isso indica que a chamada V2 precisa do parâmetro `instrument_name` válido (ex.: `BTC_USDT`). 
- `https___crypto_com_api_v1_public_orderbook.json` e `https___crypto_com_api_v1_public_ticker.json`: retornaram **HTML 404** (página do site), sinal de **endpoint/base path incorretos** para a API de Exchange.

**Sugestão de correção (V2 / base `https://api.crypto.com/v2`)**:

- **Ticker (único instrumento):**
  ```bash
  curl -s 'https://api.crypto.com/v2/public/get-ticker?instrument_name=BTC_USDT'
  ```

- **Order Book:**
  ```bash
  curl -s 'https://api.crypto.com/v2/public/get-book?instrument_name=BTC_USDT&depth=10'
  ```

- **Trades recentes:**
  ```bash
  curl -s 'https://api.crypto.com/v2/public/get-trades?instrument_name=BTC_USDT'
  ```

> Dica: Se precisar descobrir nomes de instrumentos válidos, use `public/get-instruments` na mesma base V2.

**Fluxo recomendado**:
1. **Validar base e parâmetros** (usar `api.crypto.com/v2` + `instrument_name`).
2. **Salvar respostas JSON brutas** (ticker, book, trades).
3. **Processar e cruzar**: 
   - *Ticker*: último preço, variação, volume 24h.
   - *Book*: melhor bid/ask, spread absoluto e relativo, profundidade (somatório de quantidade por lado).
   - *Trades*: min/max/mediana no intervalo, volume agregado, side predominante.
4. **Gerar planilha** com aba por fonte e uma aba-mestra cruzada.
