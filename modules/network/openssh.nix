{ ... }: {

  flake.modules.nixos.openssh = _: {
    # Enable SSH for remote management
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
  };

}
