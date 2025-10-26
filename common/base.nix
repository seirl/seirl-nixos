{ name, config, pkgs, ... }:

{
  networking.hostName = name;

  environment.systemPackages = with pkgs; [
    pciutils
    usbutils
    binutils
    inetutils
    file
    tree
    python3
    moreutils
    dig
    reptyr
    git
    wget
    htop
    unzip
    unrar
    p7zip
    ffmpeg-full
    gnumake
    jq
    colmena
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "boot.shell_on_fail" ];

  security.sudo.enable = true;

  programs.less.enable = true;
  programs.mosh.enable = true;

  # Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # Zsh
  programs.zsh.enable = true;
  programs.autojump.enable = true;
  environment.pathsToLink = [ "/share/zsh" ];

  # SUID wrappers
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
  };
  programs.ssh.startAgent = true;

  # Services
  services.openssh.enable = true;
  services.locate = {
    enable = true;
    package = pkgs.mlocate;
    interval = "hourly";
  };

  # MDMonitor fix
  boot.swraid.mdadmConf = ''
    MAILADDR root
  '';
}
