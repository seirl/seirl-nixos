{ pkgs, ... }:

{
  imports = [
    ./ale.nix
    ./lualine.nix
    ./ultisnips.nix
  ];

  config.programs.neovim.plugins = [
    pkgs.vimPlugins.supertab
    pkgs.vimPlugins.nerdcommenter
    pkgs.vimPlugins.vim-eunuch
    pkgs.vimPlugins.vim-surround
    pkgs.vimPlugins.vim-jinja-languages
    pkgs.vimPlugins.vim-molokai-delroth
  ];
}
