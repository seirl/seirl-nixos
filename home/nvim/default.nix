{ config, lib, pkgs, ... }:

{
  imports = [
    ./plugins
  ];

  config.programs.neovim = {
    enable = true;
    extraConfig = lib.fileContents ./init.vim;
  };
}
