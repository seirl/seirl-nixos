{ config, ... }:

{
  config.programs.git = {
    enable = true;

    settings = {
      user.name = "Antoine Pietri";
      user.email = "antoine.pietri1@gmail.com";

      aliases = {
        graph = "log --all --graph --decorate --abbrev-commit --pretty=oneline";
      };

      pull.rebase = true;
      push.followTags = true;
      merge.ff = "only";
      rebase.autostash = true;
      branch.autosetuprebase = "always";

      fetch = {
        recursesubmodules = true;
        prune = true;
        prunetags = true;
      };

      color = {
        branch = "auto";
        diff = "auto";
        status = "auto";
      };

      "color \"branch\"" = {
        current = "yellow reverse";
        local = "yellow";
        remote = "green";
      };
      "color \"diff\"" = {
        meta = "yellow bold";
        frag = "magenta bold";
        old = "red bold";
        new = "green bold";
      };
      "color \"status\"" = {
        added = "yellow";
        changed = "green";
        untracked = "cyan";
      };

      diff = {
        png = {
          textconv = "identify -verbose";
          binary = true;
        };
      };

      core.commitGraph = true;
      gc.writeCommitGraph = true;
    };

    ignores = [
      "*.aux"
      "*.ipynb"
      "*.log"
      "*.pyc"
      ".*.swp"
      ".syntastic_cpp_config"
      "__pycache__"
      "pip-wheel-metadata"
    ];
  };
}
