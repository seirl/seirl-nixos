{ name, config, pkgs, ... }:

{
  networking.hostName = name;

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    pciutils
    usbutils
    binutils
    file
    tree
    python3
    ruby
    git
    wget
    htop
    mosh
    unzip
    unrar
    p7zip
    ffmpeg
    gnumake
    jq
    moreutils
    colmena
    vim_configurable
    autojump
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "boot.shell_on_fail" ];

  security.sudo.enable = true;

  programs.less.enable = true;
  programs.vim.defaultEditor = true;
  programs.zsh.enable = true;
  programs.autojump.enable = true;

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
    locate = pkgs.mlocate;
    interval = "hourly";
    localuser = null;
  };

  # Nix config
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
