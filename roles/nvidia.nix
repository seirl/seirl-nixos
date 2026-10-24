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
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      open = lib.mkDefault true;
      forceFullCompositionPipeline = true;
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      nvidiaSettings = true;
    };

    nix.settings = lib.mkIf cfg.enableCuda {
      substituters = [ "https://cache.nixos-cuda.org" ];
      trusted-public-keys = [ "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" ];
    };
  };
}
