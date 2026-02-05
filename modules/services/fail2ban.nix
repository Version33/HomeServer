{ ... }: {

  flake.modules.nixos.fail2ban = _: {
    services.fail2ban = {
      enable = true;
      maxretry = 5;
      ignoreIP = [ "127.0.0.1/8" "::1" "192.168.1.0/24" ];
      bantime = "1h";
      bantime-increment = {
        enable = true;
        multipliers = "1 2 4 8 16 32 64";
        maxtime = "168h";
        overalljails = true;
      };
      jails.sshd.settings = {
        enabled = true;
        port = 22;
      };
    };
  };

}
