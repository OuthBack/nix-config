{userSettings, ...}:
{
    programs.git = {
        enable = true;
        userName = userSettings.gitUsername;
        userEmail = userSettings.email;
        extraConfig = {
            init.defaultBranch = "main";
            init.safeDirectory = "/etc/nixos";
        };
    };
}
