# Agent Guidelines

This document provides essential context for AI agents working in this NixOS homeserver configuration repository.

## 🚀 Essential Commands

Most operations are managed via `just`.

| Command | Description | Note |
|---|---|---|
| `just build` | Build configuration without switching | Uses `nixos-rebuild build` |
| `just deploy` | Deploy to the remote homeserver | `deploy-rs`: local build + closure push + activate |
| `just deploy-dry` | Push and evaluate activation, do not switch | `deploy --dry-activate` |
| `just deploy-boot` | Deploy, active from next boot | `deploy --boot` |
| `just deploy-interactive` | Deploy, prompting for the sudo password | Bootstrap/recovery when the NOPASSWD rule is absent |
| `just rollback` | Roll the server back one generation | SSH + `nix-env --rollback` |
| `just format` | Format all `.nix` files | Uses `nix fmt` (nixfmt under treefmt) |
| `just check` | Lint with `statix` | |
| `just deadcode` | Find unused code | Uses `deadnix` |
| `just flake-check` | Check flake for issues | `nix flake check` |
| `just update` | Update flake inputs | `nix flake update` |
| `just clean` | Garbage collect old generations **on the server** | SSH + `sudo nix-collect-garbage` |
| `just diff` | Show closure diff | Server's running system vs new local build |
| `just dry-run` | Show what would be built | |
| `just write-flake` | Regenerate `flake.nix` from modules | After editing `modules/flake.nix` inputs |
| `just dev` | Enter development shell | `nix develop` |
| `just search <pkg>` | Search for a package | |

**Note**: `nixos-rebuild build` does **not** require `sudo` — nothing in this repo is built or activated on the machine you edit from. Server-side recipes (`deploy`, `clean`, `optimize`, `rollback`) escalate with `sudo` over SSH and will prompt for `vee`'s password.

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
| `deploy-rs` | Remote deployment (`flake.deploy`, defined in `modules/deploy.nix`) |
| `treefmt-nix` | Project-wide formatting via `nix fmt` |

## 🛠️ Development Patterns

### Deploy Workflow
This is a **remote server** configuration deployed with [`deploy-rs`](https://github.com/serokell/deploy-rs). The workflow:
1. Edit locally
2. `just build` to verify locally
3. `just deploy` — builds the closure locally, `nix copy`s it to the server, activates it

There is **no git pull on the server**; the closure is pushed directly, so uncommitted (but staged, see Git Tracking) changes deploy fine.

`flake.deploy` lives in `modules/deploy.nix`:
- `hostname = "homeserver"`, `sshUser = "vee"`, `user = "root"` (activation escalates via `sudo`)
- `sshOpts = [ "-i" "~/.ssh/homeserver" ]` — the same key the old `ssh homeserver` workflow used
- `interactiveSudo = false` — deploys are unattended; see the sudo note below
- `fastConnection = true` — LAN link, push the whole closure rather than making the server substitute
- `magicRollback` / `autoRollback` are left at their defaults (on): if the box stops answering SSH after activation, it reverts itself

`modules/deploy.nix` also defines `flake.modules.nixos.deploy`, the server-side half: a `security.sudo.extraRules` entry giving `vee` NOPASSWD on the only two commands deploy-rs runs as root — `/nix/store/*/activate-rs` and `rm /tmp/deploy-rs-canary-*`. `security.sudo.wheelNeedsPassword` stays `true` for everything else.

**Bootstrapping**: the rule has to already be live on the server for a passwordless deploy to work, so the deploy that first installs it must use `just deploy-interactive`. Same applies after a rebuild from scratch.

`nix flake check` includes `deploy-schema` and `deploy-activate` from `deployChecks`, which validate `flake.deploy` against deploy-rs' JSON schema.

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
- **`deploy-rs` needs `vee` in `nix.settings.trusted-users`**: the closure is pushed unsigned via `nix copy`, so the SSH user must be trusted. `nix-settings.nix` grants `@wheel`; dropping that breaks deploys with a signature error.
- **The magic-rollback canary needs its own sudo rule**: deploy-rs confirms a deploy by running `sudo rm <tempPath>/deploy-rs-canary-<hash>` — *not* `activate-rs`. Grant NOPASSWD on `activate-rs` alone and every deploy appears to succeed, then silently rolls back after `confirmTimeout` (30s) because the canary was never removed. Both rules are verified by a NixOS VM test (`sudo -n` allowed for `activate-rs` and the canary `rm`, denied for `sudo -n true`, `rm /etc/machine-id`, and `ls` — the last one matters because coreutils is a multicall binary, so `rm` and `ls` share an inode).
- **`deploy-rs` strips `default` from `loader.conf`**: `activate.nixos` runs `sed -i '/^default /d' /boot/loader/loader.conf`, a workaround for upstream issue #31 — NixOS' systemd-boot builder refuses to pin a default because deploy-rs points the system profile at the `activatable-*` wrapper instead of the raw toplevel. Verified benign on current nixpkgs: `write_loader_conf` already degrades to `default nixos-*` in exactly that case, and with no `LoaderEntryDefault` EFI variable on the box systemd-boot picks the newest generation either way. Consequence: `bootctl set-default` will not stick.
- **`nix flake check` warns `unknown flake output 'deploy'`**: expected — Nix has no schema for deploy-rs' output. The real validation is the `deploy-schema` / `deploy-activate` checks.
- **`deploy-rs.inputs.nixpkgs.follows = "nixpkgs"`**: keeps a single nixpkgs in the lock at the cost of building `deploy-rs` from source instead of pulling the cached `pkgs.deploy-rs`. Measured at ~32s, so it is not worth the README's overlay workaround, which would add a second nixpkgs and risk skew between the local `deploy` binary and the remote `activate-rs` (nixpkgs' `deploy-rs` is pinned ~33 commits behind upstream).
- **`hardware-configuration.nix` is auto-generated**: Do not edit it by hand. It was created by `nixos-generate-config` — but `treefmt` still formats it, and the `treefmt` flake check fails if it drifts. Run `just format` after regenerating it.
- **Underscore-prefixed files**: Files like `_cockpit.nix`, `_minecraft/` are disabled/optional modules. They are tracked in git but not loaded (import-tree skips `_`-prefixed files).
- **Home Assistant config**: Uses custom components built via `pkgs.buildHomeAssistantComponent` (Bambu Lab, HACS, FontAwesome) and manual Lovelace card installations via `systemd.tmpfiles.rules` symlinks.
- **VPN binding**: qBittorrent is bound to the Proton VPN interface (`BindToDevice = "protonvpn"`) and requires the WireGuard service to be up first.
- **Minecraft RCON**: The default RCON password is `changeme` — change it before exposing to LAN.
- **Shell**: The user `vee` uses a wrapped `fish` shell from the `dotfiles` input.
- **State Version**: `system.stateVersion = "25.05"` — do not change this value after initial install.
