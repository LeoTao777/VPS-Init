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
create_docker_network() {
    step "Creating Docker network"

    if docker network inspect "${DOCKER_NETWORK}" >/dev/null 2>&1; then
        success "Network exists: ${DOCKER_NETWORK}"
    else
        docker network create "${DOCKER_NETWORK}"
        success "Network created: ${DOCKER_NETWORK}"
    fi
}
