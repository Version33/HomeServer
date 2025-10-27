#!/usr/bin/env bash
# Quick start script for the Incus Server VM

set -e

echo "=== Incus Home Server VM ==="
echo ""

# Check if VM is built
if [ ! -d "result" ]; then
    echo "Building VM..."
    nix build .#vm
    echo ""
fi

echo "Starting VM with port forwarding:"
echo "  - Port 8080  -> HTTP (Caddy)"
echo "  - Port 8443  -> HTTPS (Caddy)"
echo "  - Port 9443  -> Incus Web UI"
echo "  - Port 2222  -> SSH (user: incus-admin, pass: changeme)"
echo ""
echo "Add to /etc/hosts:"
echo "  127.0.0.1 radarr.local jellyfin.local incus.local"
echo ""
echo "Access services at:"
echo "  - Radarr:      http://radarr.local:8080"
echo "  - Jellyfin:    http://jellyfin.local:8080"
echo "  - Incus UI:    https://localhost:9443"
echo ""
echo "Press Ctrl+C to stop the VM"
echo ""
echo "Starting VM..."
echo ""

# Port forwarding is already configured in configuration.nix
./result/bin/run-incus-server-vm
