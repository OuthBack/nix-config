{pkgs, ...}:
{
    polybar = pkgs.polybar.override {i3Support = true; };
}
