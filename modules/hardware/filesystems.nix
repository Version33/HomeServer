{ ... }:
{

  flake.modules.nixos.filesystems = _: {
    # Mount big disk for media storage
    fileSystems."/mnt/bigdisk" = {
      device = "/dev/disk/by-uuid/c0957a15-b3f4-4b06-9f3a-cc26619518f3";
      fsType = "ext4";
    };

    # Store Conduit's database on the big disk
    fileSystems."/var/lib/matrix-conduit" = {
      device = "/mnt/bigdisk/matrix-db";
      options = [ "bind" ];
      depends = [ "/mnt/bigdisk" ];
    };
  };

}
