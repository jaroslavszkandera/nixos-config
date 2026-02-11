{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./hardware-configuration.nix];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  networking.hostName = "jarek-nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Prague";
  i18n.defaultLocale = "en_US.UTF-8";

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  users.users.jarek = {
    isNormalUser = true;
    description = "jarek";
    extraGroups = ["wheel" "networkmanager"];
    packages = with pkgs; [
      tree
      htop
      direnv
      neofetch
      ripgrep
      fd
    ];
  };

  environment.systemPackages = with pkgs; [
    # General
    vim
    neovim
    git
    rsync
    wget
    curl
    unzip

    # Build tools
    rustup
    gnumake
    gcc
    clang
    ccache
    mold

    # Libraries
    pkg-config
    openssl
  ];

  system.stateVersion = "25.11";
}
