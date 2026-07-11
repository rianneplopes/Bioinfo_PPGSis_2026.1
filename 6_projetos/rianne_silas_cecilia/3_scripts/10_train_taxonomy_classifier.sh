#!/usr/bin/env bash

REF_DIR="../1_data/2_ref"
OP_DIR="../4_output/1_qiime_artifacts"

SEQS_QZA="${REF_DIR}/12S-seqs-derep-uniq.qza"
TAX_QZA="${REF_DIR}/12S-tax-derep-uniq.qza"
CLASSIFIER_QZA="${OP_DIR}/12S-classifier.qza"

export TZ="UTC"

qiime feature-classifier fit-classifier-naive-bayes \
    --i-reference-reads ${SEQS_QZA} \
    --i-reference-taxonomy ${TAX_QZA} \
    --o-classifier ${CLASSIFIER_QZA} \
    --verbose