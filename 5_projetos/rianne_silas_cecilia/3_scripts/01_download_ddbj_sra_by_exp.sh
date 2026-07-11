#!/usr/bin/env bash

# Definir diretório e variáveis
DR_DIR="../1_data/1_raw/"
BASE_URL="https://ddbj.nig.ac.jp/public/ddbj_database/dra/sra/ByExp/sra/DRX"
DRX="DRX027"

# Listar duplas EXP:RUN
RUNS=(
  "DRR030428:DRX027444" # Bise
  "DRR030427:DRX027443" # Bise
  "DRR030426:DRX027442" # Bise
  "DRR030425:DRX027441" # Bise
  "DRR030421:DRX027437" # Chura
  "DRR030422:DRX027438" # Chura
  "DRR030423:DRX027439" # Chura
  "DRR030424:DRX027440" # Chura
)

for item in "${RUNS[@]}"; do
    RUN="${item%%:*}"
    EXP="${item##*:}"
    
    echo "Baixando amostra ${RUN}..."

    # Baixar dados
    wget -c "${BASE_URL}/${DRX}/${EXP}/${RUN}/${RUN}.sra" \
        -P "$DR_DIR"

    # Extrair arquivos fastq
    fasterq-dump "${DR_DIR}${RUN}.sra" \
        -O "$DR_DIR" \
        --progress \
        --split-files

    # Compactar arquivos para leitura do QIIME2
    pigz "${DR_DIR}${RUN}"*.fastq

    # Renomear arquivos .fastqz
    if [ -f "${DR_DIR}${RUN}.sra_1.fastq.gz" ]; then
        mv "${DR_DIR}${RUN}.sra_1.fastq.gz" "${DR_DIR}${RUN}_1.fastq.gz"
        mv "${DR_DIR}${RUN}.sra_2.fastq.gz" "${DR_DIR}${RUN}_2.fastq.gz"
    fi

    # Remover .sra original
    rm "${DR_DIR}${RUN}.sra"
done

# Mensagem
echo "Arquivos gerados com sucesso em ${DR_DIR}:"
ls -lh "$DR_DIR"