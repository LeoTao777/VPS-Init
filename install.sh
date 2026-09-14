#!/bin/bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${ROOT_DIR}/modules/docker.sh"
source "${ROOT_DIR}/modules/system.sh"

main() {
    print_banner
    require_root
    check_os
}

main "$@"