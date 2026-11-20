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
    (pkgs.vimPlugins.vim-molokai-delroth.overrideAttrs {
      src = pkgs.fetchFromGitHub {
        owner = "seirl";
        repo = "vim-molokai-delroth";
        rev = "41bac1c5a0cbc24f8e48eb6d63d63394ec0c89b3";
        hash = "sha256-T293HAfXCtV94owf9UottzCZUun0KACKwXe5C8eyr+o=";
      };
    })
  ];
}
