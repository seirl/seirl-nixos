{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/sd-card/sd-image-raspberrypi.nix")
    ];
}
