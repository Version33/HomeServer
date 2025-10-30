# Agent Guidelines for homeserver

## Project Overview
This is a NixOS home server configuration managing various services including media streaming, home automation, and networking. When changing any config make sure it builds with no errors with `just build`.

### Key Files
- **flake.nix**: Flake configuration with inputs (nixpkgs, nixarr, home-manager) and outputs (nixosConfigurations, devShells)
- **nixos/configuration.nix**: Main system configuration - imports all modules, defines boot, users, packages, and system settings
- **nixos/hardware-configuration.nix**: Auto-generated hardware-specific configuration
- **nixos/modules/networking.nix**: Network configuration using systemd-networkd and nftables firewall
- **nixos/modules/services/**: Service modules for applications (nixarr, caddy, home-assistant, minecraft, etc.)
- **nixos/modules/services/caddy.nix**: Reverse proxy configuration for web services (jellyfin, seerr, hass) and firewall rules for local network access
- **nixos/modules/home/**: Home Manager configuration for user environment (nushell, etc.)
- **justfile**: Command runner recipes for common tasks (build, deploy, test, format, check)

## Build/Test Commands
- **Check**: `just check` (check flake)
- **Build**: `just build` (build configuration)
- **Format**: `just format` (format Nix files with `nixfmt-classic`)

## Services & Modules

### System Modules
- **networking.nix**: systemd-networkd configuration, nftables firewall, DHCP on enp* interface, allows SSH (22), HTTP (80), HTTPS (443)

### Service Modules

#### Media Stack (nixarr)
- **nixarr.nix**: Media management suite with mediaDir at `/mnt/bigdisk/nixarr`
  - Jellyfin (8096): Media server
  - Radarr (7878): Movie management
  - Sonarr (8989): TV show management
  - Prowlarr (9696): Indexer management
  - Jellyseerr (5055): Request management
- **qbittorrent.nix**: Torrent client (8080) running through ProtonVPN, binds to `protonvpn` interface
- **flaresolverr.nix**: Cloudflare bypass proxy (8191) for indexers

#### Reverse Proxy & Security
- **caddy.nix**: Reverse proxy with SSL for jellyfin, seerr, and hass subdomains; local network firewall rules for all services
- **fail2ban.nix**: Intrusion prevention with SSH jail, incremental ban times (1h to 168h), ignores local network (192.168.1.0/24)

#### Home Automation
- **home-assistant/**: Home automation platform (8123)
  - default.nix: Core configuration with ESPHome, Z-Wave JS, Wyoming, ZHA, LG ThinQ integrations
  - hacs.nix: HACS custom component integration
  - bambu-lab.nix: Bambu Lab 3D printer integration
  - zwave-js.nix: Z-Wave device support
  - wyoming.nix: Voice assistant protocol support

#### Gaming
- **minecraft/**: Minecraft server (25565) using Purpur (PaperMC fork)
  - default.nix: Main entry point, imports all minecraft submodules (server, tools, plugins, datapacks)
  - server.nix: Server configuration with 4GB RAM, Purpur 1.21.10, RCON enabled (25575), paper.disableWorldSymlinkValidation for Nix store symlinks
  - tools.nix: Server management tools (mcrcon, mc-title script for sending formatted titles with color/style options)
  - plugins/default.nix: Imports all plugin modules
    - tabtps.nix: TabTPS v1.3.29 (TPS/MSPT display in tab menu)
    - backuper.nix: Backuper v3.4.5 (automated backup plugin)
    - purpur-extras.nix: PurpurExtras v1.36.0 (additional Purpur features)
  - datapacks/default.nix: Symlink configuration for datapacks via allowed_symlinks.txt (allows /nix/store paths)

#### System Management
- **cockpit.nix**: Web-based system administration (9090), allows unencrypted connections from local network
- **vpn.nix**: ProtonVPN WireGuard configuration for qBittorrent traffic only, includes `vpn-status` utility script

### Home Manager Modules
- **home/nushell.nix**: Nushell shell configuration with Minecraft RCON helper (`mc` command) and Starship prompt

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
