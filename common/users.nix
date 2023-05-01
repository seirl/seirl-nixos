{ pkgs, ... }:

{
  users.users.seirl = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" ];
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

}
