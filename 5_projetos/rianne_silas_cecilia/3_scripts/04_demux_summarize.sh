#!/usr/bin/env bash

export TZ="UTC"

qiime demux summarize \
    --i-data ../4_output/1_qiime_artifacts/demux.qza \
    --o-visualization ../4_output/1_qiime_artifacts/demux.qzv