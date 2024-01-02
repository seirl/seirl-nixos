{ name, config, pkgs, ... }:

let
  my = import ../..;
in
{
  imports = [
    # my.modules
    ./hardware.nix
  ];

  nixpkgs.config.allowUnsupportedSystem = true;
  nixpkgs.hostPlatform.system = "armv6l-linux";
  nixpkgs.buildPlatform.system = "x86_64-linux";

  time.timeZone = "Europe/Paris";
}
