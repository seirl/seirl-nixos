{ name, config, pkgs, ... }:

{
  networking.hostName = name;

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    pciutils
    usbutils
    file
    python3
    ruby
    git
    wget
    htop
    mosh
    unrar
    p7zip
    ffmpeg
    gnumake
    jq
    moreutils
    colmena
    vim_configurable
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  security.sudo.enable = true;

  # SUID wrappers
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
  };
  programs.ssh.startAgent = true;

  # Services
  services.openssh.enable = true;
}
