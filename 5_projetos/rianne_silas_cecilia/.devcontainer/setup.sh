#!/usr/bin/env bash

# ________________________________________________________________________
# Fish diversity eDNA Metabarcoding - setup.sh
# Rianne Passos Lopes
# Maria Cecília Feitoza Gomes
# Silionamã Pereira Dantas
# Executado automaticamente após a criação do container (postCreateCommand)
# ________________________________________________________________________
set -euo pipefail

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'
log()  { echo -e "${CYAN}[QIIME2 AMPLICON]${RESET} $1"; }
ok()   { echo -e "${GREEN}[OK]${RESET} $1"; }
warn() { echo -e "${YELLOW}[AVISO]${RESET} $1"; }

echo ""
echo -e "${BOLD}╔════════════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${BOLD}║                  Fish diversity eDNA Metabarcoding                 ║${RESET}"
echo -e "${BOLD}║                      Configuração de ambiente                      ║${RESET}"
echo -e "${BOLD}╠════════════════════════════════════════════════════════════════════╣${RESET}"
echo -e "${BOLD}║                                                                    ║${RESET}"
echo -e "${BOLD}║                     |\   \\\\\\\\\\\\\__      o                             ║${RESET}"
echo -e "${BOLD}║                     | \_/    o \      o                            ║${RESET}"
echo -e "${BOLD}║                     > _   (( <_   oo                               ║${RESET}"
echo -e "${BOLD}║                     | / \__+___/                                   ║${RESET}"
echo -e "${BOLD}║                     |/     |/                                      ║${RESET}"
echo -e "${BOLD}║                                                                    ║${RESET}"
echo -e "${BOLD}╚════════════════════════════════════════════════════════════════════╝${RESET}"
echo ""

# ___ 1. Estrutura de projetos
log "Criando diretórios do projeto..."
mkdir -p 1_data/1_raw 1_data/2_ref 2_metadata 3_scripts 4_output 5_notebooks 6_report

# ___ 2. Miniforge3

# Verificar e instalar miniforge
CONDA_DIR="$HOME/miniforge3"
if [ ! -d "$CONDA_DIR" ]; then
    log "Instalando Miniforge3..."
    wget -q "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh" \
        -O /tmp/miniforge.sh
    bash /tmp/miniforge.sh -b -p "$CONDA_DIR"
    rm /tmp/miniforge.sh
    ok "Miniforge3 instalado com sucesso."
else
    ok "Miniforge3 já instalado."
fi

# Carregar conda e mamba para este ambiente
source "$CONDA_DIR/etc/profile.d/conda.sh"
source "$CONDA_DIR/etc/profile.d/mamba.sh"
export MAMBA_ROOT_PREFIX="$CONDA_DIR"
conda config --set auto_activate_base false

# Configurar .bashrc para sessões futuras (auto-ativa o ambiente correto)
if ! grep -q "miniforge3" "$HOME/.bashrc" 2>/dev/null; then
    cat >> "$HOME/.bashrc" << 'BASHRC'

# Conda/Mamba — MiFish eDNA Pipeline
source "$HOME/miniforge3/etc/profile.d/conda.sh"
source "$HOME/miniforge3/etc/profile.d/mamba.sh"
export MAMBA_ROOT_PREFIX="$HOME/miniforge3"
conda activate qiime2_amplicon
BASHRC
fi

# ___ 3. QIIME 2

if conda env list | grep -q "^qiime2_amplicon "; then
    warn "Ambiente 'qiime2_amplicon' já existe. Pulando criação..."
else
    QIIME2_URL="https://data.qiime2.org/distro/amplicon/qiime2-amplicon-2024.10-py310-linux-conda.yml"
    log "Baixando e instalando QIIME 2 Amplicon (~3 GB)..."
    wget -q "$QIIME2_URL" -O /tmp/qiime2.yml

    # Alterar o nome do ambiente
    sed -i 's/name: qiime2-amplicon/name: qiime2_amplicon/' /tmp/qiime2.yml
    
    # Criar o ambiente usando mamba
    mamba env create -n qiime2_amplicon -f /tmp/qiime2.yml -y
    rm /tmp/qiime2.yml
    ok "QIIME 2 instalado com sucesso."
    
    # Instalar ferramentas extras de Python e utilitários dentro do ambiente
    log "Instalando utilitários adicionais de Python (Jupyter, Pandas, Seaborn)..."
    mamba install -n qiime2_amplicon jupyterlab pandas seaborn matplotlib wget curl tree cutadapt pigz sra-tools -c bioconda -c conda-forge -y
    ok "Utilitários instalados com sucesso."
fi

# ___ 4. LaTex

log "Instalando dependências do LaTex..."

sudo apt-get update && sudo apt-get install -y \\
    texlive-latex-base texlive-latex-recommended \\
    texlive-fonts-recommended texlive-science \\
    texlive-latex-extra texlive-lang-portuguese
    
ok "Dependências do LaTex instalados com sucesso."
    
# ___ 5. .gitignore
log "Configurando .gitignore..."
if [ ! -f .gitignore ]; then
    cat << EOF > .gitignore
.DS_Store
*.qza
*.fastq.gz
*.html

EOF
    ok "Arquivo .gitignore criado com sucesso."
else
    warn ".gitignore já existe. Mantido sem alterações."
fi
# ___ 6. Mensagem final
echo ""
echo -e "${GREEN}${BOLD}╔══════════════════════════════════════════════════════════╗${RESET}"
echo -e "${GREEN}${BOLD}║                Ambiente pronto para uso!                 ║${RESET}"
echo -e "${GREEN}${BOLD}╚══════════════════════════════════════════════════════════╝${RESET}"
echo ""
echo -e "  O ambiente será ativado automaticamente ao abrir o terminal."
echo -e "  Caso necessário ativar manualmente: ${CYAN}conda activate qiime2_amplicon${RESET}"
echo ""