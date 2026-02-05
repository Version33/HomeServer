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

# Clean build artifacts
clean:
    rm -rf result

# Update flake inputs
update:
    nix flake update

# Format Nix files
format:
    nix fmt

# Check flake for issues
check:
    nix flake check

