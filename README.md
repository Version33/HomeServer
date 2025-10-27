# NixOS Home Server

A simplified NixOS-based home server configuration using native service integration. Run media services (Jellyfin, Radarr, QBitTorrent) and more with declarative configuration using [nixarr](https://nixarr.com).

## Features

- **Declarative Configuration**: All services defined in Nix
- **Native Services**: No containers or VMs - direct NixOS service integration
- **Nixarr Integration**: Use [nixarr](https://nixarr.com) for *arr app management
- **Reverse Proxy**: Caddy automatically routes traffic to services
- **Modular Design**: Easy to add new services
- **Production Ready**: Simple and efficient

## Quick Start

### Prerequisites

- NixOS installed on your server
- Nix with flakes enabled
- [direnv](https://direnv.net/) (optional but recommended)

### Development Environment Setup

This project includes a Nix development shell with all necessary tools (`just`, `nixfmt`, etc.):

**Option 1: Using direnv (recommended)**
```bash
# Install direnv if you haven't already
# Then allow direnv in this directory
direnv allow

# Tools will be automatically available when you cd into the project!
```

**Option 2: Manual shell**
```bash
# Enter the development shell manually
nix develop
```

### Initial Setup

1. **Generate hardware configuration** for your server:
```bash
nixos-generate-config --show-hardware-config > nixos/hardware-configuration.nix
```

2. **Review and update** boot device in `nixos/configuration.nix` if needed

3. **Build and test** the configuration:
```bash
just build
```

4. **Deploy** to your server:
```bash
just deploy
```

### Accessing Services

Add to your `/etc/hosts`:
```
<your-server-ip> qbittorrent.local radarr.local jellyfin.local
```

Or for local testing:
```
127.0.0.1 qbittorrent.local radarr.local jellyfin.local
```

Services are available at:
- **QBitTorrent**: http://qbittorrent.local
- **Radarr**: http://radarr.local
- **Jellyfin**: http://jellyfin.local

## Project Structure

```
HomeServer/
├── flake.nix                      # Flake configuration with nixarr integration
├── flake.lock                     # Locked dependencies
├── justfile                       # Command shortcuts
├── README.md                      # This file
└── nixos/
    ├── configuration.nix          # Main system configuration
    ├── hardware-configuration.nix # Hardware-specific settings (generate for your system)
    └── modules/
        ├── networking.nix         # Network configuration
        ├── nixarr.nix             # Nixarr configuration for *arr apps
        ├── jellyfin.nix           # Jellyfin media server
        ├── qbittorrent.nix        # QBitTorrent torrent client
        └── caddy.nix              # Reverse proxy configuration
```

## Adding More *arr Services

Nixarr makes it easy to add more services. Edit `nixos/modules/nixarr.nix`:

```nix
# Enable Sonarr for TV shows
nixarr.sonarr.enable = true;  # Runs on port 8989

# Enable Prowlarr for indexer management
nixarr.prowlarr.enable = true;  # Runs on port 9696

# Enable Bazarr for subtitles
nixarr.bazarr.enable = true;  # Runs on port 6767
```

Then add reverse proxy entries in `nixos/modules/caddy.nix`:

```nix
"http://sonarr.local" = {
  extraConfig = ''
    reverse_proxy http://localhost:8989
  '';
};
```

Rebuild and deploy:
```bash
just build
just deploy
```

## Adding Other Services

To add a native NixOS service:

1. Create a new module in `nixos/modules/`
2. Enable the service and configure it
3. Import the module in `nixos/configuration.nix`
4. Add a Caddy reverse proxy if needed
5. Deploy!

## Common Commands

```bash
# List all available commands
just

# Build the configuration
just build

# Deploy to the server
just deploy

# Test the configuration
just test

# Check service status
just status

# View service logs
just logs

# Restart services
just restart

# Open all service UIs
just open

# Clean build artifacts
just clean

# Update dependencies
just update
```

## Deployment

1. **Update hardware configuration**:
   - Generate new hardware config: `nixos-generate-config --show-hardware-config > nixos/hardware-configuration.nix`
   - Update boot device in `nixos/configuration.nix` if needed

2. **Review configuration**:
   - Set user password with `passwd admin` after first boot
   - Review firewall rules in `nixos/modules/networking.nix`
   - Configure storage paths in service modules if needed

3. **Deploy**:
   ```bash
   just deploy
   ```

## Service Management

```bash
# Check service status
systemctl status radarr jellyfin qbittorrent caddy

# View logs for a service
journalctl -u radarr -f

# Restart a service
sudo systemctl restart radarr

# Restart all media services
just restart
```

## Data Storage

Media and downloads are stored in `/data/`:
- `/data/media/` - Media files (movies, TV shows, etc.)
- `/data/downloads/` - Downloaded files from QBitTorrent
- Service configs are stored in their respective state directories

All services run as the `media` group (GID 1000) for shared access.

## Network Architecture

- **Host Network**: Standard network interface
- **Firewall**: Open ports 80, 443 (Caddy)
- **Reverse Proxy**: Caddy routes based on hostname
- **Native Services**: All services run directly on the host (no containers)

## Troubleshooting

### Services not starting
```bash
# Check service status
just status

# View detailed logs
journalctl -u radarr -xe
journalctl -u jellyfin -xe
journalctl -u qbittorrent -xe
journalctl -u caddy -xe
```

### Can't access services
```bash
# Verify /etc/hosts entries
cat /etc/hosts | grep local

# Test direct access
curl http://localhost:7878  # Radarr
curl http://localhost:8096  # Jellyfin
curl http://localhost:8080  # QBitTorrent

# Check Caddy status
systemctl status caddy
```

### Permission issues
```bash
# Ensure media directories have correct permissions
ls -la /data/media
ls -la /data/downloads

# Fix permissions if needed
sudo chown -R root:media /data
sudo chmod -R 775 /data
```

## Development

- **Modular Design**: Each module is independent and can be enabled/disabled
- **Declarative**: No manual service configuration needed
- **Reproducible**: Entire system can be rebuilt from this repository
- **Native Integration**: Uses NixOS service modules for maximum efficiency

## License

This is a personal configuration. Use and modify as you wish.

## Contributing

This is a personal project, but feel free to fork and adapt for your needs!
