{ pkgs, ... }:

{
  imports = [
    ./ale.nix
    ./lualine.nix
    ./vim-molokai-delroth.nix
  ];

  config.programs.neovim.plugins = [
    pkgs.vimPlugins.lualine-nvim
  ];
}
