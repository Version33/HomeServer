# Incus Home Server

A NixOS-based home server configuration using Incus for container management, designed as a Proxmox replacement. Run media services (Jellyfin, Radarr, QBitTorrent) and more in isolated containers with declarative configuration.

## Features

- **Declarative Configuration**: All containers and services defined in Nix
- **Incus Containers**: Run Docker images in lightweight system containers
- **Reverse Proxy**: Caddy automatically routes traffic to services
- **Modular Design**: Easy to add new services and containers
- **Development VM**: Test changes safely before deploying to hardware
- **Production Ready**: Secure defaults for actual deployment

## Quick Start

### Prerequisites

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

# Or use nix-shell for one-off commands
nix develop -c just run-vm
```

### Running the VM

```bash
# Using just (recommended)
just run-vm

# Or manually
nix build .#vm
./result/bin/run-incus-server-vm
```

### Accessing Services

Add to your `/etc/hosts`:
```
127.0.0.1 qbittorrent.local radarr.local jellyfin.local incus.local
```

Services are available at:
- **QBitTorrent**: http://qbittorrent.local:8080
- **Radarr**: http://radarr.local:8080
- **Jellyfin**: http://jellyfin.local:8080
- **Incus Web UI**: https://localhost:9443

SSH access:
```bash
ssh -p 2222 incus-admin@localhost
# Password: changeme
```

## Project Structure

```
IncusServer/
├── flake.nix                      # Flake configuration with VM and system outputs
├── flake.lock                     # Locked dependencies
├── justfile                       # Command shortcuts
├── README.md                      # This file
├── nixos/
│   ├── configuration.nix          # Main system configuration
│   ├── hardware-configuration.nix # Hardware-specific settings
│   └── modules/
│       ├── networking.nix         # Network configuration
│       ├── incus.nix              # Incus virtualization setup
│       ├── caddy.nix              # Reverse proxy configuration
│       └── containers.nix         # Container definitions
└── scripts/
    └── test-connectivity.sh       # Network testing script
```

## Adding a New Container

Containers are defined in `nixos/modules/containers.nix`. To add a new service:

1. Open `nixos/modules/containers.nix`
2. Add a new entry to the `containers` attribute set:

```nix
myservice = {
  ip = "10.0.100.14";  # Next available IP
  image = "docker:linuxserver/myservice";
  ports = {
    web = 8080;  # Service ports (for documentation)
  };
  env = {
    PUID = "1000";
    PGID = "1000";
    TZ = "UTC";
    # Add service-specific environment variables
  };
  volumes = {
    config = {
      source = "/var/lib/incus-containers/myservice/config";
      path = "/config";
    };
    data = {
      source = "/var/lib/incus-containers/myservice/data";
      path = "/data";
    };
  };
};
```

3. Add a Caddy reverse proxy entry in `nixos/modules/caddy.nix`:

```nix
"http://myservice.local" = {
  extraConfig = ''
    reverse_proxy http://10.0.100.14:8080
  '';
};
```

4. Rebuild and run:
```bash
just build-vm
just run-vm
```

The container will be automatically created and started on boot!

## Common Commands

```bash
# List all available commands
just

# Build and run VM
just run-vm

# Test connectivity
just test-connectivity

# SSH into VM
just ssh-vm

# Clean build artifacts
just clean

# Update dependencies
just update

# Deploy to actual hardware (WARNING: Production use)
just deploy
```

## Deploying to Hardware

When ready to replace Proxmox:

1. **Update hardware configuration**:
   - Generate new hardware config: `nixos-generate-config --show-hardware-config > nixos/hardware-configuration.nix`
   - Update boot device in `flake.nix` under the `incus-server` configuration

2. **Review security settings**:
   - Change default password for `incus-admin` user
   - Review firewall rules in `nixos/modules/networking.nix`
   - The production config automatically disables root login and requires sudo password

3. **Deploy**:
   ```bash
   sudo nixos-rebuild switch --flake .#incus-server
   ```

## Container Management

### Inside the VM/System

```bash
# List containers
incus list

# View container logs
incus exec <container-name> -- journalctl -f

# Shell into a container
incus exec <container-name> -- /bin/bash

# Restart a container
incus restart <container-name>

# Reset all containers (delete and recreate)
incus-container-reset
```

### Persistent Data

Container data is stored in `/var/lib/incus-containers/`:
- Each service has its own subdirectory
- Shared directories (like `downloads`) are used by multiple services
- Data persists across container restarts and rebuilds

## Network Architecture

- **Host Network**: DHCP on main interface
- **Container Bridge**: `incusbr0` at 10.0.100.1/24
- **NAT**: Enabled for container internet access
- **Firewall**: Open ports 80, 443 (Caddy), 8443 (Incus UI)
- **Reverse Proxy**: Caddy routes based on hostname

## Troubleshooting

### Containers not starting
```bash
# Check Incus service
systemctl status incus

# Check container service
systemctl status incus-containers

# View logs
journalctl -u incus-containers
```

### Can't access services
```bash
# Verify /etc/hosts entries
cat /etc/hosts | grep local

# Test from inside VM
just ssh-vm
curl http://10.0.100.12:8096  # Direct to Jellyfin container
```

### Rebuild containers from scratch
```bash
# Inside VM or on system
incus-container-reset
```

## Development

- **Modular Design**: Each module (`networking.nix`, `incus.nix`, etc.) is independent
- **VM Testing**: Always test changes in VM before deploying to hardware
- **Declarative**: No manual container configuration needed
- **Reproducible**: Entire system can be rebuilt from this repository

## License

This is a personal configuration. Use and modify as you wish.

## Contributing

This is a personal project, but feel free to fork and adapt for your needs!
