rec {
  common = import ./common;
  roles = import ./roles;

  modules = {
    imports = [
      common
      roles
    ];
  };
}
