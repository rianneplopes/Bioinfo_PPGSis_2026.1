#!/usr/bin/env bash

export TZ="UTC"

qiime dada2 denoise-paired \
  --i-demultiplexed-seqs ../4_output/1_qiime_artifacts/demux_trimmed.qza \
  --p-trim-left-f 0 \
  --p-trim-left-r 0 \
  --p-trunc-len-f 120 \
  --p-trunc-len-r 115 \
  --p-chimera-method consensus \
  --o-table ../4_output/1_qiime_artifacts/table.qza \
  --o-representative-sequences ../4_output/1_qiime_artifacts/rep_seqs.qza \
  --o-denoising-stats ../4_output/1_qiime_artifacts/denoising_stats.qza \
  --p-n-threads 4