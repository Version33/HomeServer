{ ... }:
{

  flake.modules.nixos.filesystems = _: {
    # Mount big disk for media storage
    fileSystems."/mnt/bigdisk" = {
      device = "/dev/disk/by-uuid/c0957a15-b3f4-4b06-9f3a-cc26619518f3";
      fsType = "ext4";
    };

    # Store Conduit's database on the big disk.
    # DynamicUser=true (set by the conduit NixOS module) causes systemd to use
    # /var/lib/private/matrix-conduit as the real StateDirectory, with
    # /var/lib/matrix-conduit as a symlink. The bind mount must target the
    # private path to avoid blocking that symlink migration.
    fileSystems."/var/lib/private/matrix-conduit" = {
      device = "/mnt/bigdisk/matrix-db";
      options = [ "bind" ];
      depends = [ "/mnt/bigdisk" ];
    };
  };

}
