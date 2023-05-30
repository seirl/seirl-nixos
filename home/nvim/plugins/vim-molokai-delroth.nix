{ pkgs, ... }:

let
  vim-molokai-delroth = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "vim-molokai-delroth";
    src = pkgs.fetchFromGitHub {
      owner = "delroth";
      repo = "vim-molokai-delroth";
      rev = "134cf0f10117376fab713d42c53418ff31c045c6";
      sha256 = "sha256-g/0bkSBTKFykt4/k+fV+XSErAPDkf+cu4sLGoX5VsQ0=";
    };
  };
in
{
  config.programs.neovim.plugins = [
    vim-molokai-delroth
  ];
}
