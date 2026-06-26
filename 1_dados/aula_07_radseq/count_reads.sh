for f in 2_demux/*.fq; do
    n=$(cat "$f" | wc -l)
    echo "$(basename $f .fq): $((n/4)) reads"
done
