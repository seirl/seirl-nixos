{ pkgs, config, ... }:

rec {
  users.users.seirl = {
    isNormalUser = true;
    linger = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "mlocate" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILiua8eEg+nU0XSbYPTgnOMftzvpbN+u7v5jDabeO/0E seirl"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBI/JwDTVgDieMCQz8Pe9GejJDed5hJnGuPo5Yer9kooLNS6qJSvYVKNxAK3n2P5Ftr5dfMSlZD56dVM37nI8q2o= seirl@google-laptopkey"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBBUV8ySLA74EH6N8gcA+6wdPORmaDvNQ+43e/0ExMUoQJs8c9kkLdK/USFJ51VA5tnRtDOUusZbnY9hojnz2Kaw= seirl@google-workstationkey"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBO7uX6WXQfEeCt8tarsbI4KO/rUlkt1dtJa4pkvoAbM8SpCuzOklbRLydGmhsKuQYrOv5vIXJyQmiEfvuOQt57s= seirl@google-portablekey"
    ];
  };

  users.users.root = {
    openssh.authorizedKeys.keys = users.users.seirl.openssh.authorizedKeys.keys;
  };

  security.sudo.extraRules = [
    {
      users = [ "seirl" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  home-manager.users.seirl = {
    imports = [
      ../home
    ];

    config = {
      home.stateVersion = config.system.stateVersion;
      my.home.gaming.enable = config.my.roles.gaming.enable;
      my.home.graphical.enable = config.my.roles.graphical.enable;
      my.home.laptop.enable = config.my.roles.laptop.enable;
    };
  };
}
