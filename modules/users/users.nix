{ ... }: {

  flake.modules.nixos.users = { pkgs, ... }: {
    # User configuration
    users.users.vee = {
      isNormalUser = true;
      extraGroups = [ "wheel" "media" ];
      shell = pkgs.nushell;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINvec5l0CVyepm8MyoLJ0xrl5nJqztj7eul7HYsVV9zc vee@k0or"
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIBRq+GQ8d8WXy1r12g6MxXHv21HqsU0K1QYRecRWPe1zAAAADnNzaDpob21lc2VydmVy vee@solokey2"
      ];
    };

    # Require password for sudo
    security.sudo.wheelNeedsPassword = true;
  };

}
