{ lib, pkgs, ... }: with lib;

let
  aleFixers = {
    c = [ [ "clang-format" pkgs.clang ] ];
    cpp = [ [ "clang-format" pkgs.clang ] ];
    go = [ [ "gofmt" pkgs.go ] ];
    nix = [ [ "nixpkgs-fmt" pkgs.nixpkgs-fmt ] ];
    python = [ [ "black" pkgs.black ] ];
    rust = [ [ "rustfmt" pkgs.rustfmt ] ];
  };
  aleLinters = {
    python = [
      [ "pyright" pkgs.pyright ]
      [ "flake8" pkgs.python3Packages.flake8 ]
    ];
    rust = [ [ "analyzer" [ pkgs.rust-analyzer pkgs.rustc ] ] ];
  };
  mapListForLang = lang: l: "'${lang}': [${concatMapStringsSep ", " (f: "'${elemAt f 0}'") l}]";
  extractPackages = mapAttrsToList (lang: x: map (f: elemAt f 1) x);
in
{
  programs.neovim = {
    extraPackages = (flatten (map extractPackages [ aleFixers aleLinters ]));

    plugins = [{
      plugin = pkgs.vimPlugins.ale;
      config = ''
        let g:ale_fixers = {${concatStringsSep ", " (mapAttrsToList mapListForLang aleFixers)}}
        let g:ale_linters = {${concatStringsSep ", " (mapAttrsToList mapListForLang aleLinters)}}
      '';
    }];
  };
}
