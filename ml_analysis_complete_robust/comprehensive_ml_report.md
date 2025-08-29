# 🤖 Relatório Abrangente - Machine Learning Crypto.com (Robusto)

**Data:** 2025-08-29T08:00:39.004867
**Pesquisador:** Thyago Aguiar
**Alvo:** Crypto.com Exchange (Dados Reais Completos)

## 📊 Resumo Executivo

- **Total de features analisadas:** 1731
- **Vulnerabilidades detectadas:** 81
- **Anomalias identificadas:** 87
- **Clusters encontrados:** 5
- **Modelos treinados:** 4

## 💰 Análise Financeira Completa

- **Total de instrumentos:** 866
- **Volume total:** $5,876,674,547
- **Pares de alto volume:** 54
- **Pares voláteis:** 46

## 🎯 Insights de Machine Learning

### Instrumentos de Alto Risco:

- **CDCETH_USD**
  - Probabilidade: 100.00%
  - Tipo: order_book

- **PAXG_USDT**
  - Probabilidade: 99.50%
  - Tipo: order_book

- **MKR_USD**
  - Probabilidade: 97.00%
  - Tipo: order_book

- **BTCUSD-250926**
  - Probabilidade: 100.00%
  - Tipo: order_book

- **BTCUSD-251031**
  - Probabilidade: 100.00%
  - Tipo: order_book

- **BIFI_USD**
  - Probabilidade: 95.00%
  - Tipo: order_book

- **YFI_USD**
  - Probabilidade: 100.00%
  - Tipo: order_book

- **PAXG_USD**
  - Probabilidade: 99.50%
  - Tipo: order_book

- **BTCUSD-251226**
  - Probabilidade: 100.00%
  - Tipo: order_book

- **ETHUSD-260327**
  - Probabilidade: 100.00%
  - Tipo: order_book

### Análise de Clusters:

- **cluster_0**
  - Tamanho: 857
  - Taxa de vulnerabilidade: 2.33%
  - Taxa de anomalia: 4.67%

- **cluster_1**
  - Tamanho: 855
  - Taxa de vulnerabilidade: 5.85%
  - Taxa de anomalia: 3.39%

- **cluster_2**
  - Tamanho: 7
  - Taxa de vulnerabilidade: 100.00%
  - Taxa de anomalia: 100.00%

- **cluster_3**
  - Tamanho: 11
  - Taxa de vulnerabilidade: 36.36%
  - Taxa de anomalia: 100.00%

- **cluster_4**
  - Tamanho: 1
  - Taxa de vulnerabilidade: 0.00%
  - Taxa de anomalia: 0.00%

## 🚨 Recomendações Críticas

### Security (critical)
Identificadas 81 vulnerabilidades críticas em instrumentos financeiros
**Impacto:** Alto risco de manipulação de mercado

### Monitoring (high)
Detectados 87 padrões anômalos que indicam comportamento suspeito
**Impacto:** Possível manipulação ou falha de sistema

### Financial (critical)
Volume total de $5,876,674,547 representa risco sistêmico
**Impacto:** Exposição financeira massiva

## 📈 Métricas Detalhadas

