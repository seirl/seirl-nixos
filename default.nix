rec {
  common = import ./common;
  roles = import ./roles;
  home = import ./home;

  modules = {
    imports = [
      common
      roles
    ];
  };
}
