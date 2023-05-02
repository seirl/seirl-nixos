{ config, ... }:

{
  config.programs.mercurial = {
    enable = true;
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
