{ config, ... }:

{
  config.programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [ "config_local" ];
    matchBlocks = {
      all = {
        host = "*";
        controlMaster = "auto";
        extraOptions = {
          AddKeysToAgent = "yes";
          ControlPersist = "yes";
          ConnectTimeout = "60";
          ServerAliveInterval = "15";
        };
      };
    };
  };
}
