{ lib, pkgs, ... }:

let
  my = import ../.;
in {
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Set default nixpkgs to the pinned flake-installed version.
  environment.etc.nixpkgs.source = lib.cleanSource pkgs.path;
  nix.nixPath = [ "nixpkgs=/etc/nixpkgs" ];

  # Add custom packages to overlay
  nixpkgs.overlays = [ my.pkgs ];
}
