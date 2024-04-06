# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, userSettings, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  nix.settings.experimental-features = [ "nix-command" "flakes"];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Configure keymap in X11

  services.xserver = {
    videoDrivers = ["nvidia"];
    enable = true;
    layout = "br";
    xkbVariant = "";
    windowManager = {
        i3 = {
            enable = true;
            extraPackages = with pkgs; [
                dmenu #application launcher most people use
                    i3status # gives you the default i3 status bar
                    i3lock #default i3 screen locker
                    i3blocks #if you are planning on using i3blocks over i3status
            ];
            package = pkgs.i3-gaps;
        };
    };
    desktopManager = {
      xfce = {
        enable = true;
        thunarPlugins = [ pkgs.xfce.thunar-archive-plugin ];
      };
    };
  };

# Configure console keymap
  console.keyMap = "br-abnt2";

  home-manager = {
    extraSpecialArgs = { inherit inputs; inherit userSettings; };
    users = {
      "henrique" = import ./home.nix;
    };
  };
  
  users.users.henrique = {
    isNormalUser = true;
    description = "henrique";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  # Enable automatic login for the user.
  services.getty.autologinUser = "henrique";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    home-manager
  ];

  fonts.packages = with pkgs; [
      nerdfonts
  ];
  # environment.variables.EDITOR = "kitty";
  # environment.variables.TERMINAL = "kitty";

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;

    # prime = {
      # offload = {
        # enable = true;
	# enableOffloadCmd = true;
      # };
    # };
    # powerManagement.finegrained = true;

    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 24800 ];
  networking.firewall.allowedUDPPorts = [ 24800 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  # sound

# Remove sound.enable or set it to false if you had it set previously, as sound.enable is only meant for ALSA-based configurations
# rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
# If you want to use JACK applications, uncomment this
      jack.enable = true;
  };
  users.extraUsers.henrique.extraGroups = [ "jackaudio" ];
}
