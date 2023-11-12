{ pkgs, poetry2nix, ... }:

rec {
  badeconomics-ri-notify-bot = pkgs.callPackage ./badeconomics-ri-notify-bot.nix { };
  crowdbar = pkgs.callPackage ./crowdbar.nix { inherit poetry2nix; };
  epiquote = pkgs.callPackage ./epiquote.nix { inherit poetry2nix; };
  instawow = pkgs.callPackage ./instawow { };
  instawowPlugins = {
    megazygor = pkgs.callPackage ./instawow/plugins/megazygor.nix { inherit instawow; };
    tsm = pkgs.callPackage ./instawow/plugins/tsm.nix { inherit instawow; };
  };
}
