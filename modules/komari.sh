#!/usr/bin/env bash

install_komari() {
    step "Deploying Komari"
    log "KOMARI_PORT=|${KOMARI_PORT}|"
    if command -v ss &> /dev/null; then
	    ss -tulpn | grep -q ":${KOMARI_PORT}" || true 
    elif command -v netstat &> /dev/null; then
            netstat -tulpn | grep -q ":${KOMARI_PORT}" || true
    else
	    warning "failed to found ss/netstat, skip "
    fi
    # Check if container exists
if docker ps -a --filter "name=^/${KOMARI_CONTAINER}$" | grep -q "${KOMARI_CONTAINER}"; then
    echo "Old container ${KOMARI_CONTAINER} found, skip creation"
    # Check if container is running, start it if stopped
    if ! docker ps --filter "name=^/${KOMARI_CONTAINER}$" | grep -q "${KOMARI_CONTAINER}"; then
        echo "Old container is stopped, executing docker start"
        docker start "${KOMARI_CONTAINER}"
    fi
else
    echo "No existing container found, creating new container..."
    mkdir -p "${KOMARI_DATA}"
    docker run -d \
      -p "${KOMARI_PORT}:${KOMARI_PORT}" \
      -v "$(pwd)/${KOMARI_DATA}:/app/data" \
      --name "${KOMARI_CONTAINER}" \
      --network "${DOCKER_NETWORK}" \
      --restart unless-stopped \
      ghcr.io/komari-monitor/komari:latest
fi 
    sleep 3
echo "Container logs:"
docker logs "${KOMARI_CONTAINER}"
}
