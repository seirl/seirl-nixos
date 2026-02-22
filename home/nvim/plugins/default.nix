{ pkgs, ... }:

{
  imports = [
    ./ale.nix
    ./lualine.nix
    # Broken, needs to be replaced by something else with better nvim compat
    # ./ultisnips.nix
  ];

  config.programs.neovim.plugins = [
    pkgs.vimPlugins.supertab
    pkgs.vimPlugins.nerdcommenter
    pkgs.vimPlugins.vim-eunuch
    pkgs.vimPlugins.rust-vim
    pkgs.vimPlugins.vim-surround
    pkgs.vimPlugins.vim-jinja-languages
    pkgs.vimPlugins.vim-molokai-delroth
  ];
}
