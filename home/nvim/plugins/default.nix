{ pkgs, ... }:

{
  imports = [
    ./vim-molokai-delroth.nix
  ];

  config.programs.neovim.plugins = [
  ];
}
