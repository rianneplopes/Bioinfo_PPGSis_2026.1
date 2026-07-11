#!/usr/bin/env bash

RD_DIR=$(realpath "../1_data/1_raw")
MD_DIR="../2_metadata"
MANIFEST="${MD_DIR}/manifest.tsv"

printf "sample-id\tforward-absolute-filepath\treverse-absolute-filepath\n" > "$MANIFEST"

for RUN in DRR030421 DRR030422 DRR030423 DRR030424 \
           DRR030425 DRR030426 DRR030427 DRR030428
do
    printf "%s\t%s/%s_1.fastq.gz\t%s/%s_2.fastq.gz\n" \
        "$RUN" \
        "$RD_DIR" "$RUN" \
        "$RD_DIR" "$RUN" \
        >> "$MANIFEST"
done

echo "Arquivo manifest.tsv gerado com sucesso:"
cat "$MANIFEST"

MD_DIR="../2_metadata"
METADATA="${MD_DIR}/sample_metadata.tsv"

printf "sample-id\tgeo_local\tescala_local\tdata_coleta\tlatitude\tlongitude\n" > "$METADATA"

printf "#q2:types\tcategorical\tcategorical\tcategorical\tnumeric\tnumeric\n" >> "$METADATA"

for RUN in DRR030421 DRR030422 DRR030423 DRR030424 DRR030425 DRR030426 DRR030427 DRR030428
do
    if [[ "$RUN" =~ DRR03042[1-4] ]]; then
        LOCAL="Chura"
        ESCALA="Aquarium"
        LAT="26.69"
        LONG="127.88"
    else
        LOCAL="Bise"
        ESCALA="Coral_reefs"
        LAT="26.71"
        LONG="127.88"
    fi
    
    DATA="2014-06-03"

    printf "%s\t%s\t%s\t%s\t%s\t%s\n" \
        "$RUN" "$LOCAL" "$ESCALA" "$DATA" "$LAT" "$LONG" >> "$METADATA"
done

echo "Arquivo sample_metadata.tsv gerado com sucesso:"
cat "$METADATA"