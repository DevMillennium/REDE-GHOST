#!/usr/bin/env bash
set -euo pipefail

# ==== Config ====
BASE="https://api.crypto.com/exchange/v1"
UA="rede-ghost-data-dumper/1.0"
BOOK_DEPTH=50
CANDLES_TF=("M1" "M5" "H1" "D1")
COUNT_DEFAULT=150
SLEEP="0.20"

# ==== Datestamp & dirs ====
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
ROOT="data/${STAMP}"
mkdir -p "${ROOT}"/{raw,tickers,books,trades,candles,valuations,meta}

echo ">> Snapshot: ${STAMP}"
echo ">> Baixando instrumentos…"
curl -sS --compressed -A "$UA" "${BASE}/public/get-instruments" -o "${ROOT}/raw/instruments.json"
jq -r '.result.data[].symbol' "${ROOT}/raw/instruments.json" | sort -u > "${ROOT}/raw/instruments.txt"

echo ">> Baixando tickers (snapshot)…"
curl -sS --compressed -A "$UA" "${BASE}/public/get-tickers" -o "${ROOT}/tickers/all.json"

echo ">> Baixando risk params + announcements…"
curl -sS --compressed -A "$UA" "${BASE}/public/get-risk-parameters" -o "${ROOT}/meta/risk_parameters.json" || true
curl -sS --compressed -A "$UA" "${BASE}/public/get-announcements" -o "${ROOT}/meta/announcements.json" || true

# ---- Função: trades por faixa temporal (paginado) ----
fetch_trades_range () {
  local INST="$1"; local START_MS="$2"; local END_MS="$3"
  local OUT="${ROOT}/trades/${INST}_${START_MS}_${END_MS}.jsonl"
  : > "$OUT"
  echo ">> [${INST}] trades ${START_MS}..${END_MS} (paginado)…"
  while : ; do
    RESP="$(curl -sS --compressed -A "$UA" \
      "${BASE}/public/get-trades?instrument_name=${INST}&count=${COUNT_DEFAULT}&start_ts=${START_MS}&end_ts=${END_MS}")"
    echo "$RESP" >> "$OUT"
    LEN="$(jq -r '.result.data | length' <<<"$RESP")"
    [[ "$LEN" -eq 0 ]] && break
    MIN_T="$(jq -r '[.result.data[].t] | min // empty' <<<"$RESP")"
    [[ -z "$MIN_T" ]] && break
    END_MS="$MIN_T"
    sleep "$SLEEP"
  done
}

# ==== Loop principal por instrumento ====
TOTAL_INST=$(wc -l < "${ROOT}/raw/instruments.txt" | tr -d ' ')
N=0
while read -r I; do
  [[ -z "$I" ]] && continue
  N=$((N+1))
  echo ">> (${N}/${TOTAL_INST}) ${I}"

  curl -sS --compressed -A "$UA" \
    "${BASE}/public/get-book?instrument_name=${I}&depth=${BOOK_DEPTH}" \
    -o "${ROOT}/books/${I}_d${BOOK_DEPTH}.json"
  sleep "$SLEEP"

  curl -sS --compressed -A "$UA" \
    "${BASE}/public/get-trades?instrument_name=${I}&count=${COUNT_DEFAULT}" \
    -o "${ROOT}/trades/${I}_latest.json"
  sleep "$SLEEP"

  for TF in "${CANDLES_TF[@]}"; do
    curl -sS --compressed -A "$UA" \
      "${BASE}/public/get-candlestick?instrument_name=${I}&timeframe=${TF}&count=${COUNT_DEFAULT}" \
      -o "${ROOT}/candles/${I}_${TF}.json" || true
    sleep "$SLEEP"
  done
done < "${ROOT}/raw/instruments.txt"

# ==== Valuations úteis ====
for IDX in BTCUSD-INDEX ETHUSD-INDEX; do
  curl -sS --compressed -A "$UA" \
    "${BASE}/public/get-valuations?instrument_name=${IDX}&valuation_type=index_price&count=1" \
    -o "${ROOT}/valuations/${IDX}_index_price.json" || true
  sleep "$SLEEP"
done

for PERP in BTCUSD-PERP ETHUSD-PERP; do
  curl -sS --compressed -A "$UA" \
    "${BASE}/public/get-valuations?instrument_name=${PERP}&valuation_type=mark_price&count=1" \
    -o "${ROOT}/valuations/${PERP}_mark_price.json" || true
  sleep "$SLEEP"
  curl -sS --compressed -A "$UA" \
    "${BASE}/public/get-valuations?instrument_name=${PERP}&valuation_type=funding_hist&count=${COUNT_DEFAULT}" \
    -o "${ROOT}/valuations/${PERP}_funding_hist.json" || true
  sleep "$SLEEP"
done

# ==== TRADES de 24h (BTC/ETH spot) ====
END_MS=$(( $(date -u +%s) * 1000 ))
if date -v-1d +%s >/dev/null 2>&1; then
  START_MS=$(( $(date -u -v-1d +%s) * 1000 ))   # macOS
else
  START_MS=$(( $(date -u -d '1 day ago' +%s) * 1000 ))  # Linux
fi

for I in BTC_USDT ETH_USDT; do
  fetch_trades_range "$I" "$START_MS" "$END_MS" || true
done

echo ">> Feito. Snapshot em: ${ROOT}"
