self: super: {
  badeconomics-ri-notify-bot = super.callPackage ./badeconomics-ri-notify-bot.nix { };
  crowdbar = super.callPackage ./crowdbar.nix { };
  epiquote = super.callPackage ./epiquote.nix { };
}
