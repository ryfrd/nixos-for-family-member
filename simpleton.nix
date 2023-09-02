{ pkgs, config, ... }: {

  # allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # automatic nix garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
  };

  nix.settings = {
    # enable flakes
    experimental-features = "nix-command flakes";
    # saves some disk space
    auto-optimise-store = true;
    # allows remote rebuild
    trusted-users = [ "james" ];
  };

  # auto update system
  system.autoUpgrade = {
    enable = true;
    dates = "daily";
    flake = "${config.users.users.lizzie.home}/.config/simpleton/";
    flags = [
      "--update-input" "nixpkgs"
    ];
    allowReboot = true;
  };

  # bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # firewall !!!
  networking.firewall.enable = true;

  # ssh access
  services.openssh = {
    enable = true;
    settings = {
      passwordAuthentication = false;
      permitRootLogin = "no";
    };
  };
  # open ssh port
  networking.firewall.allowedTCPPorts = [ 97 ];

  # tailscale daemon
  services.tailscale.enable = true;

  users.users.lizzie = {
    isNormalUser = true;
    initialPassword = "thisisabadpassword";
    # sudo
    extraGroups = [ "wheel" ];
    # let me in
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKW4ofxuyFKtDXCHHR6UDf5hGolKwZqt3h7SFLCCy++6 james@baron"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPzFa1hmBsCrPL5HvJZhXVEaWiZIMi34oR6AOcKD35hQ james@countess"
    ];
  };

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  # kde
  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };

  # install some basic stuff for humans
  environment.systemPackages = with pkgs; [
    firefox
    libreoffice-still
    zoom-us
    vlc
  ];

}
