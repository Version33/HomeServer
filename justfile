# Home Server Management

# Default recipe - show available commands
default:
    @just --list

# Build the system configuration
build:
    nixos-rebuild build --flake .#homeserver

# Deploy to the server
deploy:
    @echo "Deploying to home server...";
    ssh -t homeserver "cd ~/Git/homeserver; git pull; sudo nixos-rebuild switch --flake ~/Git/homeserver"

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
