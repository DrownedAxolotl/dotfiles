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
  networking.hostName = "milenko";
  
  # NetworkManager for WiFi
  networking.networkmanager.enable = true;

  # Disable automatic updates
  system.autoUpgrade.enable = false;

  # Disable SSH by default
  services.openssh.enable = false;

  # Sudo configuration
  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
  };

 hardware.opengl = {
  enable = true;
  driSupport32Bit = true;

 };

  environment.systemPackages = with pkgs; [
    vim
    neofetch
    ventoy
    btop
    git
    appimage-run
    bspwm
    sxhkd
    xorg.xinit
 ];


/*
  let
  rt8821au = pkgs.callPackage ./rtl8821au.nix { 
    linuxKernel = config.boot.kernelPackages;
  };
*/

/*
  # Internet dongle setup
  boot.extraModulePackages = with config.boot.kernelPackages; [
    rtl8821au
  ];
*/
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
      cmatrix
      onlyoffice-desktopeditors
      openmw
      wine
      discord
      # Applications
      (pkgs.callPackage ./prismlauncher-wrapper.nix {})
      (pkgs.callPackage ./zen.nix {})
      
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
    deviceSection = ''Option "TearFree" "true"''; # For amdgpu :cite[1]
    videoDrivers = [ "amdgpu" ];
    displayManager.sddm = {
      enable = true;
    };
    desktopManager = {
      xterm.enable = false;
    };
    desktopManager.plasma6 = {
     enable = true;
    };
    windowManager.herbstluftwm.enable = true;
  };

  # Use the regular kernel
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_5_15; # Use the correct kernel version
  boot.extraModulePackages = with config.boot.kernelPackages; [ rtl8821au ];
  # DO NOT CHANGE STATE VERSION
  system.stateVersion = "24.11";
}
