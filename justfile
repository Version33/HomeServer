# Home Server Management

# Default recipe - show available commands
default:
    @just --list

# Build the system configuration
build:
    nixos-rebuild build --flake .#homeserver

# Deploy to the server
deploy:
    @echo "Deploying to home server..."
    sudo nixos-rebuild switch --flake .#homeserver

# Test the configuration without deploying
test:
    nixos-rebuild test --flake .#homeserver

# Build and switch in dry-run mode
dry-run:
    nixos-rebuild dry-build --flake .#homeserver

# Build the VM for testing
build-vm:
    nix build .#vm

# Run the VM (builds if necessary)
run-vm: build-vm
    @echo "=== Home Server VM ==="
    @echo ""
    @echo "Starting VM with port forwarding:"
    @echo "  - Port 8080  -> HTTP (Caddy)"
    @echo "  - Port 8443  -> HTTPS (Caddy)"
    @echo "  - Port 2222  -> SSH (user: admin, pass: test)"
    @echo ""
    @echo "Add to /etc/hosts:"
    @echo "  127.0.0.1 qbittorrent.local radarr.local sonarr.local prowlarr.local jellyfin.local jellyseerr.local"
    @echo ""
    @echo "Access services at:"
    @echo "  - QBitTorrent:  http://qbittorrent.local:8080"
    @echo "  - Radarr:       http://radarr.local:8080"
    @echo "  - Sonarr:       http://sonarr.local:8080"
    @echo "  - Prowlarr:     http://prowlarr.local:8080"
    @echo "  - Jellyfin:     http://jellyfin.local:8080"
    @echo "  - Jellyseerr:   http://jellyseerr.local:8080"
    @echo ""
    @echo "Press Ctrl+C to stop the VM"
    @echo ""
    ./result/bin/run-homeserver-vm

# SSH into the running VM
ssh-vm:
    ssh -p 2222 admin@localhost

# Clean build artifacts
clean:
    rm -rf result

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

# Show status of media services
status:
    systemctl status radarr sonarr prowlarr jellyfin jellyseerr qbittorrent caddy

# Restart all media services
restart:
    sudo systemctl restart radarr sonarr prowlarr jellyfin jellyseerr qbittorrent caddy

# View logs for all media services
logs:
    journalctl -u radarr -u sonarr -u prowlarr -u jellyfin -u jellyseerr -u qbittorrent -u caddy -f

# Open all service UIs in browser
open:
    @echo "Add to /etc/hosts: 127.0.0.1 qbittorrent.local radarr.local sonarr.local prowlarr.local jellyfin.local jellyseerr.local"
    xdg-open http://qbittorrent.local
    xdg-open http://radarr.local
    xdg-open http://sonarr.local
    xdg-open http://prowlarr.local
    xdg-open http://jellyfin.local
    xdg-open http://jellyseerr.local
