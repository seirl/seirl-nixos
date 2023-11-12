{ pkgs, poetry2nix, ... }:

{
  badeconomics-ri-notify-bot = pkgs.callPackage ./badeconomics-ri-notify-bot.nix { };
  crowdbar = pkgs.callPackage ./crowdbar.nix { inherit poetry2nix; };
  epiquote = pkgs.callPackage ./epiquote.nix { inherit poetry2nix; };
}
