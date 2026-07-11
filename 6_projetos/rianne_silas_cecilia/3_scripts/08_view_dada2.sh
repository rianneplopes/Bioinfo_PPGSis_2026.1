#!/usr/bin/env bash

export TZ="UTC"
OP_DIR="../4_output/1_qiime_artifacts/"

# Estatística do denoising
qiime metadata tabulate \
  --m-input-file ${OP_DIR}denoising_stats.qza \
  --o-visualization ${OP_DIR}denoising_stats.qzv

# Resumo da tabela de features (ASVs)
qiime feature-table summarize \
  --i-table ${OP_DIR}table.qza \
  --m-sample-metadata-file ../2_metadata/sample_metadata.tsv \
  --o-visualization ${OP_DIR}table.qzv

# Tabela das sequências das ASVs
qiime feature-table tabulate-seqs \
  --i-data ${OP_DIR}rep_seqs.qza \
  --o-visualization ${OP_DIR}rep_seqs.qzv