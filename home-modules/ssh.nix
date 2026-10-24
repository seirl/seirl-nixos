{ config, ... }:

{
  config.programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [ "config_local" ];
    settings = {
      "*" = {
        ControlMaster = "auto";
        AddKeysToAgent = "yes";
        ControlPersist = "yes";
        ConnectTimeout = "60";
        ServerAliveInterval = "15";
      };
    };
  };
}
