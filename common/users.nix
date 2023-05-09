{ pkgs, ... }:

let
  my = import ./..;
in
rec {
  users.users.seirl = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "mlocate" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILiua8eEg+nU0XSbYPTgnOMftzvpbN+u7v5jDabeO/0E"
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
  };
}
