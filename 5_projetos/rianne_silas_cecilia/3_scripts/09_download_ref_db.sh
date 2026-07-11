#!/usr/bin/env bash

REF_DIR="../1_data/2_ref"

URL_SEQS="https://github.com/aomlomics/mitohelper/raw/master/QIIME-compatible/12S-seqs-derep-uniq.qza"
URL_TAX="https://github.com/aomlomics/mitohelper/raw/master/QIIME-compatible/12S-tax-derep-uniq.qza"

SEQS_QZA="${REF_DIR}/12S-seqs-derep-uniq.qza"
TAX_QZA="${REF_DIR}/12S-tax-derep-uniq.qza"

echo "Baixando sequências de referência 12S..."
curl -L "$URL_SEQS" -o "$SEQS_QZA"

echo "Baixando taxonomia de referência 12S..."
curl -L "$URL_TAX" -o "$TAX_QZA"
