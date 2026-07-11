#!/usr/bin/env bash

export TZ="UTC"

qiime metadata tabulate \
  --m-input-file ../4_output/1_qiime_artifacts/taxonomy.qza \
  --o-visualization ../4_output/1_qiime_artifacts/taxonomy.qzv

qiime taxa barplot \
  --i-table    ../4_output/1_qiime_artifacts/table.qza \
  --i-taxonomy ../4_output/1_qiime_artifacts/taxonomy.qza \
  --m-metadata-file ../2_metadata/sample_metadata.tsv \
  --o-visualization ../4_output/1_qiime_artifacts/taxonomy_barplot.qzv