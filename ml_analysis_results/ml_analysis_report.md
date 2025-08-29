# 🤖 Relatório de Machine Learning - Análise Crypto.com (Versão Final)

**Data:** 2025-08-29T06:27:07.893526
**Pesquisador:** Thyago Aguiar
**Alvo:** Crypto.com Exchange API

## 📊 Resumo Executivo

- **Total de registros analisados:** 25
- **Vulnerabilidades detectadas:** 13
- **Anomalias identificadas:** 3
- **Clusters encontrados:** 3
- **Score de risco:** 100.0%

## 🎯 Análise de Vulnerabilidades

### Endpoints de Alto Risco:

- **Unknown**
  - Probabilidade: 94.00%
  - Tamanho: 171 bytes

- **Unknown**
  - Probabilidade: 100.00%
  - Tamanho: 185 bytes

- **Unknown**
  - Probabilidade: 100.00%
  - Tamanho: 185 bytes

- **Unknown**
  - Probabilidade: 99.00%
  - Tamanho: 185 bytes

- **Unknown**
  - Probabilidade: 100.00%
  - Tamanho: 165 bytes

## 💰 Análise Financeira

- **Total de pares:** 866
- **Volume total:** $5,725,700,624
- **Pares de alto valor:** 54

## 🚨 Recomendações

### Security (high)
Identificadas 13 vulnerabilidades potenciais que requerem investigação imediata

### Monitoring (medium)
Detectados 3 padrões anômalos que merecem atenção

### Financial (high)
Alto risco financeiro detectado (Score: 100.0%) - Priorizar análise

### General (medium)
Implementar monitoramento contínuo dos endpoints identificados

## 📈 Métricas de ML

### Distribuição de Features:
|       |      size |   has_result |   has_data |   data_length |   response_keys |   is_vulnerable |   has_200 |   has_404 |   has_301 |   has_error |   response_time |   anomaly_score |   vulnerability_probability |   predicted_vulnerable |   cluster |
|:------|----------:|-------------:|-----------:|--------------:|----------------:|----------------:|----------:|----------:|----------:|------------:|----------------:|----------------:|----------------------------:|-----------------------:|----------:|
| count |     25    |        25    |         25 |         25    |           25    |       25        | 25        | 25        | 25        |          25 |       25        |      25         |                   25        |              25        | 25        |
| mean  |   6482.28 |         0.04 |          0 |         34.64 |            0.16 |        0.52     |  0.48     |  0.16     |  0.32     |           0 |        0.801705 |       0.0764364 |                    0.5096   |               0.52     |  0.56     |
| std   |  31497    |         0.2  |          0 |        173.2  |            0.8  |        0.509902 |  0.509902 |  0.374166 |  0.476095 |           0 |        1.26444  |       0.0769037 |                    0.484678 |               0.509902 |  0.583095 |
| min   |    165    |         0    |          0 |          0    |            0    |        0        |  0        |  0        |  0        |           0 |        0        |      -0.225316  |                    0        |               0        |  0        |
| 25%   |    181    |         0    |          0 |          0    |            0    |        0        |  0        |  0        |  0        |           0 |        0.072102 |       0.0612065 |                    0.02     |               0        |  0        |
| 50%   |    184    |         0    |          0 |          0    |            0    |        1        |  0        |  0        |  0        |           0 |        0.084378 |       0.100284  |                    0.66     |               1        |  1        |
| 75%   |    187    |         0    |          0 |          0    |            0    |        1        |  1        |  0        |  1        |           0 |        0.407124 |       0.121886  |                    0.99     |               1        |  1        |
| max   | 157668    |         1    |          0 |        866    |            4    |        1        |  1        |  1        |  1        |           0 |        3.24608  |       0.142637  |                    1        |               1        |  2        |

---
*Relatório gerado automaticamente pelo Machine Learning Analyzer (Versão Final)*