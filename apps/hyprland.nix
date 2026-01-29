{inputs, pkgs, config, ...}: {

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    settings = {
      monitor = [ "eDP-1,preferred,auto,1" "HDMI-A-1,2560x1440@120,auto,auto" "DP-1, disable"];
      "$mod" = "SUPER";
      "$terminal" = "ghostty";
      "$fileManager" = "nautilus";
      "$menu" = "rofi -show drun";
      "$browser" = "zen-beta";

      exec-once = [
        "$terminal"
        "$browser"
        "hyprpaper & waybar & hypridle & hyprsunset -t 5200"
        "systemctl --user start hyprpolkitagent"
      ];

      env = [ "XCURSOR_SIZE,12" "HYPRCURSOR_SIZE,12" "NIXOS_OZONE_WL,1" ];

      general = {
        gaps_in = 2;
        gaps_out = 6;
        border_size = 2;
        "col.active_border" = "0xff${config.colorScheme.palette.base05}";
        "col.inactive_border" = "0xff${config.colorScheme.palette.base01}";
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 8;
        rounding_power = 4;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "0xee${config.colorScheme.palette.base05}";
        };
        blur = {
          enabled = true;
          size = 2;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];
        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = { new_status = "master"; };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      input = {
        kb_layout = "de";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = { natural_scroll = false; };
      };

      bind = [
        "$mod, Q, exec, $terminal"
        "$mod, C, killactive,"
        "$mod, M, exit,"
        "$mod, E, exec, $fileManager"
        "$mod, V, togglefloating,"
        "$mod, R, exec, $menu"
        "$mod, B, exec, $browser"
        "$mod, P, pseudo,"
        "$mod, J, togglesplit,"
        "$mod, X, exec, spotify"
        "$mod, L, exec, hyprlock"
        "$mod, G, exec, hyprshot -m region --clipboard-only"

        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"

        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ] ++ (builtins.concatLists (builtins.genList (i:
        let ws = i + 1;
        in [
          "$mod, code:1${toString i}, workspace, ${toString ws}"
          "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
        ]) 9));

      bindm = [ "$mod, mouse:272, movewindow" "$mod, mouse:273, resizewindow" ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      windowrule = [
        "match:class ^(zen-beta)$, monitor 1"
        "match:class ^(zen-beta)$, no_blur on"
        "match:class ^(com.mitchellh.ghostty)$, monitor 0"
        "match:class .*, suppress_event maximize"
        #"match:class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0 ,no_focus"
      ];
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "/home/jonas/312306.jpg" ];
      wallpaper = [ ",/home/jonas/312306.jpg" ];
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      "$font" = "Monospace";
      general = { hide_cursor = false; };

      animations = {
        enabled = true;
        bezier = "linear, 1, 1, 0, 0";
        animation = [
          "fadeIn, 1, 5, linear"
          "fadeOut, 1, 5, linear"
          "inputFieldDots, 1, 2, linear"
        ];
      };

      background = {
        path = "screenshot";
        blur_passes = 5;
      };

      input-field = {
        size = "20%, 5%";
        outline_thickness = 3;

        inner_color = "rgba(0, 0, 0, 0.8)"; 
        outer_color = "rgb(${config.colorScheme.palette.base05}) rgb(${config.colorScheme.palette.base01}) 45deg";
        check_color = "rgb(${config.colorScheme.palette.base06}) rgb(${config.colorScheme.palette.base05}) 120deg";
        fail_color = "rgb(${config.colorScheme.palette.base08}) rgb(770000) 40deg";
        font_color = "rgb(${config.colorScheme.palette.base05})";
        
        placeholder_text = "<i>ENTER PASSWORD...</i>";

        fade_on_empty = false;
        rounding = 15;

        font_family = "$font";
        fail_text = "$PAMFAIL";

        dots_spacing = 0.3;

        position = "0, -20";
        halign = "center";
        valign = "center";
      };

      label = [
        {
          text = "$TIME";
          font_size = 90;
          font_family = "$font";
          position = "-40, 0";
          halign = "right";
          valign = "top";
        }
        {
          text = "cmd[update:60000] date +'%A, %d %B %Y'";
          font_size = 35;
          font_family = "$font";
          position = "-30, -150";
          halign = "right";
          valign = "top";
        }
      ];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock";
      };

      listener = [
        {
          timeout = 900;
          on-timeout = ''
            if [ "$(playerctl --player=firefox status)" = "Paused" ]; then hyprlock; fi'';
        }
        {
          timeout = 1200;
          on-timeout = ''
            if [ "$(playerctl --player=firefox status)" = "Paused" ]; then hyprctl dispatch dpms off; fi'';
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}

