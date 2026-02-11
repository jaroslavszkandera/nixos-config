{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jarek-nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Prague";
  i18n.defaultLocale = "en_US.UTF-8";

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  users.users.jarek = {
    isNormalUser = true;
    description = "jarek";
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs; [
      tree
      htop
      direnv
    ];
  };

  environment.systemPackages = with pkgs; [
    # General
    vim neovim git rsync wget curl unzip

    # Build tools
    pkg-config
    rustup
    gnumake
    gcc
    clang
    ccache
    mold

    # Libraries
    fontconfig
    fontconfig.dev
    freetype
    freetype.dev
    expat
    openssl
    openssl.dev
  ];

  environment.variables = {
    PKG_CONFIG_PATH = lib.makeSearchPath "lib/pkgconfig" [
      pkgs.fontconfig.dev
      pkgs.freetype.dev
      pkgs.openssl.dev
    ];
    
    LD_LIBRARY_PATH = lib.makeLibraryPath [
      pkgs.fontconfig
      pkgs.freetype
      pkgs.expat
      pkgs.openssl
    ];
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  system.copySystemConfiguration = true;
  system.stateVersion = "25.11";
}

