#!/bin/bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${ROOT_DIR}/modules/docker.sh"
source "${ROOT_DIR}/modules/system.sh"
source "${ROOT_DIR}/modules/komari.sh"
main() {
    print_banner
    require_root
    check_os
    load_env "${ROOT_DIR}/config/.env"

    ##system_init
    ##install_docker
    ##create_server_dirs
    create_docker_network
    install_komari
}

main "$@"
