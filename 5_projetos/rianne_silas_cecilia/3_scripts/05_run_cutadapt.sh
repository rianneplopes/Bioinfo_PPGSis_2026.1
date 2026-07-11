#!/usr/bin/env bash

export TZ="UTC"

qiime cutadapt trim-paired \
  --i-demultiplexed-sequences ../4_output/1_qiime_artifacts/demux.qza \
  --p-front-f GTCGGTAAAACTCGTGCCAGC \
  --p-front-r CATAGTGGGGTATCTAATCCCAGTTTG \
  --p-cores 4 \
  --p-match-read-wildcards \
  --o-trimmed-sequences ../4_output/1_qiime_artifacts/demux_trimmed.qza \
  --verbose > ../4_output/3_logs/cutadapt.log 2>&1


  # Primers MiFish-F e MiFish-R disponíveis em 10.1098/rsos.150088