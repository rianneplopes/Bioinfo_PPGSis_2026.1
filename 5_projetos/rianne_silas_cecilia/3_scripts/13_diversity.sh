#!/usr/bin/env bash

export TZ="UTC"

mkdir ../4_output/1_qiime_artifacts/core_metrics_diversity/

ARTIFACTS_DIR="../4_output/1_qiime_artifacts"
METADATA_DIR="../2_metadata"
CORE_METRICS_DIR="../4_output/1_qiime_artifacts/core_metrics_diversity"
LOG_DIR="../4_output/3_logs"

TABLE_QZA="${ARTIFACTS_DIR}/table.qza"
METADATA_TSV="${METADATA_DIR}/sample_metadata.tsv"

echo "Gerando a curva de rarefação..."

# Curva de rarefação alfa (para avaliar o esforço amostral)
qiime diversity alpha-rarefaction \
  --i-table ${TABLE_QZA} \
  --p-max-depth 100000 \
  --m-metadata-file ${METADATA_TSV} \
  --o-visualization ${ARTIFACTS_DIR}/alpha_rarefaction_report.qzv

echo "Calculando as matrizes de diversidade alfa e beta..."

# Métricas principais de diversidade biológica
## Alfa: observed_features (riqueza), shannon_vector, simpson_vector, evenness_vector
## Beta: jaccard_distance_matrix, bray_curtis_distance_matrix, matrizes de pcoa em .qzv
qiime diversity core-metrics \
  --i-table $TABLE_QZA \
  --p-sampling-depth 45000 \
  --m-metadata-file $METADATA_TSV \
  --output-dir $CORE_METRICS_DIR
### O valor de 45000 foi escolhido com base na frequência mínima de reads nas amostras

echo "Executando testes de hipótese para diversidade alfa..."

# Testes estatísticos de diversidade alfa (Kruskal-Wallsi)
## Riqueza de espécies (observed_features)
qiime diversity alpha-group-significance \
  --i-alpha-diversity ${CORE_METRICS_DIR}/observed_features_vector.qza \
  --m-metadata-file $METADATA_TSV \
  --o-visualization ${CORE_METRICS_DIR}/observed_features_significance.qzv

# Shannon (diversidade/equitabilidade)
qiime diversity alpha-group-significance \
  --i-alpha-diversity ${CORE_METRICS_DIR}/shannon_vector.qza \
  --m-metadata-file $METADATA_TSV \
  --o-visualization ${CORE_METRICS_DIR}/shannon_significance.qzv

echo "Executando testes de hipótese para diversidade beta..."

# Testes estatísticos de diversidade beta
## Jaccard (turnorver de espécies entre as escalas)
qiime diversity beta-group-significance \
  --i-distance-matrix ${CORE_METRICS_DIR}/jaccard_distance_matrix.qza \
  --m-metadata-file ${METADATA_TSV} \
  --m-metadata-column escala_local \
  --p-pairwise \
  --o-visualization ${CORE_METRICS_DIR}/jaccard_significance.qzv
  
  ## Bray-Curtis (estrutura de abundância relativa das leituras)

  qiime diversity beta-group-significance \
  --i-distance-matrix ${CORE_METRICS_DIR}/bray_curtis_distance_matrix.qza \
  --m-metadata-file ${METADATA_TSV} \
  --m-metadata-column escala_local \
  --p-pairwise \
  --o-visualization ${CORE_METRICS_DIR}/bray_curtis_significance.qzv

echo "Análises concluídas."