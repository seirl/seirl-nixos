rec {
  common = import ./common;
  roles = import ./roles;
  home = import ./home;
  pkgs = import ./pkgs;

  modules = {
    imports = [
      common
      roles
    ];
  };
}
