{ config, pkgs, inputs, system, ... }: {
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # https://nixos.wiki/wiki/AMD_GPU#Make_the_kernel_use_the_correct_driver_early
  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    extraPackages = [
      pkgs.amdvlk
      pkgs.rocmPackages.clr.icd
    ];
    extraPackages32 = [
      pkgs.driversi686Linux.amdvlk
    ];
  };

  # https://nixos.wiki/wiki/Bluetooth#Enabling_Bluetooth_support
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot= true;

  networking.hostName = "zaer1n";
  networking.networkmanager.enable = true;
  # AudioRelay uses ports 59100 for server discovery, 59200 for audio transport. (Local Server -> PC)
  networking.firewall.allowedUDPPorts = [ 59100 59200 ];

  # Auto mount/unmount drives
  services.gvfs.enable = true;

  # https://nixos.wiki/wiki/PipeWire#Enabling_PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;    
  };

  users.users."zaer1n" = {
    isNormalUser = true;
    description = "zaer1n";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  
  time.timeZone = "Europe/Istanbul";
  i18n.defaultLocale = "en_US.UTF-8";

  nix.settings.experimental-features = [ "nix-command" "flakes" ]; 
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [
    pkgs.home-manager
    pkgs.vim
    pkgs.tree
  ];

  # https://wiki.hyprland.org/Nix/Hyprland-on-NixOS/
  programs.hyprland.enable = true;
  # Hint Electron apps to use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # https://nixos.wiki/wiki/Steam#Install
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  system.stateVersion = "24.05";
}