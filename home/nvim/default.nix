{ config, lib, pkgs, ... }:

{
  imports = [
    ./plugins
  ];

  config = {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withRuby = true;
      withPython3 = true;
      extraConfig = lib.fileContents ./init.vim;
      extraPackages = [
        pkgs.xclip
        pkgs.wl-clipboard
      ];
    };
  };
}
