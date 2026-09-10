{ pkgs, ... }:

{
  programs.neovim = {
    plugins = [{
      plugin = pkgs.vimPlugins.lualine-nvim;
      type = "lua";
      config = ''
        require('lualine').setup { options = {
          theme = 'codedark',
          icons_enabled = false,
          section_separators = ''',
          component_separators = ''',
        } }
      '';
    }];
  };
}
