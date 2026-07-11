#!/usr/bin/env bash

export TZ="UTC"

REF_DIR="../1_data/2_ref"
OP_DIR="../4_output/1_qiime_artifacts"

CLASSIFIER_QZA="${OP_DIR}/12S-classifier.qza"
REP_SEQS="${OP_DIR}/rep_seqs.qza"

qiime feature-classifier classify-sklearn \
    --i-classifier "${CLASSIFIER_QZA}" \
    --i-reads "${REP_SEQS}" \
    --p-n-jobs 4 \
    --o-classification "${OP_DIR}/taxonomy.qza" \
    --verbose