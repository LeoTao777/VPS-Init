#!/usr/bin/env bash

install_docker() {
    step "Installing Docker"

    if command -v docker >/dev/null 2>&1; then
        success "Docker already installed: $(docker --version)"
    else
        curl -fsSL https://get.docker.com | sh
        success "Docker installed"
    fi

    systemctl enable --now docker
    docker compose version >/dev/null 2>&1 || {
        error "Docker Compose plugin is unavailable"
        exit 1
    }
    success "Docker Compose available"
}
