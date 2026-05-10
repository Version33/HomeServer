# Agent Guidelines

This document provides essential context for AI agents working in this NixOS homeserver configuration repository.

## 🚀 Essential Commands

Most operations are managed via `just`.

| Command | Description | Note |
|---|---|---|
| `just build` | Build configuration without switching | Uses `nixos-rebuild build` |
| `just deploy` | Deploy to the remote homeserver | SSH + git pull + switch |
| `just format` | Format all `.nix` files | Uses `nix fmt` (nixfmt under treefmt) |
| `just check` | Lint with `statix` | |
| `just deadcode` | Find unused code | Uses `deadnix` |
| `just flake-check` | Check flake for issues | `nix flake check` |
| `just update` | Update flake inputs | `nix flake update` |
| `just clean` | Garbage collect old generations | **Requires `sudo`** |
| `just diff` | Show closure diff | Compare current vs new build |
| `just dry-run` | Show what would be built | |
| `just write-flake` | Regenerate `flake.nix` from modules | After editing `modules/flake.nix` inputs |
| `just dev` | Enter development shell | `nix develop` |
| `just search <pkg>` | Search for a package | |

**Note**: `nixos-rebuild build` does **not** require `sudo`. Commands that modify the system state (`switch`, `test`, `boot`) **do** require `sudo`.

## 🏗️ Architecture & Organization

The repository uses `flake-parts` to manage a modular NixOS configuration targeting a remote server.

### Core Mechanism
- **Entry Point**: `flake.nix` (auto-generated from `modules/flake.nix` via `flake-file`)
- **Auto-import**: All files under `modules/` are automatically imported into the flake via `import-tree ./modules`.
- **New Files**: Any new `.nix` file added to `modules/` **must be `git add`ed** before the flake evaluator will recognize it.
- **Regeneration**: After editing `modules/flake.nix` (flake inputs or outputs), run `just write-flake` to regenerate the root `flake.nix`.

### Module Types
1. **NixOS Modules**: Defined via `flake.modules.nixos.<name>`. These are merged into the system configuration.
   - Example: `modules/system/`, `modules/network/`, `modules/services/`
2. **Home Manager Modules**: Defined via `flake.modules.homeManager.<name>`.
   - Example: `modules/home/vee.nix`

### Directory Structure
- `modules/system/`: Core system settings (nix, state-version, timezone, packages, etc.).
- `modules/hardware/`: Hardware-specific configurations (filesystems).
- `modules/boot/`: Bootloader and kernel configuration.
- `modules/network/`: Networking (hostname, firewall, SSH).
- `modules/services/`: All server services (caddy, nixarr, home-assistant, minecraft, etc.).
- `modules/home/`: Home Manager user configurations (vee, fish shell).
- `modules/users/`: NixOS user definitions.

### Service Organization
- Service files define their own firewall rules (LAN access via interface-specific rules).
- Caddy reverse proxy: each service defines its own `services.caddy.virtualHosts` entry.
- All media services share a `media` group for permissions.
- Files prefixed with `_` in `modules/services/` are disabled/optional (e.g., `_cockpit.nix`, `_minecraft/`).

### Key Flake Inputs
| Input | Purpose |
|---|---|
| `nixpkgs` | Core package repository (`nixos-unstable`) |
| `dotfiles` | Wrapped shell tools (fish, etc.) from `github:Version33/dotfiles` |
| `nixarr` | Media server suite (Jellyfin, Sonarr, Radarr, Prowlarr, Jellyseerr) |
| `nix-minecraft` | Minecraft server management |
| `import-tree` | Automatic module discovery from directory tree |
| `flake-file` | Generates `flake.nix` from module definitions |
| `nix-auto-follow` | Automatically deduplicates flake input nixpkgs versions |
| `treefmt-nix` | Project-wide formatting via `nix fmt` |

## 🛠️ Development Patterns

### Deploy Workflow
This is a **remote server** configuration. The deploy workflow:
1. Edit locally
2. `just build` to verify locally
3. `just deploy` to push to the homeserver (SSH + git pull + nixos-rebuild switch)

The `justfile` `deploy` recipe assumes:
- The remote server is accessible via SSH as `homeserver`
- The repo is cloned at `~/Git/homeserver` on the remote

### Firewall Pattern
- `networking.firewall.allowedTCPPorts` = public-facing ports (SSH, web, federation)
- `networking.firewall.interfaces."enp0s31f6".allowedTCPPorts` = LAN-only ports (service web UIs)
- Each service module defines its own interface-level firewall rules

### Permission Pattern
- Media services use a `media` group
- `systemd.tmpfiles.rules` with `Z` flag recursively fix ownership/permissions on media directories
- Service users are created as `isSystemUser = true` with appropriate groups

## ⚠️ Gotchas & Non-Obvious Details

- **Git Tracking**: Always `git add` new modules immediately. `import-tree` won't see untracked files.
- **`flake.nix` is auto-generated**: Do not manually edit `flake.nix`. Edit `modules/flake.nix` and run `just write-flake`.
- **`hardware-configuration.nix` is auto-generated**: Do not edit it. It was created by `nixos-generate-config`.
- **Underscore-prefixed files**: Files like `_cockpit.nix`, `_minecraft/` are disabled/optional modules. They are tracked in git but not loaded (import-tree skips `_`-prefixed files).
- **Home Assistant config**: Uses custom components built via `pkgs.buildHomeAssistantComponent` (Bambu Lab, HACS, FontAwesome) and manual Lovelace card installations via `systemd.tmpfiles.rules` symlinks.
- **VPN binding**: qBittorrent is bound to the Proton VPN interface (`BindToDevice = "protonvpn"`) and requires the WireGuard service to be up first.
- **Minecraft RCON**: The default RCON password is `changeme` — change it before exposing to LAN.
- **Shell**: The user `vee` uses a wrapped `fish` shell from the `dotfiles` input.
- **State Version**: `system.stateVersion = "25.05"` — do not change this value after initial install.
