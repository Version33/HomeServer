{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    mcrcon
    (pkgs.writeShellScriptBin "mc-title" ''
      COLOR=""
      BOLD=false
      ITALIC=false
      UNDERLINED=false
      STRIKETHROUGH=false

      while [[ $# -gt 0 ]]; do
        case $1 in
          -c|--color)
            COLOR="$2"
            shift 2
            ;;
          -b|--bold)
            BOLD=true
            shift
            ;;
          -i|--italic)
            ITALIC=true
            shift
            ;;
          -u|--underline)
            UNDERLINED=true
            shift
            ;;
          -s|--strikethrough)
            STRIKETHROUGH=true
            shift
            ;;
          *)
            break
            ;;
        esac
      done

      if [ $# -lt 2 ]; then
        echo "Usage: mc-title [options] <player> <title> [subtitle]"
        echo "Options:"
        echo "  -c, --color <color>       Set color (red, gold, yellow, green, aqua, blue, light_purple, white, etc.)"
        echo "  -b, --bold                Make text bold"
        echo "  -i, --italic              Make text italic"
        echo "  -u, --underline           Make text underlined"
        echo "  -s, --strikethrough       Make text strikethrough"
        echo ""
        echo "Example: mc-title @a \"Hello World\""
        echo "Example: mc-title -c red -b @a \"Warning\" \"Be careful!\""
        exit 1
      fi

      PLAYER="$1"
      TITLE="$2"
      SUBTITLE="''${3:-}"

      build_json() {
        local text="$1"
        local json="{\"text\":\"$text\""
        
        if [ -n "$COLOR" ]; then
          json="$json,\"color\":\"$COLOR\""
        fi
        if [ "$BOLD" = true ]; then
          json="$json,\"bold\":true"
        fi
        if [ "$ITALIC" = true ]; then
          json="$json,\"italic\":true"
        fi
        if [ "$UNDERLINED" = true ]; then
          json="$json,\"underlined\":true"
        fi
        if [ "$STRIKETHROUGH" = true ]; then
          json="$json,\"strikethrough\":true"
        fi
        
        json="$json}"
        echo "$json"
      }

      TITLE_JSON=$(build_json "$TITLE")
      mcrcon -H localhost -P 25575 -p changeme "title $PLAYER title $TITLE_JSON"

      if [ -n "$SUBTITLE" ]; then
        SUBTITLE_JSON=$(build_json "$SUBTITLE")
        mcrcon -H localhost -P 25575 -p changeme "title $PLAYER subtitle $SUBTITLE_JSON"
      fi
    '')
  ];
}
