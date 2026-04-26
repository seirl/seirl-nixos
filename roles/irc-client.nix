{ config, lib, pkgs, ... }:

let
  cfg = config.my.roles.irc-client;
  relayPort = 9201;
in
{
  options.my.roles.irc-client = {
    enable = lib.mkEnableOption "IRC Client";
    vhost = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "weechat.example.com";
      description = "Hostname of the nginx vhost.";
    };
    users = lib.mkOption {
      type = with lib.types; listOf (attrsOf anything);
      default = [ ];
      example = "[ config.users.users.seirl ]";
      description = "List of users for which to autostart a weechat service.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      weechat
      tmux
    ];

    nixpkgs.overlays = [
      (self: super: {
        weechat = super.weechat.override {
          configure = { availablePlugins, ... }: {
            scripts = with super.weechatScripts; [
              wee-slack
              # weechat-matrix
            ];
          };
        };
      })
    ];

    systemd.user.services.weechat = {
      enable = true;
      unitConfig.ConditionUser =
        lib.strings.concatMapStringsSep "|" (u: u.name) cfg.users;
      serviceConfig = {
        Type = "forking";
        Environment = [ "TMUX_TMPDIR=%t" ];
        ExecStart = "${pkgs.tmux}/bin/tmux -2 new-session -d -s irc ${pkgs.weechat}/bin/weechat --upgrade \\; set status off";
        ExecStop = "${pkgs.tmux}/bin/tmux kill-session -t irc";
      };
      wantedBy = [ "default.target" ];
      wants = [ "network.target" ];
    };

    services.nginx.virtualHosts."${cfg.vhost}" = {
      forceSSL = true;
      enableACME = true;

      locations."/weechat" = {
        proxyPass = "http://localhost:${toString relayPort}/weechat";
        proxyWebsockets = true;
      };

      locations."/" = {
        root = "${pkgs.glowing-bear}";
      };
    };
  };
}
