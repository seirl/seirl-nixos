{ config, lib, pkgs, ... }:

let
  cfg = config.my.roles.nvidia;
in
{
  options = {
    my.roles.nvidia.enable = lib.mkEnableOption "Machine with Nvidia GPU";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.cudaSupport = true;
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

    nix.settings = {
      substituters = [
        "https://cuda-maintainers.cachix.org"
      ];
      trusted-public-keys = [
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      ];
    };
  };
}
