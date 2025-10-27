{ config, pkgs, lib, ... }:

let
  # Container definitions
  containers = {
    radarr = {
      ip = "10.0.100.11";
      image = "docker:linuxserver/radarr";
      ports = {
        web = 7878;
      };
      env = {
        PUID = "1000";
        PGID = "1000";
        TZ = "UTC";
      };
      volumes = {
        config = {
          source = "/var/lib/incus-containers/radarr/config";
          path = "/config";
        };
        movies = {
          source = "/var/lib/incus-containers/radarr/movies";
          path = "/movies";
        };
        downloads = {
          source = "/var/lib/incus-containers/downloads";
          path = "/downloads";
        };
      };
    };

    jellyfin = {
      ip = "10.0.100.12";
      image = "docker:linuxserver/jellyfin";
      ports = {
        web = 8096;
        dlna = 1900;
      };
      env = {
        PUID = "1000";
        PGID = "1000";
        TZ = "UTC";
      };
      volumes = {
        config = {
          source = "/var/lib/incus-containers/jellyfin/config";
          path = "/config";
        };
        movies = {
          source = "/var/lib/incus-containers/radarr/movies";
          path = "/movies";
        };
        cache = {
          source = "/var/lib/incus-containers/jellyfin/cache";
          path = "/cache";
        };
      };
    };
  };

  # Helper function to create container setup script
  mkContainerSetup = name: cfg: ''
    echo "Setting up container: ${name}"

    # Create volume directories
    ${lib.concatStringsSep "\n" (lib.mapAttrsToList (volName: vol: ''
      mkdir -p ${vol.source}
      chown 1000:1000 ${vol.source}
    '') cfg.volumes)}

    # Check if container exists
    if ! incus list --format json | ${pkgs.jq}/bin/jq -e '.[] | select(.name == "${name}")' > /dev/null; then
      echo "Creating container ${name}..."

      # Initialize container (don't start it yet)
      incus init ${cfg.image} ${name} --vm=false

      # Set root disk size to 10GB to ensure enough space
      incus config device override ${name} root size=10GB

      # Map container UID/GID 1000 to host UID/GID 1000 for volume access
      # This allows the container to access bind-mounted volumes properly
      incus config set ${name} raw.idmap "both 1000 1000"

      # Set static IP on the eth0 device (must use override since eth0 comes from profile)
      incus config device override ${name} eth0 ipv4.address=${cfg.ip}

      # Add volume mounts
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (volName: vol: ''
        incus config device add ${name} ${volName} disk source=${vol.source} path=${vol.path} || true
      '') cfg.volumes)}

      # Set environment variables
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (key: value: ''
        incus config set ${name} environment.${key}="${value}"
      '') cfg.env)}

      # Now start the container with all configuration applied
      incus start ${name}
      echo "Container ${name} created and started with IP ${cfg.ip}"
    else
      echo "Container ${name} already exists"

      # Ensure it's running
      if ! incus list --format json | ${pkgs.jq}/bin/jq -e '.[] | select(.name == "${name}") | select(.status == "Running")' > /dev/null; then
        echo "Starting container ${name}..."
        incus start ${name} || true
      fi
    fi
  '';

in {
  # Ensure container data directories exist
  systemd.tmpfiles.rules = [
    "d /var/lib/incus-containers 0755 root root -"
  ] ++ lib.flatten (lib.mapAttrsToList (name: cfg:
    lib.mapAttrsToList (volName: vol: "d ${vol.source} 0755 1000 1000 -") cfg.volumes
  ) containers);

  # Systemd service to manage containers declaratively
  systemd.services.incus-containers = {
    description = "Declarative Incus Container Management";
    after = [ "incus.service" "incus-preseed.service" ];
    wants = [ "incus.service" ];
    wantedBy = [ "multi-user.target" ];

    # Only run after incus is fully initialized
    path = [ pkgs.incus ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 10";
    };

    script = ''
      set -e

      # Wait for Incus to be ready
      echo "Waiting for Incus to be ready..."
      timeout=60
      while [ $timeout -gt 0 ]; do
        if incus list > /dev/null 2>&1; then
          echo "Incus is ready"
          break
        fi
        echo "Waiting... ($timeout seconds remaining)"
        sleep 2
        timeout=$((timeout - 2))
      done

      if [ $timeout -le 0 ]; then
        echo "Timeout waiting for Incus to be ready"
        exit 1
      fi

      # Add Docker Hub as a remote for OCI images
      echo "Configuring Docker Hub remote..."
      if ! incus remote list | grep -q "^| docker"; then
        incus remote add docker https://docker.io --protocol=oci
        echo "Docker remote added"
      else
        echo "Docker remote already exists"
      fi

      # Setup each container
      ${lib.concatStringsSep "\n\n" (lib.mapAttrsToList mkContainerSetup containers)}

      echo "All containers configured"
    '';

    # Cleanup script
    preStop = ''
      echo "Stopping containers..."
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: cfg: ''
        incus stop ${name} --timeout 30 || true
      '') containers)}
    '';
  };

  # Add a helper script for manual container management
  environment.systemPackages = [
    (pkgs.writeScriptBin "incus-container-reset" ''
      #!/bin/sh
      echo "This will delete and recreate all containers. Continue? (y/N)"
      read -r response
      if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
        ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: cfg: ''
          echo "Deleting ${name}..."
          incus delete ${name} --force || true
        '') containers)}

        echo "Restarting incus-containers service..."
        systemctl restart incus-containers
      else
        echo "Cancelled"
      fi
    '')
  ];
}
