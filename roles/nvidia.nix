{ config, lib, pkgs, ... }:

let
  cfg = config.my.roles.nvidia;
in
{
  options = {
    my.roles.nvidia.enable = lib.mkEnableOption "Machine with Nvidia GPU";
    my.roles.nvidia.enableCuda = lib.mkEnableOption "Enable CUDA";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.nvtopPackages.nvidia ];
    nixpkgs.config.cudaSupport = cfg.enableCuda;
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      open = lib.mkDefault true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      forceFullCompositionPipeline = true;
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      nvidiaSettings = true;
    };

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
