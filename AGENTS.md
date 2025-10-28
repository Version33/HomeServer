# Agent Guidelines for IncusServer

## Build/Test Commands
- Build: `just build` (builds NixOS configuration)
- Deploy: `just deploy` (applies configuration to system, requires sudo)
- Test: `just test` (test configuration without deploying)
- Format: `just format` (format all Nix files with nixfmt)
- Check: `just check` (validate flake)
- VM: `just build-vm && just run-vm` (test in VM)

## Code Style
- Language: Nix declarative configuration
- Formatter: `nixfmt-classic` (run via `just format`)
- Indentation: 2 spaces
- Style: Follow existing patterns in modules (see nixos/modules/)
- Imports: `{ config, pkgs, lib, ... }:` at top of each module
- Module structure: Import in configuration.nix, keep modules focused and single-purpose
- Service configs: Place in nixos/modules/services/, use NixOS service options
- Naming: Use descriptive names matching service purpose (e.g., jellyfin.nix, caddy.nix)
- Comments: Minimal, only for clarity on non-obvious configuration choices

## Architecture
- Pure NixOS services (no containers)
- Caddy reverse proxy routes to services by hostname
- Media group (GID 1000) for shared service access
- Data in /data/media and /data/downloads
