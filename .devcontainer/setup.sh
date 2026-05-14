#!/usr/bin/env bash
set -euo pipefail

echo "╔══════════════════════════════════════════════════════════╗"
echo "║   Bioinformática PPGSIS 2026 — Configuração do ambiente  ║"
echo "╚══════════════════════════════════════════════════════════╝"

# 1. Instala Miniforge (se ainda não existir)
if [ ! -d "$HOME/miniforge3" ]; then
    echo "[1/4] Instalando Miniforge3..."
    wget -q https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh -O /tmp/miniforge.sh
    bash /tmp/miniforge.sh -b -p "$HOME/miniforge3"
    rm /tmp/miniforge.sh
else
    echo "[1/4] Miniforge3 já presente — pulando"
fi

# 2. Carrega conda/mamba
source "$HOME/miniforge3/etc/profile.d/conda.sh"
source "$HOME/miniforge3/etc/profile.d/mamba.sh"
export MAMBA_ROOT_PREFIX="$HOME/miniforge3"

# Configura .bashrc
grep -q "miniforge3" "$HOME/.bashrc" || cat >> "$HOME/.bashrc" << 'BASHRC'
source "$HOME/miniforge3/etc/profile.d/conda.sh"
source "$HOME/miniforge3/etc/profile.d/mamba.sh"
export MAMBA_ROOT_PREFIX="$HOME/miniforge3"
conda activate bioinfo
BASHRC

# 3. Cria ambiente bioinfo
echo "[2/4] Criando ambiente bioinfo..."
if conda env list | grep -q "^bioinfo "; then
    echo "      Ambiente já existe — pulando"
else
    mamba env create -f .devcontainer/environment.yml
fi

# 4. Instala pacotes R via Bioconductor
echo "[3/4] Instalando pacotes R..."
conda run -n bioinfo Rscript -e "
  if (!requireNamespace('BiocManager', quietly=TRUE)) install.packages('BiocManager', repos='https://cloud.r-project.org')
  if (!requireNamespace('phyloseq', quietly=TRUE)) BiocManager::install('phyloseq', ask=FALSE)
  if (!requireNamespace('poppr', quietly=TRUE)) install.packages('poppr', repos='https://cloud.r-project.org')
" 2>/dev/null

# 5. InSilicoSeq
echo "[4/4] Instalando InSilicoSeq..."
conda run -n bioinfo pip install InSilicoSeq --quiet

echo ""
echo "✅ Pronto! Rode: conda activate bioinfo && bash .devcontainer/verificar.sh"
