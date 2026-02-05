{ ... }: {

  flake.modules.homeManager.nushell = _: {
    programs.nushell = {
      enable = true;
      extraConfig = ''
        $env.config.show_banner = false

        def mc [...args: string] {
          if ($args | is-empty) {
            mcrcon -H localhost -P 25575 -p changeme
          } else {
            mcrcon -H localhost -P 25575 -p changeme ($args | str join ' ')
          }
        }
      '';
      shellAliases = {
        mc-logs = "journalctl -u minecraft-server -f";
        mc-restart = "sudo systemctl restart minecraft-server";
      };
    };

    programs.starship = {
      enable = true;
      enableNushellIntegration = true;
    };
  };

}
