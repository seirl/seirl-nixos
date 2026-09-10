{ pkgs, ... }:

{
  programs.neovim = {
    plugins = [
      { plugin = pkgs.vimPlugins.ultisnips; }
      { plugin = pkgs.vimPlugins.vim-snippets; }
    ];

    extraConfig = ''
      let g:UltiSnipsSnippetDirectories = [ '${./snippets}' ]
    '';
  };
}
