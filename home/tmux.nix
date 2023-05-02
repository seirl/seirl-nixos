{ config, ... }:

{
  config.programs.tmux = {
    enable = true;
    escapeTime = 0; # Fix vim ESC delay
    baseIndex = 1; # Start window numbering at 1
    terminal = "screen-256color";
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    clock24 = true;
  };
}
