{
    description = "Nixos config flake";
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager/bb846c031be68a96466b683be32704ef6e07b159";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        kitty-config = {
            url = "github:OuthBack/kitty-config";
        };
        nix-ld = {
            url = "github:Mic92/nix-ld";
            inputs.nixpkgs.follows = "nixpkgs-unstable";
        };
# android-nixpkgs = {
#     url = "github:tadfisher/android-nixpkgs";
#     inputs.nixpkgs.follows = "nixpkgs";
# };
# flutter-nix = {
#     url = "github:maximoffua/flutter.nix";
#     inputs.nixpkgs.follows = "nixpkgs";
# };

    };

    outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, kitty-config, nix-ld, ... }@inputs: 

    let
    system = "x86_64-linux";

    # configure pkgs

    nixpkgs-patched =
        (import nixpkgs { system = system; }).applyPatches {
            name = "nixpkgs-patched";
            src = nixpkgs;
        };
    pkgs = import nixpkgs-patched {
        system = system;
        config = {
            allowUnfree = true;
            allowUnfreePredicate = (_: true);
        };
        overlays = [
            (self: super: {
             discord = super.discord.overrideAttrs (
                     _: { src = builtins.fetchTarball "https://discord.com/api/download?platform=linux&format=tar.gz"; }
                     );
             })
        ];
    };   

    unstable-pkgs = import nixpkgs-unstable {
        system = system;
        config.allowUnfree = true;
    };

    userSettings = {
        username = "henrique"; # username
            gitUsername = "OuthBack"; # git username
            name = "Henrique"; # name/identifier
            email = "riquessan@gmail.com"; # email (used for certain configurations)
            dotfilesDir = "~/.dotfiles"; # absolute path of the local repo
            wm = "i3"; # Selected window manager or desktop environment; must select one in both ./user/wm/ and ./system/wm/
            browser = "vivaldi"; # Default browser; must select one from ./user/app/browser/
            term = "kitty"; # Default terminal command;
            font = "Cascadia Code"; # Selected font | Cascadia Code or Jetbrains mono
            fontPkg = pkgs.cascadia-code; # Font package | cascadia-code or jetbrains-mono
            editor = "nvim"; # Default editor;
    };


    in
    {
        nixosConfigurations.default = nixpkgs.lib.nixosSystem {
            inherit system;

            specialArgs = {
                inherit inputs;
                inherit userSettings;
                inherit unstable-pkgs;
            };
            modules = [
                ./hosts/default/configuration.nix
                inputs.home-manager.nixosModules.default
                nix-ld.nixosModules.nix-ld
                { 
                    programs.nix-ld.enable = true;
                    programs.nix-ld.dev.enable = false;
                }
            ];
        };


    };
}
