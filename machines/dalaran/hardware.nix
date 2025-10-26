{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "vmd" "xhci_pci" "ahci" "nvme" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.swraid.enable = true;

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/0f788872-fba3-4b0b-a4d5-d637b86f4ae6";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/8DE1-0FAC";
      fsType = "vfat";
    };

  fileSystems."/srv/data1" =
    {
      device = "/dev/disk/by-uuid/2abcc000-d27e-4d30-8118-ae4aa178419a";
      fsType = "ext4";
      neededForBoot = false;
      options = [ "nofail" ];
    };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
