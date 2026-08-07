{ inputs, self, ... }:
let
  # The activation closure is built for the *target* platform, so derive the
  # system from the node itself rather than hardcoding it in two places.
  targetSystem = self.nixosConfigurations.homeserver.pkgs.stdenv.hostPlatform.system;
  deployLib = inputs.deploy-rs.lib.${targetSystem};
in
{

  flake-file.inputs.deploy-rs = {
    url = "github:serokell/deploy-rs"; # Multi-profile flake deploy tool
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # ============================================================================
  # deploy-rs
  # ============================================================================
  # `deploy .#homeserver` builds locally, pushes the closure over SSH and
  # activates it with magic rollback (auto-reverts if the box stops answering).
  flake.deploy = {
    # Log in as vee over SSH, then escalate to root for the activation.
    sshUser = "vee";
    user = "root";

    # Same key the old `ssh homeserver` workflow used. The local ssh_config
    # Host block already points at it, but passing it explicitly keeps deploys
    # working from any shell/agent state.
    sshOpts = [
      "-i"
      "~/.ssh/homeserver"
    ];

    # Unattended: the `deploy` NixOS module below grants vee NOPASSWD sudo on
    # exactly the two commands deploy-rs runs as root. `security.sudo
    # .wheelNeedsPassword` stays true for everything else.
    interactiveSudo = false;

    # LAN link: push the whole closure instead of making the server re-fetch it
    # from the binary caches.
    fastConnection = true;

    nodes.homeserver = {
      hostname = "homeserver";
      profiles.system.path = deployLib.activate.nixos self.nixosConfigurations.homeserver;
    };
  };

  # ============================================================================
  # Server-side counterpart
  # ============================================================================
  # deploy-rs escalates to root for two distinct commands, and BOTH need a rule:
  #   1. `<profile>/activate-rs` — activate, wait and revoke.
  #   2. `rm <tempPath>/deploy-rs-canary-<hash>` — the magic-rollback confirm.
  # Covering only (1) makes every deploy look like it worked, then silently roll
  # back after `confirmTimeout` because the canary was never removed.
  #
  # This is deliberately root-equivalent, not a narrow grant: vee is already in
  # `nix.settings.trusted-users`, so any store path vee can push is a candidate
  # `activate-rs`. The rule buys convenience, not containment.
  flake.modules.nixos.deploy = _: {
    security.sudo.extraRules = [
      {
        users = [ "vee" ];
        commands = [
          {
            command = "/nix/store/*/activate-rs";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/rm /tmp/deploy-rs-canary-*";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };

  # Validates `flake.deploy` against deploy-rs' JSON schema and asserts every
  # profile carries its activation scripts. Runs as part of `nix flake check`.
  perSystem =
    { system, ... }:
    {
      checks = inputs.deploy-rs.lib.${system}.deployChecks self.deploy;
    };

}
