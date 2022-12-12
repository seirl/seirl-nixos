{ pkgs, ...}:

{
  users.users.seirl = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };
}
