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
    environment.systemPackages = lib.mkMerge [
      (lib.mkIf cfg.enableCuda [ pkgs.nvtopPackages.nvidia ])
    ];
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
  };
}
