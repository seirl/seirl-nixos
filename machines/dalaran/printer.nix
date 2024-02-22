{ pkgs, ... }:

{
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };
  services.printing.drivers = [ pkgs.hplipWithPlugin ];
}
