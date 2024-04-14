{ pkgs, userSettings, lib, ... }:

{
  imports = [
    ../../modules/home-manager/shell.nix
    ../../modules/home-manager/neovim.nix
    ../../modules/home-manager/git.nix
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "henrique";
  home.homeDirectory = "/home/henrique";
 
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  # Define a user account. Don't forget to set a password with ‘passwd’.

  home.packages = with pkgs;
    let
      polybar = pkgs.polybar.override {
        i3Support = true;
      };
    in
  [

    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

      vivaldi
      git
      gcc_multi
      i3
      kitty
      picom
      tmux
      clipmenu
      polybar
      rofi
      flameshot
      oh-my-zsh
      fzf
      ripgrep
      barrier
      bitwarden
      nodejs_21
      cargo
      libreoffice
      obsidian
      rclone
      postman
      #sound
      qjackctl
      pavucontrol
      spotify
      # discord
      # Using vesktop for discord
      vesktop
      xfce.thunar
      xfce.thunar-archive-plugin
      xarchiver
      gimp
      obs-studio
      vlc
      gparted
      dunst
      libnotify
  ];
  
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".config/kitty" = {
        source = "/etc/nixos/extra/kitty";
        recursive = true;
    };

  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/root/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = userSettings.editor;
    TERM = userSettings.term;
    BROWSER = userSettings.browser;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Allow unfree
  nixpkgs.config.allowUnfree = true;

  }
