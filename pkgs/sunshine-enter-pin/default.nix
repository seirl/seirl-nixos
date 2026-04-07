{ lib, writeShellApplication, curl, jq }:

writeShellApplication {
  name = "sunshine-enter-pin";
  runtimeInputs = [ curl jq ];
  text = builtins.readFile ./sunshine-enter-pin;
}
