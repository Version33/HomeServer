# Incus Server Management

# Default recipe - show available commands
default:
    @just --list

# Build the VM
build-vm:
    nix build .#vm

# Run the VM (builds if necessary)
run-vm: build-vm
    @echo "=== Incus Home Server VM ==="
    @echo ""
    @echo "Starting VM with port forwarding:"
    @echo "  - Port 8080  -> HTTP (Caddy)"
    @echo "  - Port 8443  -> HTTPS (Caddy)"
    @echo "  - Port 9443  -> Incus Web UI"
    @echo "  - Port 2222  -> SSH (user: incus-admin, pass: changeme)"
    @echo ""
    @echo "Add to /etc/hosts:"
    @echo "  127.0.0.1 qbittorrent.local radarr.local jellyfin.local incus.local"
    @echo ""
    @echo "Access services at:"
    @echo "  - QBitTorrent:  http://qbittorrent.local:8080"
    @echo "  - Radarr:       http://radarr.local:8080"
    @echo "  - Jellyfin:     http://jellyfin.local:8080"
    @echo "  - Incus UI:     https://localhost:9443"
    @echo ""
    @echo "Press Ctrl+C to stop the VM"
    @echo ""
    ./result/bin/run-incus-server-vm

# Build the system configuration (for deployment testing)
build-system:
    nixos-rebuild build --flake .#incus-server

# Deploy to actual hardware (USE WITH CAUTION)
deploy:
    @echo "WARNING: This will deploy to actual hardware!"
    @echo "Press Ctrl+C to cancel, or Enter to continue..."
    @read
    sudo nixos-rebuild switch --flake .#incus-server

# Test VM connectivity
test-connectivity:
    @./scripts/test-connectivity.sh

# Clean build artifacts
clean:
    rm -rf result
    rm -f incus-server.qcow2

# Update flake inputs
update:
    nix flake update

# Format Nix files
format:
    find nixos -name "*.nix" -exec nixfmt {} \;
    nixfmt flake.nix

# Check flake for issues
check:
    nix flake check

# SSH into the running VM
ssh-vm:
    ssh -p 2222 incus-admin@localhost

# Show container status (run inside VM or on deployed system)
container-status:
    incus list

# Reset all containers (run inside VM or on deployed system)
container-reset:
    incus-container-reset

# Open Incus UI in browser
open-incus:
    xdg-open https://localhost:9443

# Open all service UIs in browser
open-all: open-incus
    xdg-open http://qbittorrent.local:8080
    xdg-open http://radarr.local:8080
    xdg-open http://jellyfin.local:8080

# Development: rebuild and run VM quickly
dev: build-vm run-vm
