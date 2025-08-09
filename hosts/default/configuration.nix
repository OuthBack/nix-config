# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, unstable-pkgs, userSettings, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  boot.loader = {
      efi = {
          canTouchEfiVariables = true;
      };
      grub = {
          enable = true;
          devices = [ "nodev" ];
          efiSupport = true;
          useOSProber = true;
    };
};

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  nix.settings.experimental-features = [ "nix-command" "flakes" "dynamic-derivations"];

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
    xkb = {
        layout = "us";
        variant = "intl";
    };
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
  };

# Configure console keymap
  console.keyMap = "br-abnt2";

  home-manager = {
    extraSpecialArgs = { inherit inputs; inherit userSettings; inherit unstable-pkgs; };
    users = {
      "henrique" = import ./home.nix;
    };
  };
  
  users.users.henrique = {
    isNormalUser = true;
    description = "henrique";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;
  programs.thunar.plugins = [ pkgs.xfce.thunar-archive-plugin ]; 
  programs.nix-ld.enable = true;
  programs.nix-ld.dev.enable = false;

  # Enable automatic login for the user.
  services.getty.autologinUser = "henrique";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = let 
    stable = with pkgs; [
        wget
        home-manager
    ];
    unstable = with unstable-pkgs; [
        neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    ];
  in stable ++ unstable;

  fonts.packages = [] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  # environment.variables.EDITOR = "kitty";
  # environment.variables.TERMINAL = "kitty";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
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

  services.avahi.enable = true;
  services.avahi.nssmdns = true;
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
  system.stateVersion = "24.05"; # Did you read the comment?

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
  virtualisation = { 
      oci-containers = {
          backend = "docker";
      };
      docker = { 
          enable = true;
          rootless = {
              enable = true;
              setSocketVariable = true;
          };
          daemon.settings = {
# data-root = "";
          };
      };
  };
}
