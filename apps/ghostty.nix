{ config, pkgs, ... }: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      font-family = "FiraCode Nerd Font";
      background = "#${config.colorScheme.palette.base00}";
      foreground = "#${config.colorScheme.palette.base05}";
      selection-background = "#${config.colorScheme.palette.base05}";
      selection-foreground = "#${config.colorScheme.palette.base00}";
      cursor-color = "#${config.colorScheme.palette.base05}";
      cursor-style = "block";
    };
  };
}
