{ pkgs, ... }:

let
  my = import ./..;
in
{
  users.users.seirl = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "mlocate" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
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
