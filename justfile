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
    ssh -t homeserver "cd ~/Git/homeserver; git pull; sudo nixos-rebuild switch --flake ~/Git/homeserver"

# Update flake inputs
update:
    nix flake update

# Format Nix files
format:
    nix fmt

# Lint Nix code with statix
check:
    statix check .

# Find unused code
deadcode:
    deadnix .

# Check flake for issues
flake-check:
    nix flake check

# Show flake metadata
flake-info:
    nix flake metadata

# Show what would be built/downloaded
dry-run:
    nixos-rebuild dry-build --flake .#homeserver

# Clean up old generations (keeps last 30 days)
clean:
    sudo nix-collect-garbage --delete-older-than 30d
    sudo nixos-rebuild switch --flake .#homeserver

# List all generations
generations:
    sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Show disk usage of nix store
disk-usage:
    du -sh /nix/store

# Optimize nix store
optimize:
    sudo nix-store --optimize

# Show closure diff between current and new build
diff:
    nixos-rebuild build --flake .#homeserver
    nix store diff-closures /run/current-system ./result

# Search for a package
search PACKAGE:
    nix search nixpkgs {{PACKAGE}}

# Enter development shell
dev:
    nix develop

# Regenerate flake.nix from modules/flake.nix
write-flake:
    nix run .#write-flake

# Git commit with conventional message
commit MESSAGE:
    git add .
    git commit -m "{{MESSAGE}}"
