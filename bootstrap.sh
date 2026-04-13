#!/usr/bin/env bash
set -Eeuo pipefail

trap 'echo "[dev-env bootstrap] Failed at line $LINENO" >&2' ERR

# DEFAULTS
BRANCH="master"
DRY_RUN=0

usage() {
    cat <<EOF
dev-env bootstrap
Usage: bootstrap.sh [--branch <name>] [--dry-run]
Options:
    --branch <name>  Use a different git branch (default: master)
    --dry-run        Show actions without executing
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -b|--branch) BRANCH="$2"; shift 2;;
        --dry-run) DRY_RUN=1; shift;;
        -h|--help) usage; exit 0;;
        *) echo "Unknown argument: $1" >&2; usage; exit 1;;
    esac
done

# Determine OS

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac
case $(uname -m) in
x86_64)
    BITS=64
    ;;
i*86)
    BITS=32
    ;;
*)
    BITS=?
    ;;
esac

# Install requirements

case $machine in
    Linux)
        case "$(lsb_release -ds 2>/dev/null || cat /etc/*release 2>/dev/null | head -n1 || uname -om)" in
            Manjaro*|Arch*)
                sudo pacman -S git --noconfirm --needed
                sudo pacman -S ansible --noconfirm --needed
                if [ ! -d ~/.ansible/plugins/modules/aur ]; then
                  git clone https://github.com/kewlfft/ansible-aur.git ~/.ansible/plugins/modules/aur
                fi
                TEMPLATE="ansible/playbooks/arch.yml"
                ;;
        esac
        ;;
    Mac)
        # Needed by some brew recipes 
        xcode-select --install
        INTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # we prefer to do this using the oh-my-zsh plugin, but we still need to add brew to the current shell
        # (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
        brew install git
        brew install ansible
        TEMPLATE="ansible/playbooks/macos.yml"
        ;;
    Cygwin)            exit 1;;
    MinGw)             exit 1;;
    UNKNOWN*)          exit 1
esac


# Bootstrap

if [ "$DRY_RUN" -eq 1 ]; then
    echo "[DRY-RUN] Would ensure git + ansible installed for $machine ($BITS-bit)";
    echo "[DRY-RUN] Would clone/update dev-env branch $BRANCH";
    echo "[DRY-RUN] Would run playbook template: $TEMPLATE";
    exit 0
fi

if [ ! -d ~/.dev-env ]; then
    echo "Cloning dev-env ($BRANCH)";
    git clone https://github.com/aserrallerios/dev-env.git ~/.dev-env
fi

cd ~/.dev-env
git checkout "$BRANCH" || true
git pull --ff-only || true

./run.sh "$TEMPLATE"
