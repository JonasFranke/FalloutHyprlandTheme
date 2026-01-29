{ config, pkgs, ...}: {
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "pipboy-3000";
      theme_background = false;
    };
    themes = {
      pipboy-3000 = ''
        theme[main_bg]="#${config.colorScheme.palette.base00}"
        theme[main_fg]="#${config.colorScheme.palette.base06}"
        theme[title]="#${config.colorScheme.palette.base05}"
        theme[hi_fg]="#81A1C1"
        theme[selected_bg]="#${config.colorScheme.palette.base01}"
        theme[selected_fg]="#ECEFF4"
        theme[inactive_fg]="#434C5E"
        theme[graph_text]="#${config.colorScheme.palette.base05}"
        theme[meter_bg]="#434C5E"
        theme[proc_misc]="#81A1C1"
        theme[cpu_box]="#88C0D0"
        theme[mem_box]="#A3BE8C"
        theme[net_box]="#BF616A"
        theme[proc_box]="#B48EAD"
        theme[div_line]="#${config.colorScheme.palette.base03}"
        theme[temp_start]="#BF616A"
        theme[temp_mid]="#${config.colorScheme.palette.base09}"
        theme[temp_end]="#${config.colorScheme.palette.base08}"
        theme[cpu_start]="#A3BE8C"
        theme[cpu_mid]="#${config.colorScheme.palette.base09}"
        theme[cpu_end]="#${config.colorScheme.palette.base08}"
        theme[free_start]="#A3BE8C"
        theme[free_mid]="#${config.colorScheme.palette.base08}"
        theme[free_end]="#${config.colorScheme.palette.base08}"
        theme[cached_start]="#88C0D0"
        theme[cached_mid]="#${config.colorScheme.palette.base08}"
        theme[cached_end]="#${config.colorScheme.palette.base08}"
        theme[available_start]="#EBCB8B"
        theme[available_mid]="#${config.colorScheme.palette.base09}"
        theme[available_end]="#${config.colorScheme.palette.base08}"
        theme[used_start]="#BF616A"
        theme[used_mid]="#${config.colorScheme.palette.base09}"
        theme[used_end]="#${config.colorScheme.palette.base08}"
        theme[download_start]="#88C0D0"
        theme[download_mid]="#${config.colorScheme.palette.base09}"
        theme[download_end]="#${config.colorScheme.palette.base08}"
        theme[upload_start]="#B48EAD"
        theme[upload_mid]="#${config.colorScheme.palette.base09}"
        theme[upload_end]="#${config.colorScheme.palette.base08}"
        theme[process_start]="#88C0D0"
        theme[process_mid]="#${config.colorScheme.palette.base09}"
        theme[process_end]="#${config.colorScheme.palette.base08}"
      '';
    };
  };
}
