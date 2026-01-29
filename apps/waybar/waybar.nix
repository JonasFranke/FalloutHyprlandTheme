{ config, pkgs, ... }: {
  programs.waybar = {
    enable = true;
    settings.mainBar = {
      layer = "bottom";
      position = "top";
      height = 34;
      modules-left = [ "hyprland/workspaces" "custom/pv" "custom/plug" ];
      modules-center = [ "custom/spotify" "clock" "custom/weather" ];
      modules-right = [ "cpu" "memory" "network" "pulseaudio" "custom/shutdown" ];

      "cpu" = {
        interval = 10;
        format = " {usage}%";
      };

      "memory" = {
        interval = 10;
        format = " {used}/{total}GB";
      };

      "network" = {
        format-wifi = " {essid} ({signalStrength}%) ↑ {bandwidthUpBytes} | ↓ {bandwidthDownBytes}";
        format = "{ifname}";
        tooltip-format = "{ifname}: {essid}@{frequency}GHz: {ipaddr}";
        interval = 30;
      };

      "clock" = {
        format = "{:%d.%m.%Y %H%Mh}";
        tooltip-format = "<tt><small>{calendar}</small></tt>";
      };

      "pulseaudio" = {
        format = " {volume}%";
        format-bluetooth = " {volume}% ";
        format-muted = "";
        on-click-right = "pavucontrol";
        on-click = "blueman-manager";
      };

      "hyprland/workspaces" = {
        format = "{icon} {windows}";
        format-window-separator = " ";
        window-rewrite-default = "";
        window-rewrite = {
          "title<.*youtube.*>" = "";
          "title<.*github.*>" = "";
          "title<.*twitch.*>" = "󰕃";
          "title<.*Home Assistant.*>" = "󰟐";
          "class<zen-beta>" = "󰐾";
          "class<spotify>" = "";
          "class<com.mitchellh.ghostty>" = "";
          "class<discord>" = "";
          "class<steam>" = "󰓓";
          "class<jetbrains-idea>" = "";
          "class<prusa-slicer>" = "";
          "class<nemo>" = "";
        };
      };

      "custom/pv" = {
        format = "PV: {text}W";
        exec =
          "HASS_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJkMmNjODc0NjQ4OTU0MWI1ODU5MmIwMDNlMDNiNGQ0OSIsImlhdCI6MTc1MzM2Nzc1NCwiZXhwIjoyMDY4NzI3NzU0fQ.-_WMzoSGNrkQHFl_y-Umpz24AQnQw-c4Sr2GlYgl0Sc /home/jonas/.config/waybar/waybar-hass sensor.pv_gesamt";
        return-type = "json";
        interval = 60;
      };

      "custom/plug" = {
        format = "{text}W";
        exec =
          "HASS_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJkMmNjODc0NjQ4OTU0MWI1ODU5MmIwMDNlMDNiNGQ0OSIsImlhdCI6MTc1MzM2Nzc1NCwiZXhwIjoyMDY4NzI3NzU0fQ.-_WMzoSGNrkQHFl_y-Umpz24AQnQw-c4Sr2GlYgl0Sc /home/jonas/.config/waybar/waybar-hass sensor.smarte_steckdose_derzeitiger_verbrauch";
        return-type = "json";
        interval = 60;
      };

      "custom/shutdown" = {
        format = "🔌";
        tooltip = "Shutdown, Reboot, Logout";
        on-click =
          "rofi -show power-menu -modi power-menu:rofi-power-menu --choices=shutdown/reboot";
      };

      "custom/weather" = {
        format = "{text}";
        exec =
          "HASS_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJkMmNjODc0NjQ4OTU0MWI1ODU5MmIwMDNlMDNiNGQ0OSIsImlhdCI6MTc1MzM2Nzc1NCwiZXhwIjoyMDY4NzI3NzU0fQ.-_WMzoSGNrkQHFl_y-Umpz24AQnQw-c4Sr2GlYgl0Sc /home/jonas/.config/waybar/waybar-hass weather.bremen";
        return-type = "json";
        interval = 600;
      };

      "custom/spotify" = {
        format = " {text}";
        exec =
          "playerctl --player=spotify metadata --format '{\"text\": \"{{ title }} by {{ artist }}\"}'";
        return-type = "json";
        interval = 5;
      };
    };

    style = ''
      window#waybar {
        background-color: transparent;
      }

      #clock,
      #cpu,
      #memory,
      #network,
      #pulseaudio,
      #custom-shutdown,
      #custom-pv,
      #custom-plug,
      #custom-weather,
      #custom-spotify {
        padding: 0 10px 0 10px;
        margin: 0 5px 0 5px;
        border-radius: 18px;
        opacity: 1;
        font-family: "FiraCode Nerd Font Mono", "JetBrains Mono", monospace;
        font-size: 12px;
        font-weight: bold;
        color: #${config.colorScheme.palette.base05};
      }

      
      #clock,
      #network,
      #cpu,
      #memory,
      #pulseaudio,
      #custom-shutdown,
      #custom-spotify {
        color: #${config.colorScheme.palette.base05};
        background-color: #${config.colorScheme.palette.base01};
      }
      
      #workspaces button {
        color: #${config.colorScheme.palette.base05};
        background: transparent;
        border-radius: 5px;
        margin: 0 5px 0 5px;
      }

      #workspaces button.active {
        color: #${config.colorScheme.palette.base00};
        background: #${config.colorScheme.palette.base05};
      }
    '';
  };

  home.file = {
    "/home/jonas/.config/waybar/waybar-hass".source = ./waybar-hass;
  };
}
