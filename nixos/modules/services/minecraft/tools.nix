{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    mcrcon
    (pkgs.writeShellScriptBin "mc-title" ''
      if [ $# -lt 2 ]; then
        echo "Usage: mc-title <player> <title> [subtitle]"
        echo "Example: mc-title @a \"Hello World\""
        echo "Example: mc-title @a \"Hello\" \"Welcome!\""
        exit 1
      fi

      PLAYER="$1"
      TITLE="$2"
      SUBTITLE="''${3:-}"

      mcrcon -H localhost -P 25575 -p changeme "title $PLAYER title {\"text\":\"$TITLE\"}"
      
      if [ -n "$SUBTITLE" ]; then
        mcrcon -H localhost -P 25575 -p changeme "title $PLAYER subtitle {\"text\":\"$SUBTITLE\"}"
      fi
    '')
  ];
}
