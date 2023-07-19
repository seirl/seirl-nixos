{ pkgs, ... }:

{
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.printing.drivers = [ pkgs.hplipWithPlugin ];
}
