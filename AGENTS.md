# Agent Guidelines for homeserver

## Build/Test Commands
- **Test**: `just test` (test configuration without deploying)
- **Format**: `just format` (format Nix files with `nixfmt-classic`)

## Code Style
- **Language**: Nix (NixOS configuration)
- **Formatting**: Use `nixfmt-classic` (run `just format` before committing)
- **Imports**: Group at top of file, ordered: hardware, modules, services
- **Module structure**: `{ config, pkgs, lib, ... }:` is the standard function signature
- **Indentation**: 2 spaces (enforced by nixfmt)
- **Strings**: Use double quotes for strings, `''` for multi-line strings in extraConfig blocks
- **Comments**: Use `#` for single-line comments; add documentation URLs for external services
- **Service ports**: Document default ports in comments (e.g., `# Jellyfin runs on port 8096`)
- **File organization**: Services in `nixos/modules/services/`, networking/system in `nixos/modules/`, home config in `nixos/modules/home/`
- **Naming**: Use lowercase with hyphens for module files (e.g., `home-assistant.nix`)
- **Error handling**: Nix has no try/catch; use `lib.mkIf` for conditional configuration
- **Module imports**: Services organized as directories should have `default.nix` (e.g., `services/home-assistant/default.nix`)
- **Firewall rules**: Add ports to `nixos/modules/services/caddy.nix` interface allowedTCPPorts for local network access
