Build a package for local testing:

    nix-build -E 'with import <nixpkgs> {}; callPackage ./packageName.nix {}'
