#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log()     { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[ OK ]${NC} $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*"; }
step()    { echo -e "\n${CYAN}========== $* ==========${NC}"; }

trap 'error "Failed at line ${LINENO}: ${BASH_COMMAND}"' ERR

print_banner() {
    echo
    echo "=============================================="
    echo "       Server Deploy"
    echo "=============================================="
    echo " Docker + Nginx + Komari + 3x-ui + acme.sh"
    echo
}

require_root() {
    [[ $EUID -eq 0 ]] || { error "Run as root."; exit 1; }
    success "USER: root"
}

check_os() {
    source /etc/os-release
    case "${ID}" in
        ubuntu|debian) success "OS: ${PRETTY_NAME}" ;;
        *) error "Unsupported OS: ${ID}. Supported: Ubuntu/Debian"; exit 1 ;;
    esac
}

load_env() {
    local env_file="$1"
    [[ -f "$env_file" ]] || {
        error "Missing ${env_file}"
        error "Copy config/.env.example to config/.env first."
        exit 1
    }
    set -a
    source "$env_file"
    set +a
    success "Load env Success"
}
system_init() {
    step "System initialization"
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install -y ca-certificates curl wget gnupg git jq unzip tar socat openssl cron
    success "Base packages installed"
}
create_server_dirs() {
    step "Creating directories"
    mkdir -p "${INSTALL_DIR}"/{nginx/{conf.d,ssl,www,logs},komari/data,backup,scripts}
    success "Created ${INSTALL_DIR}"
}
