# Home Server Management

# Default recipe - show available commands
default:
    @just --list

# Build the system configuration
build:
    nixos-rebuild build --flake .#homeserver

# Deploy to the server (build locally, push closure, activate with magic rollback)
deploy:
    deploy .#homeserver

# Push and evaluate the activation on the server without switching to it
deploy-dry:
    deploy .#homeserver --dry-activate

# Deploy, but only make the config active from the next boot
deploy-boot:
    deploy .#homeserver --boot

# Deploy prompting for the sudo password; needed before the NOPASSWD rule is live
deploy-interactive:
    deploy .#homeserver --interactive-sudo true

# Roll the server back to its previous system generation
rollback:
    ssh -t homeserver "sudo nix-env --rollback -p /nix/var/nix/profiles/system && sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch"

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

# Clean up old generations on the server (keeps last 30 days)
clean:
    ssh -t homeserver "sudo nix-collect-garbage --delete-older-than 30d"

# List the server's system generations
generations:
    ssh homeserver "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system"

# Show disk usage of the server's nix store
disk-usage:
    ssh homeserver "du -sh /nix/store"

# Optimize the server's nix store
optimize:
    ssh -t homeserver "sudo nix-store --optimize"

# Closure diff: server's running system vs a fresh local build (needs its closure locally)
diff:
    nixos-rebuild build --flake .#homeserver
    nix store diff-closures "$(ssh homeserver readlink -f /run/current-system)" ./result

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
