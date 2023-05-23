self: super: {
  badeconomics-ri-notify-bot = super.callPackage ./badeconomics-ri-notify-bot.nix { };
  epiquote = super.callPackage ./epiquote.nix { };
}
