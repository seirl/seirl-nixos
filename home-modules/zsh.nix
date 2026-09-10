{ config, lib, pkgs, ... }:

{
  config = {
    programs.zsh = {
      enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        ip = "ip --color=auto";
        irc = "ssh -t seirl@koin.fr tmux attach -dt irc";
        mirc = "mosh -- seirl@koin.fr tmux attach -dt irc";
        o = "zsh -c \"xdg-open $* >/dev/null 2>/dev/null &!\"";
        sizes = "zsh -c \"p=\${1:-.}; echo \$p; du -sh \$p/*(N) \$p/.*(N) | sort -h\"";
      };

      initContent = lib.mkMerge [
        (lib.mkBefore ''
          source ${pkgs.grml-zsh-config}/etc/zsh/zshrc
        '')
        (lib.mkAfter ''
          # Bind Alt+m to copy the previous word.
          autoload -Uz copy-earlier-word
          zle -N copy-earlier-word
          bindkey "^[m" copy-earlier-word

          # Disable stupid ^S and ^Q freeze
          stty -ixon
        '')
      ];
    };
  };
}
