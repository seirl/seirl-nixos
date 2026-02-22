{ pkgs, uv2nix, pyproject-nix, pyproject-build-systems, ... }:

rec {
  badeconomics-ri-notify-bot = pkgs.callPackage ./badeconomics-ri-notify-bot.nix { };
  crowdbar = pkgs.callPackage ./crowdbar.nix { };
  epiquote = pkgs.callPackage ./epiquote.nix {
    inherit uv2nix pyproject-nix pyproject-build-systems;
  };
  instawow = pkgs.callPackage ./instawow { };
  instawowPlugins = {
    megazygor = pkgs.callPackage ./instawow/plugins/megazygor.nix {
      inherit instawow;
    };
    tsm = pkgs.callPackage ./instawow/plugins/tsm.nix { inherit instawow; };
  };
}
