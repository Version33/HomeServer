{ ... }: {

  flake.modules.nixos.state-version = _: {
    # NixOS version that the system was originally installed with
    # This value determines the default versions of stateful data
    # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
    system.stateVersion = "25.05";
  };

}
