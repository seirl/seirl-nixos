{ config, lib, pkgs, ... }:

let
  cfg = config.programs.instawow;
  configDir = "${config.xdg.configHome}/instawow";
in
{
  options = {
    programs.instawow = {
      enable = lib.mkEnableOption "instawow, WoW add-on manager";
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.instawow;
        defaultText = lib.literalExpression "pkgs.instawow";
        description = "The {command}`instawow` package to install.";
      };
      credsPath = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = "Path to the JSON config where access tokens are stored";
        default = null;
      };
      profiles = lib.mkOption {
        description = "Instawow profiles";
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            gameFlavor = lib.mkOption {
              type = lib.types.str;
              description = "Game flavor (retail, classic, classic_era...)";
              default = "_retail_";
            };
            addonDir = lib.mkOption {
              type = lib.types.path;
              description = "Path of the WoW Interface/AddOns directory";
            };
          };
        });
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
    home.file = ((lib.mapAttrs'
      (name: value: {
        name = "${configDir}/profiles/${name}/config.json";
        value.text = builtins.toJSON {
          profile = name;
          addon_dir = value.addonDir;
          game_flavour = value.gameFlavor;
        };
      })
      cfg.profiles)
    // (if (cfg.credsPath != null) then {
      "${configDir}/config.json".source =
        (config.lib.file.mkOutOfStoreSymlink cfg.credsPath);
    } else { }));
  };
}
