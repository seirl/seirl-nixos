{ config, lib, ... }:

{
  config.programs.mercurial = {
    enable = lib.mkDefault true;
    userName = "Antoine Pietri";
    userEmail = "antoine.pietri1@gmail.com";
    extraConfig = {
      ui = {
        verbose = true;
      };
      extensions = {
        color = "";
        fetch = "";
        hgk = "";
        histedit = "";
        mq = "";
        rebase = "";
      };
    };
  };
}
