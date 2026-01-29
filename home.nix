{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jonas";
  home.homeDirectory = "/home/jonas";

  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [ ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = { };

  home.sessionVariables = { };

  imports = [
    ./apps/hyprland.nix
    ./apps/ghostty.nix
    ./apps/waybar/waybar.nix
    ./apps/zsh.nix
    ./apps/rofi.nix
    ./apps/btop.nix
  ];

  colorScheme = {
    slug = "pipboy";
    name = "Pip-Boy 3000";
    author = "Vault-Tec";
    palette = {
      base00 = "000000"; # Background (Pure Black)
      base01 = "0a2a1a"; # Lighter Background (Dark Green - Inactive Panes)
      base02 = "143825"; # Selection Background
      base03 = "333333"; # Comments / Dimmed Text
      base04 = "1eff00"; # Dark Foreground
      base05 = "1eff00"; # Default Text (Vivid Pip-Boy Green)
      base06 = "20ff05"; # Light Foreground
      base07 = "1eff00"; # Light Background
      base08 = "ff0000"; # Red (Critical/Error/Rad Warning)
      base09 = "ffb642"; # Orange -> Forced Green
      base0A = "1eff00"; # Yellow -> Forced Green
      base0B = "1eff00"; # Green -> Forced Green
      base0C = "1eff00"; # Cyan -> Forced Green
      base0D = "1eff00"; # Blue (Focus/Accent) -> Forced Green
      base0E = "1eff00"; # Purple -> Forced Green
      base0F = "1eff00"; # Brown -> Forced Green
    };
  };

  services.ssh-agent.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
