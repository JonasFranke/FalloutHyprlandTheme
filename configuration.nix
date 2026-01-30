# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:
let
  theme = import ./theme.nix;
  palette = theme.palette;
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./cachix.nix
  ];

  # Bootloader.
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      theme = inputs.nixos-grub-themes.packages.${pkgs.stdenv.hostPlatform.system}.fallout;
    };
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Flakes
  nix.settings = { experimental-features = [ "nix-command" "flakes" ]; };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command =
          "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd start-hyprland";
        user = "jonas";
      };
    };
  };

  environment.pathsToLink = [ "/share/zsh" "/share/applications" "/share/xdg-desktop-portal" ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
    ];
  };

  services.gnome.gnome-keyring.enable = true;

  programs.hyprland.enable = true;

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "i965";
    NVIDIA_DRIVER_CAPABILITIES = "all";
    WLR_HDR_OUTPUTS = "1";
    NIXOS_OZONE_WL = "1";
    SSH_AUTH_SOCK = "/run/user/1000/gnupg/S.gpg-agent.ssh";
  }; # Force intel-media-driver

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:00:0";
      # sync.enable = true;
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };

  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "nodeadkeys";
  };

  # Configure console keymap
  console.keyMap = "de-latin1-nodeadkeys";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jonas = {
    isNormalUser = true;
    description = "Jonas";
    extraGroups = [ "networkmanager" "wheel" "docker" "adbusers" ];
    packages = with pkgs; [ ];
  };

  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      intel-vaapi-driver =
        pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
    };
  };

  users.defaultUserShell = pkgs.zsh;

  programs.java.enable = true;

  programs.direnv.enable = true;

  # Tmux
  programs.tmux = {
    enable = true;
    clock24 = true;
  };

  environment.sessionVariables.EDITOR = "nvim";

  # Bluetooth
  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  virtualisation.docker.enable = true;

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # nixpkgs.config.allowBroken = true;

  # system.autoUpgrade.enable = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    gh
    curl
    spotify
    # modrinth-app
    git
    jq
    oh-my-zsh
    zoxide
    usbutils
    fzf
    networkmanagerapplet
    unstable.neovim
    unstable.ghostty
    jetbrains.webstorm
    jetbrains.idea
    unstable.discord
    ripgrep
    fd
    heroic
    unstable.localsend
    btop
    nvtopPackages.nvidia
    gnumake
    gccgo
    fastfetch
    chromium
    gradle
    lua
    python314
    unstable.bun
    biome
    nodejs
    glfw
    cargo
    rustc
    unzip
    zip
    ffmpeg
    libreoffice-qt6-fresh
    lshw
    rpi-imager
    appimage-run
    unstable.prusa-slicer
    signal-desktop
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.beta
    iperf
    wl-clipboard
    rsync
    p7zip
    protontricks
    unstable.gemini-cli
    nextcloud-client
    hyprpaper
    hypridle
    hyprshot
    hyprsunset
    hyprnotify
    hyprpolkitagent
    brightnessctl
    rofi
    rofi-power-menu
    pavucontrol
    playerctl
    unstable.esptool
    nemo
    zoom-us
    keychain
    cachix
    gimp
    rustdesk
    handbrake
    vlc
    mkvtoolnix
    ansible
    losslesscut-bin
    anki
  ];

  # Virt manager
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ "jonas" ];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    fira-code-symbols
    times-newer-roman
    montserrat
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.tailscale.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 5173 3000 ];
  };
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
