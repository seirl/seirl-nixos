{ pkgs, config, ... }:

let
  my = import ./..;
in
rec {
  users.users.seirl = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "mlocate" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILiua8eEg+nU0XSbYPTgnOMftzvpbN+u7v5jDabeO/0E seirl"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBI/JwDTVgDieMCQz8Pe9GejJDed5hJnGuPo5Yer9kooLNS6qJSvYVKNxAK3n2P5Ftr5dfMSlZD56dVM37nI8q2o= seirl@google-small-usbc"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBMSFbO4Wxz5Yie7rjfziXOSaY7vodWAvpfw9SlgCbZcwfKPTjEpjd/FRMJEAAjv27DumofczSHURcQRrd6SBTl4= seirl@google-keyring-usbc"
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
      my.home
    ];

    # TODO: make that automatic for all users.
    config = {
      my.home.gaming.enable = config.my.roles.gaming.enable;
      my.home.graphical.enable = config.my.roles.graphical.enable;
      my.home.laptop.enable = config.my.roles.laptop.enable;
    };
  };
}
