{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    # Plugins
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting = {
      enable = true;
      highlighters = [ "brackets" "regexp" ];
      styles = {
        single-hyphen-option = "fg=cyan";
        double-hyphen-option = "fg=magenta";
      };
    };
    plugins = [
      {
        name = pkgs.zsh-vi-mode.pname;
        src = pkgs.zsh-vi-mode.src;
      }
      {
        name = "zsh-window-title";
        src = pkgs.fetchFromGitHub {
          owner = "olets";
          repo = "zsh-window-title";
          rev = "v1.2.0";
          sha256 = "sha256-RqJmb+XYK35o+FjUyqGZHD6r1Ku1lmckX41aXtVIUJQ=";
        };
      }
    ];

    # zshrc
    initExtra = ''
      # nix options says to run this for some reason
      # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/programs/zsh/zsh.nix
      #prompt off

      # set prompt
      PROMPT_COLOR="green"
      PS1="  %F{$PROMPT_COLOR}λ %~ %f"

      setopt HIST_SAVE_NO_DUPS

      bindkey '^I' complete-word # tab
      bindkey '^[[Z' autosuggest-accept # shift + tab
      bindkey '^H' backward-kill-word # ctrl + backspace

      # make backward kill word do individual parts of a path
      # https://superuser.com/questions/410356/how-do-you-make-zsh-meta-delete-behave-like-bash-to-make-it-delete-a-word-inst
      export WORDCHARS=' '

      # vi mode
      #bindkey -v
      export KEYTIMEOUT=1

      zstyle ':completion:*' menu select
      zmodload zsh/complist
      _comp_options+=(globdots)
      # use vim keys in tab complete menu
      bindkey -M menuselect 'h' vi-backward-char
      bindkey -M menuselect 'k' vi-up-line-or-history
      bindkey -M menuselect 'l' vi-forward-char
      bindkey -M menuselect 'j' vi-down-line-or-history
      '';

    # Aliases
    shellAliases = {
      ll = "ls -l";
      la = "ls -a";
      l = "ls -al";
      update = "sudo nixos-rebuild switch";
      update-home = "home-manager switch";
      u = "sudo nixos-rebuild switch";
      uh = "home-manager switch";

      # Git
      gs = "git status";
      ga = "git add";
      gb = "git branch";
      gr = "git branch -r";
      gp = "git push";
      gpo = "git push origin";
      gplo = "git pull origin";
      gc = "git commit";
      gd = "git diff";
      gco = "git checkout";
      gl = "git log";
      grs = "git remote show";
      glo = "git log --pretty=oneline";
      glol = "git log --graph --online --decorate";
    };

    history.size = 10000;
  };
}
