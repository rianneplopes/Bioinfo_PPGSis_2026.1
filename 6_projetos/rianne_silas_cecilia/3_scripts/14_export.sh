#!/usr/bin/env bash

# Declara diretórios padrão
OUTPUT_DIR="../4_output/2_exported_tables"
QIIME_ART_DIR="../4_output/1_qiime_artifacts"
CORE_DIR="${QIIME_ART_DIR}/core_metrics_diversity"

# Cria estrutura de diretórios
mkdir -p "${OUTPUT_DIR}/1_alpha" "${OUTPUT_DIR}/2_beta/jaccard" "${OUTPUT_DIR}/2_beta/bray_curtis" "${OUTPUT_DIR}/3_taxonomy"

echo "Exportando dados de diversidade alfa..."

# Exporta observed_features para uma pasta temporária e renomeia
qiime tools export \
    --input-path ${CORE_DIR}/observed_features_vector.qza \
    --output-path ${OUTPUT_DIR}/1_alpha/tmp_obs/
mv ${OUTPUT_DIR}/1_alpha/tmp_obs/alpha-diversity.tsv ${OUTPUT_DIR}/1_alpha/observed_features.tsv
rm -rf ${OUTPUT_DIR}/1_alpha/tmp_obs/

# Exporta Shannon para uma pasta temporária e renomeia
qiime tools export \
    --input-path ${CORE_DIR}/shannon_vector.qza \
    --output-path ${OUTPUT_DIR}/1_alpha/tmp_sha/
mv ${OUTPUT_DIR}/1_alpha/tmp_sha/alpha-diversity.tsv ${OUTPUT_DIR}/1_alpha/shannon.tsv
rm -rf ${OUTPUT_DIR}/1_alpha/tmp_sha/

# Exporta os dados brutos da curva de rarefação alfa
qiime tools export \
    --input-path ${QIIME_ART_DIR}/alpha_rarefaction_report.qzv \
    --output-path ${OUTPUT_DIR}/1_alpha/tmp_rarefac/
mv ${OUTPUT_DIR}/1_alpha/tmp_rarefac/observed_features.csv ${OUTPUT_DIR}/1_alpha/rarefc_observed_features.csv
mv ${OUTPUT_DIR}/1_alpha/tmp_rarefac/shannon.csv ${OUTPUT_DIR}/1_alpha/rarefc_shannon.csv
mv ${OUTPUT_DIR}/1_alpha/tmp_rarefac/shannon.csv ${OUTPUT_DIR}/1_alpha/rarefc_shannon.csv

rm -rf ${OUTPUT_DIR}/1_alpha/tmp_rarefac/

echo "Exportando dados de diversidade beta (PCoA)..."

# Exporta Jaccard
qiime tools export \
    --input-path ${CORE_DIR}/jaccard_pcoa_results.qza \
    --output-path ${OUTPUT_DIR}/2_beta/jaccard/
mv ${OUTPUT_DIR}/2_beta/jaccard/ordination.txt ${OUTPUT_DIR}/2_beta/jaccard/jaccard_ordination.txt

# Exporta Bray-Curtis
qiime tools export \
    --input-path ${CORE_DIR}/bray_curtis_pcoa_results.qza \
    --output-path ${OUTPUT_DIR}/2_beta/bray_curtis/
mv ${OUTPUT_DIR}/2_beta/bray_curtis/ordination.txt ${OUTPUT_DIR}/2_beta/bray_curtis/bray_curtis_ordination.txt

echo "Exportando classificação taxonômica..."

# Exporta taxonomia (gera um arquivo chamado 'taxonomy.tsv')
qiime tools export \
    --input-path ${QIIME_ART_DIR}/taxonomy.qza \
    --output-path ${OUTPUT_DIR}/3_taxonomy/

# Exporta e converte tabela de ASVs usando pasta temporária isolada para evitar conflitos
qiime tools export \
    --input-path ${QIIME_ART_DIR}/table.qza \
    --output-path ${OUTPUT_DIR}/3_taxonomy/tmp_table/
biom convert \
    -i ${OUTPUT_DIR}/3_taxonomy/tmp_table/feature-table.biom \
    -o ${OUTPUT_DIR}/3_taxonomy/feature-table.tsv \
    --to-tsv

mv ${OUTPUT_DIR}/3_taxonomy/tmp_table/feature-table.biom ${OUTPUT_DIR}/3_taxonomy/tmp_table/feature_table.biom 
mv ${OUTPUT_DIR}/3_taxonomy/feature-table.tsv ${OUTPUT_DIR}/3_taxonomy/feature_table.tsv 

rm -rf ${OUTPUT_DIR}/3_taxonomy/tmp_table/

echo "Exportações concluídas com sucesso!"

