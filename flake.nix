{
    description = "Nixos config flake";
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager/0b491b460f52e87e23eb17bbf59c6ae64b7664c1";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        kitty-config = {
            url = "github:OuthBack/kitty-config";
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

    outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, kitty-config, ... }@inputs: 

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
            ];
        };


    };
}
