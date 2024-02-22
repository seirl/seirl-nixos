{ config, ... }:

{
  config.programs.ssh = {
    enable = true;
    controlMaster = "auto";
    includes = [ "config_local" ];
    matchBlocks = {
      all = {
        host = "*";
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
