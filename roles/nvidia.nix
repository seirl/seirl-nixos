{ config, pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    ecryptfs
    ecryptfs-helper
  ];

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
}