### Distribuição de Features:
|       |   bid_count |   ask_count |       bid_volume |       ask_volume |    bid_price_avg |    ask_price_avg |          spread |   spread_pct |   bid_price_std |   ask_price_std |   depth |   is_vulnerable |          high |           low |            avg |           volume |      volume_usd |   change_pct |            bid |            ask |   open_interest |   volatility |   anomaly_score |     cluster |         pca_1 |          pca_2 |          pca_3 |   vulnerability_probability |   predicted_vulnerable |
|:------|------------:|------------:|-----------------:|-----------------:|-----------------:|-----------------:|----------------:|-------------:|----------------:|----------------:|--------:|----------------:|--------------:|--------------:|---------------:|-----------------:|----------------:|-------------:|---------------:|---------------:|----------------:|-------------:|----------------:|------------:|--------------:|---------------:|---------------:|----------------------------:|-----------------------:|
| count |    865      |    865      |    865           |    865           |    865           |    865           |   865           |  865         |   865           |   865           |     865 |    1731         |    866        |    866        |    866         |    866           |   866           |  866         |    866         |    866         |   866           |  866         |    1731         | 1731        | 1731          | 1731           | 1731           |                 1731        |           1731         |
| mean  |     34.1723 |     42.6936 |      7.8695e+09  |      6.62547e+09 |   1451.51        |   1566.36        |   114.852       |   92.2045    |    61.5256      |    76.2757      |      50 |       0.0467938 |   1556.3      |   1519.7      |   1525.17      |      1.66707e+10 |     6.786e+06   |   -0.0301954 |   1497.54      |   1498.67      |     2.74526e+08 |    0.0317161 |       0.11504   |    0.523397 |    6.5677e-17 |   -3.28385e-17 |   -2.62708e-16 |                    0.046632 |              0.0467938 |
| std   |     11.5582 |     10.0276 |      9.30075e+10 |      8.5968e+10  |  11900.3         |  12773.6         |  1172.65        |  152.593     |   760.54        |   906.261       |       0 |       0.211258  |  12755.6      |  12506.5      |  12525.6       |      3.20433e+11 |     7.19451e+07 |    0.0727143 |  12268.4       |  12276.9       |     4.45738e+09 |    0.043218  |       0.0653362 |    0.550251 |    2.3024     |    2.07009     |    1.79648     |                    0.208413 |              0.211258  |
| min   |      2      |      4      |      3.1007      |      3.6516      |      2.27977e-08 |      3.27492e-08 |     6.02345e-09 |    0.0278274 |     2.87388e-09 |     2.16033e-09 |      50 |       0         |      2.52e-10 |      2.52e-10 |      2.52e-10  |      0           |     0           |   -0.2294    |      0         |      3e-10     |     0           |    0         |      -0.30323   |    0        |   -1.12825    |   -0.899533    |   -6.34146     |                    0        |              0         |
| 25%   |     25      |     36      |  34702.8         |  30675.8         |      0.0287596   |      0.0474194   |     0.00689816  |   12.0856    |     0.00218564  |     0.00471362  |      50 |       0         |      0.03163  |      0.029657 |      0.0298558 |   4444.39        |  2306.67        |   -0.050975  |      0.0296702 |      0.0300732 |     0           |    0.0015875 |       0.117664  |    0        |   -0.537144   |   -0.419723    |   -1.53382     |                    0        |              0         |
| 50%   |     32      |     50      | 232481           | 215571           |      0.213396    |      0.346112    |     0.07518     |   26.0138    |     0.0150261   |     0.0632916   |      50 |       0         |      0.241736 |      0.2181   |      0.222075  |  46004.8         | 13550.5         |   -0.03415   |      0.219205  |      0.219575  |     0           |    0.013905  |       0.133681  |    1        |    0.0522086  |   -0.0399483   |    0.0871932   |                    0        |              0         |
| 75%   |     48      |     50      |      1.26206e+06 |      1.08605e+06 |      1.0552      |      1.67703     |     0.41648     |  116.652     |     0.092162    |     0.455352    |      50 |       0         |      1.2186   |      1.12428  |      1.13898   | 396178           | 64124.4         |   -0.014     |      1.13718   |      1.13728   |  2008.6         |    0.0546213 |       0.147589  |    1        |    0.0758813  |    0.0700817   |    1.77122     |                    0        |              0         |
| max   |     50      |     50      |      1.98933e+12 |      2.12833e+12 | 110163           | 122231           | 21899.7         | 1308.95      | 17713.8         | 23019.9         |      50 |       1         | 120644        | 120644        | 120644         |      9.01247e+12 |     1.44198e+09 |    0.8721    | 114416         | 114527         |     8.93404e+10 |    0.371434  |       0.15239   |    4        |   33.3715     |   53.8045      |    7.14885     |                    1        |              1         |

---
*Relatório gerado automaticamente pelo Machine Learning Analyzer Completo (Robusto)*