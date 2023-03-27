# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-9852e34f-d744-407f-8891-8ef5c1a28d3f".device = "/dev/disk/by-uuid/9852e34f-d744-407f-8891-8ef5c1a28d3f";
  boot.initrd.luks.devices."luks-9852e34f-d744-407f-8891-8ef5c1a28d3f".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.windowManager.qtile.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable settings for virt-manager
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with Pulseaudio
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  nixpkgs.config.pulseaudio = true;

  services.tor.enable = true;
  services.tor.client.enable = true;

  # Enable Tor
  services.tor.settings = {
    UseBridges = true;
    ClientTransportPlugin = "obfs4 exec ${pkgs.obfs4}/bin/obfs4proxy";
    Bridge = "obfs4 IP:ORPort [fingerprint]";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.allister = {
    isNormalUser = true;
    description = "allister";
    extraGroups = [ "networkmanager" "wheel" "audio" "libvirtd" ];
    packages = with pkgs; [
      tutanota-desktop
      qtile
      rofi
      networkmanagerapplet
      vim
      docker
      lsof
      gparted
      wireshark
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
      ark
      brave
      flameshot
      ungoogled-chromium
      palemoon
      vscodium
      firefox-devedition-bin
      steam-run
      firefox-bin
      clementine
      vlc
      calibre
      libreoffice-fresh
      geany
      kate
      gimp
      gnome.nautilus
      git
      wget
      obs-studio
      lxappearance-gtk2
      linux-firmware
      neofetch
      kitty
      xorg.xf86videoamdgpu
      ffmpeg
      pulseaudio
      pavucontrol
      libpulseaudio
      pamixer
      bluez
      iwd
      unzip
      ntfs3g
      libsForQt5.qt5.qtbase
      libsForQt5.qtstyleplugin-kvantum
      snapper
      libxkbcommon
      libnl
      libnsl
      sudo
      virtiofsd
      qemu-utils
      blender
      shotcut
      gpick
      krita
      xfce.thunar
      nodejs
      node2nix
      netbeans
      gcc
      gcc_debug
      gccStdenv
      libgcc
      gnome.gnome-keyring
      libgnome-keyring
      virt-manager
      hexchat
      lutris
      codeblocks
      rar2fs
      tdesktop
      qbittorrent
      lmms
      distrobox
      poetry
      devbox
      gns3-server
      gns3-gui
      jetbrains.pycharm-community
      jupyter
      pidgin
  ];

  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        sudo
      ];
    };
  };

  security.sudo.extraRules = [
    {  users = [ "allister" ];
      commands = [
         { command = "ALL" ;
           options= [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
         }
      ];
    }
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "python3.10-poetry-1.2.2"
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };



  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
