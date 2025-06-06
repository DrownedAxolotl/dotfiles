{ config, pkgs, ... }:


{
  imports = [ ./hardware-configuration.nix ];
  # Bootloader configuration
  boot.loader = {
    grub = {
      enable = true;
      device = "nodev"; # or "/dev/sda" for MBR
      efiSupport = true;
      useOSProber = true;
    };
    efi.canTouchEfiVariables = true;
  };


  # Filesystem support
  boot.supportedFilesystems = [ "ntfs" ];


  # Hostname
  networking.hostName = "leni";
  
  # NetworkManager for WiFi
  networking.networkmanager.enable = true;

  # Disable automatic updates
  system.autoUpgrade.enable = false;

  # Disable SSH by default
  services.openssh.enable = false;

  # Bluetooth support setup
  hardware.bluetooth.enable = true;

  # Sudo configuration
  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
  };


  hardware = {

   opengl = {
     enable = true;
     driSupport32Bit = true;

     };
    # Nvidia configuration (PRIME offloading)
    nvidia = {
      modesetting.enable = true;  # Required for tear-free
      powerManagement.enable = true;
      nvidiaSettings = true;

      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = "PCI:0:2:0";  # Replace with your bus ID
        nvidiaBusId = "PCI:1:0:0";  # Replace with your bus ID
      };

      # Force Full Composition Pipeline (eliminates tearing)
      forceFullCompositionPipeline = true;
    };
    };

  environment.systemPackages = with pkgs; [
    vim
    neofetch
    btop
    git
    sxhkd
    xorg.xinit
 ];


 time.timeZone = "Europe/Berlin";

  nixpkgs.config.allowUnfree = true;
  # User configuration
  users.users.filip = {
    isNormalUser = true;
    description = "Filip";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "network" ];
    packages = with pkgs; [
      # WM components
      rofi
      alacritty
      dwarf-fortress
      feh
      lf
      bluetuith
      cmatrix
      onlyoffice-desktopeditors
      brave
      signal-desktop
      flameshot
      shortwave
      xfce.thunar
    ];
  };


  # Sound with PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };


  # Display manager (SDDM)
  services.xserver = {
    enable = true;
    dpi = 130;
    deviceSection = ''
      Option "DRI" "3"
      Option "TearFree" "true" 
    '';
    videoDrivers = [ "nvidia" ];
    displayManager.sddm = {
      enable = true;
    };
    desktopManager = {
      xterm.enable = false;
    };
    windowManager.herbstluftwm.enable = true;
  };

  # Use the regular kernel
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_latest; # Use the correct kernel version
  boot.kernelModules = [ "i915" "nvidia" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ nvidia_x11 ];
  # DO NOT CHANGE STATE VERSION
  system.stateVersion = "25.05";
}
